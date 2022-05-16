//
//  File.swift
//  
//
//  Created by Enter on 2022/4/18.
//

import Foundation

enum EnterBLEError {
    case ble(type: Enums.BLEError)
    case file(type: Enums.FileError)
    case custom(errorDescription: String?)

    class Enums { }
}

extension EnterBLEError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .ble(let type): return type.localizedDescription
        case .file(let type): return type.localizedDescription
        case .custom(let errorDescription): return errorDescription
        }
    }
}

// MARK: - Network Errors

extension EnterBLEError.Enums {
    
    enum BLEError {
        case scanFail
        case connectFail
        case busy
        case timeout
        case invalid(errorCode: Int, errorDescription: String)
    }
}

extension EnterBLEError.Enums.BLEError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .scanFail:
            return "Scan Failed"
        case .connectFail:
            return "Connect Failed"
        case .busy:
            return "Device is Busy"
        case .timeout:
            return "Timeout"
        case .invalid(errorCode: let errorCode, errorDescription: let errorDescription):
            return "Error Code: \(errorCode), \(errorDescription)"
        }
    }

}


// MARK: - FIle Errors

extension EnterBLEError.Enums {
    enum FileError {
        case read(path: String)
        case write(path: String, value: Any)
        case custom(errorDescription: String?)
    }
}

extension EnterBLEError.Enums.FileError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .read(let path): return "Could not read file from \"\(path)\""
            case .write(let path, let value): return "Could not write value \"\(value)\" file from \"\(path)\""
            case .custom(let errorDescription): return errorDescription
        }
    }
}
