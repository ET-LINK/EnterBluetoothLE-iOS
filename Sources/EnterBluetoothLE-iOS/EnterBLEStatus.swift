//
//  File.swift
//  
//
//  Created by Enter on 2022/4/18.
//

import Foundation

/// BLE connect State
///
/// - disconnected: 断开或未连接
/// - searching: 搜索中
/// - connecting: 连接中
/// - connected: 连接成功
public enum BLEConnectionState {
    
    case disconnected
    case searching
    case connecting
    case connected
}

extension BLEConnectionState: Equatable {
    public static func == (lhs: BLEConnectionState, rhs: BLEConnectionState) -> Bool {
        switch (lhs, rhs) {
        case (.disconnected, .disconnected), (.searching, .searching), (.connecting, .connecting):
            return true
        case ( .connected, .connected):
            return true
        default:
            return false
        }
    }
}


/// 电量信息
public struct Battery {
    /// 当前电压（伏特）
    public let voltage: Float
    /// 遗留电量（小时），仅供参考
    public let remain: Int
    /// 电量百分比值 [0, 100]
    public let percentage: Float
}

/// 基本设备信息
public struct BLEDeviceInfo {
    /// 设备名称
    public internal(set) var name: String = ""
    /// 设备硬件版本
    public internal(set) var hardware: String = ""
    /// 设备固件版本
    public internal(set) var firmware: String = ""
    /// 设备 mac 地址
    public internal(set) var mac: String = ""
}
