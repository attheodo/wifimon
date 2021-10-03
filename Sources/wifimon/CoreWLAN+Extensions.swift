import Foundation
import CoreWLAN

extension CWChannelBand: CustomStringConvertible {
    public var description: String {
        switch self {
        case .bandUnknown:
            return "Unknown"
        case .band2GHz:
            return "2.4Ghz"
        case .band5GHz:
            return "5Ghz"
        @unknown default:
            return "Unknown"
        }
    }
}

extension CWPHYMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .modeNone:
            return "None"
        case .mode11a:
            return "802.11a"
        case .mode11b:
            return "802.11b"
        case .mode11ac:
            return "802.11ac"
        case .mode11g:
            return "802.11g"
        case .mode11n:
            return "802.11n"
        @unknown default:
            return "Unknown"
        }
    }
}

extension CWSecurity: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .WEP:
            return "WEP"
        case .wpaPersonal:
            return "WPA Personal"
        case .wpaPersonalMixed:
            return "WPA Personal Mixed"
        case .wpa2Personal:
            return "WPA2 Personal"
        case .wpa2Enterprise:
            return "WPA2 Enterprise"
        case .personal:
            return "Personal"
        case .dynamicWEP:
            return "Dynamic WEP"
        case .wpaEnterpriseMixed:
            return "WPA Enterprise Mixed"
        case .enterprise:
            return "Enterprise"
        case .wpa3Personal:
            return "WPA3 Personal"
        case .wpa3Enterprise:
            return "WPA3 Enterprise"
        case .wpa3Transition:
            return "WPA3 Transition"
        case .wpaEnterprise:
            return "WPA Enterprise"
        case .unknown:
            return "Unknown"
        @unknown default:
            return "Unknown"
        }
    }
}

extension CWInterfaceMode: CustomStringConvertible {
    public var description: String {
        switch self {
        case .none:
            return "None"
        case .IBSS:
            return "IBBS"
        case .hostAP:
            return "Host AP"
        case .station:
            return "Station"
        @unknown default:
            return "Unknown"
        }
    }
}

extension CWChannelWidth: CustomStringConvertible {
    public var description: String {
        switch self {
        case .width160MHz:
            return "160Mhz"
        case .width20MHz:
            return "20Mhz"
        case .width40MHz:
            return "40Mhz"
        case .width80MHz:
            return "80Mhz"
        case .widthUnknown:
            return "Unknown"
        @unknown default:
            return "Unknown"
        }
    }
}



