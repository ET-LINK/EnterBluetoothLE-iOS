//
//  File.swift
//  
//
//  Created by Enter on 2022/4/18.
//

import Foundation

public enum EnterBLEError {
    case ble(type: Enums.BLEError)
    case custom(errorDescription: String?)

    public class Enums { }
}

extension EnterBLEError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ble(let type): return type.localizedDescription
        case .custom(let errorDescription): return errorDescription
        }
    }
}

// MARK: - Network Errors

extension EnterBLEError.Enums {
    
    public enum BLEError {
        case scanFail
        case connectFail
        case busy
        case timeout
        case invalid(errorCode: Int, errorDescription: String)
    }
}

extension EnterBLEError.Enums.BLEError: LocalizedError {
    public var errorDescription: String? {
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

