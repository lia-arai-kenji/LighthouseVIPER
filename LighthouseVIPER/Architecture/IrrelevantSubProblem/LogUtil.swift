//
//  OSLogExtension.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2025/01/19.
//

import OSLog


extension OSLogType: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .info:
            return "INFO"
 
        case .debug:
            return "DEBUG"
 
        case .error:
            return "ERROR"
 
        case .fault:
            return "FAULT"
 
        default:
            return "DEFAULT"
        }
    }
}

struct LogUtil {
    
    static func debug(
        _ message: String = "",
        osLog: OSLog = .default,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        doLog(
            message: message,
            osLog: osLog,
            logType: .debug,
            file: file,
            function: function,
            line: line
        )
    }
    
    private static func doLog(
        message: String,
        osLog: OSLog,
        logType: OSLogType = .default,
        file: String,
        function: String,
        line: Int
    ) {
        #if DEBUG
            guard var f = file.split(separator: "/").last else { return }
            if let r = f.range(of: ".swift") {
                f.removeSubrange(r)
            }
            f.append(contentsOf: ".")
            os_log(
                "[%@] %@%@:%d %@",
                log: osLog,
                type: logType,
                String(describing: logType),
                f as CVarArg,
                function,
                line,
                message
            )
        #endif
    }
}
