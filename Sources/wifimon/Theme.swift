import Foundation
import ConsoleKit

struct Theme {
    static let labelStyle:  ConsoleStyle = .init(color: .brightBlack, isBold: false)
    static let valueStyle:  ConsoleStyle = .init(color: .white, isBold: true)
    static let headerStyle: ConsoleStyle = .init(color: .brightGreen, isBold: true)
    
    struct ProgressBar {
        static let green  = ConsoleColor.palette(154)
        static let yellow = ConsoleColor.palette(226)
        static let orange = ConsoleColor.palette(214)
        static let red    = ConsoleColor.palette(160)
    }
}
