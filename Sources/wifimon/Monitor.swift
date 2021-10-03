import Foundation
import CoreWLAN

class Monitor {
    
    // MARK: - Public Properties
    
    public var isOn: Bool {
        return interface.powerOn()
    }
    public var interfaceName: String {
        return interface.interfaceName ?? "Unknown interface"
    }
    public var linkQualityPct: Int {
        return min(2 * (interface.rssiValue() + 100), 100)
    }
    public var rssi: Int {
        return interface.rssiValue()
    }
    public var noise: Int {
        return interface.noiseMeasurement()
    }
    public var ssid: String {
        return interface.ssid() ?? "N/A"
    }
    public var bssid: String {
        return interface.bssid() ?? "N/A"
    }
    public var mode: String {
        return "\(interface.interfaceMode())"
    }
    public var band: String {
        guard let band = interface.wlanChannel()?.channelBand else {
            return "N/A"
        }
        return "\(band)"
    }
    public var channel: String {
        guard let channel = interface.wlanChannel()?.channelNumber else {
            return "N/A"
        }
        
        return String(channel)
    }
    public var channelWidth: String {
        guard let channelWidth = interface.wlanChannel()?.channelWidth else {
            return "N/A"
        }
        return "\(channelWidth)"
    }
    public var security: String {
        return "\(interface.security())"
    }
    public var transmitPower: String {
        return "\(interface.transmitPower())"
    }
    public var transmitRate: String {
        return "\(interface.transmitRate())"
    }
    public var essid: String {
        guard let e = interface.hardwareAddress() else {
            return "N/A"
        }
        return e
    }
    public var phyMode: String {
        return "\(interface.activePHYMode().description)"
    }
    public var ipAddress: String {
        return getAddress() ?? "N/A"
    }
    
    // MARK: - Private Properties
    
    fileprivate var client: CWWiFiClient
    fileprivate var interface: CWInterface
    
    // MARK: - Lifecycle
    
    init?() {
        
        client = CWWiFiClient.shared()
        
        guard let i = client.interface() else {
            return nil
        }
        
        self.interface = i
        
    }
    
    fileprivate func getAddress() -> String? {
        
        var address: String?
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            
            let interface = ifptr.pointee
            let addrFamily = interface.ifa_addr.pointee.sa_family
            
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                let name = String(cString: interface.ifa_name)
                
                if name == self.interfaceName {
                    
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        
        freeifaddrs(ifaddr)
        
        return address
    
    }
    
    
}
