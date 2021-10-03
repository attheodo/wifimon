import Foundation
import ConsoleKit

// MARK: - Public Properties

let console = Terminal()
let rssiLowerBound = -80
let rssiUpperBound = -25
let snrLowerBound = 12
let snrUpperBound = 40

// MARK: - Private Properties

fileprivate var monitor: Monitor!
fileprivate var timer: Timer?

func main() {
    
    guard let m = Monitor() else {
        console.error("Could not get interface")
        exit(EXIT_FAILURE)
    }
    
    monitor = m
    
    timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
        print(from: monitor)
    }
    
}

func print(from monitor: Monitor) {
    
    guard monitor.isOn else {
        console.print("Interface \(monitor.interfaceName) is not powered on")
        console.clear(lines: 1)
        
        return
    }
    
    // MARK: Signal
    
    let rssi = monitor.rssi
    let rssiNormalized = map(minRange: rssiLowerBound, maxRange: rssiUpperBound, minDomain: 0, maxDomain: 100, value: rssi)
    var rssiQualifiedString = "N/A"
    
    switch rssi {
    case -100 ... -90:
        rssiQualifiedString = "No connection"
    case -91 ... -80:
        rssiQualifiedString = "Unreliable"
    case -81 ... -70:
        rssiQualifiedString = "Bare minimum"
    case -71 ... -67:
        rssiQualifiedString = "Fair"
    case -68 ... -50:
        rssiQualifiedString = "Good"
    case -51 ... -30:
        rssiQualifiedString = "Excellent"
    case -31 ... 0:
        rssiQualifiedString = "Phenomenal"
    default:
        rssiQualifiedString = "N/A"
    }
    
    console.output(ConsoleText(fragments: [
        ConsoleTextFragment(string: "\nSignal:", style: Theme.headerStyle),
        ConsoleTextFragment(string: " \(rssi) dBm", style: Theme.valueStyle),
        ConsoleTextFragment(string: " (\(rssiQualifiedString))", style: Theme.labelStyle),
        ConsoleTextFragment(string: "\n-80dBm ... -71dBm: Bare minimum\t0: More than -51 dBm: Excellent", style: Theme.labelStyle)
    ]))
    printProgress(value: rssiNormalized)
    
    // MARK: Noise
    
    let noise = monitor.noise
    console.output(ConsoleText(fragments: [
        ConsoleTextFragment(string: "\nNoise:", style: Theme.headerStyle),
        ConsoleTextFragment(string: " \(noise) dBm", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\n-100: No noise\t0: Lots of noise", style: Theme.labelStyle)
    ]))
    printProgress(value: Int(100 + noise), inverseColorSentiment: true)
    
    // MARK: SNR
                  
    let snr = rssi - noise
    let snrNormalized = map(minRange: snrLowerBound, maxRange: snrUpperBound, minDomain: 0, maxDomain: 100, value: snr)
    
    console.output(ConsoleText(fragments: [
        ConsoleTextFragment(string: "\nSNR:", style: Theme.headerStyle),
        ConsoleTextFragment(string: " \(snr) dBm (\(snr)/\(snrUpperBound))", style: Theme.valueStyle),
        ConsoleTextFragment(string: " (\(min(snrNormalized, 100))% of theoretical max speed)", style: Theme.labelStyle),
        ConsoleTextFragment(string: "\n\(snrLowerBound) dBM: No Connection\t\(snrUpperBound)dbm: Perfect", style: Theme.labelStyle)
    ]))
    printProgress(value: snrNormalized)
    
    // MARK: - Info
    
    console.output(ConsoleText(fragments: [
        ConsoleTextFragment(string: "\nInfo", style: Theme.headerStyle),
        ConsoleTextFragment(string: "\nBSSID:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.bssid)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\t\tMode:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.mode)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\t\tAccess Point:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.ssid)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\n Band:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.band)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\t\tChannel:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.channel)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\t\tSecurity:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.security)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\nPower:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.transmitPower) mW", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\t\tTx Rate:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.transmitRate) Mbps", style: Theme.valueStyle),
    ]))
    
    // MARK: - Interface
    
    console.output(ConsoleText(fragments: [
        ConsoleTextFragment(string: "\nInterface", style: Theme.headerStyle),
        ConsoleTextFragment(string: "\n Name:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.interfaceName)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\t\tESSID:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.essid)", style: Theme.valueStyle),
        ConsoleTextFragment(string: "\tAddress:", style: Theme.labelStyle),
        ConsoleTextFragment(string: " \(monitor.ipAddress)", style: Theme.valueStyle),
    ]))
    
    console.clear(lines: 20)
    
}

func map(minRange:Int, maxRange:Int, minDomain:Int, maxDomain:Int, value:Int) -> Int {
    
    var v = minDomain + (maxDomain - minDomain) * (value - minRange) / (maxRange - minRange)
    v = min(v, maxDomain)
    v = max(v, 0)
    
    return v
}

func printProgress(value: Int, inverseColorSentiment: Bool = false) {

    let v = max(value, 0)
    
    var barColor: ConsoleColor = .black
    
    switch value {
    case 0...25:
        barColor = inverseColorSentiment ? Theme.ProgressBar.green : Theme.ProgressBar.red
    case 26...50:
        barColor = inverseColorSentiment ? Theme.ProgressBar.yellow : Theme.ProgressBar.orange
    case 51...75:
        barColor = inverseColorSentiment ? Theme.ProgressBar.orange : Theme.ProgressBar.yellow
    case 76...100:
        barColor = inverseColorSentiment ? Theme.ProgressBar.red : Theme.ProgressBar.green
    default:
        barColor = .black
    }
    
    console.output(ConsoleText(fragments: [
        ConsoleTextFragment(string: String(repeating: "▄", count: min(v, 100)), style: .init(color: barColor)),
        ConsoleTextFragment(string: String(repeating: "▁", count: max(100-v, 0)), style: .init(color: .brightBlack))
    ]))
    
}

main()
RunLoop.main.run()
