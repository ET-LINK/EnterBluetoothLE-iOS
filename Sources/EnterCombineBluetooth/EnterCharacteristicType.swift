//
//  File.swift
//  
//
//  Created by Enter on 2022/4/15.
//

import Foundation
import CoreBluetooth

public struct CBUUIDSerivice {
    public static var connect: CBUUID = EnterCharacteristic.Connect.Service.uuid.cbUuid
    public static var command: CBUUID = EnterCharacteristic.Command.Service.uuid.cbUuid
    public static var multipeOp: CBUUID = EnterCharacteristic.MultipleOp.Service.uuid.cbUuid
    public static var dfu: CBUUID = EnterCharacteristic.DFU.Service.uuid.cbUuid
    public static var singleOp: CBUUID = EnterCharacteristic.SingleOp.Service.uuid.cbUuid
    public static var deviceInfo: CBUUID = EnterCharacteristic.DeviceInfo.Service.uuid.cbUuid
    public static var battery: CBUUID = EnterCharacteristic.Battery.Service.uuid.cbUuid
    public static var extend1: CBUUID?
    public static var extend2: CBUUID?
}

public protocol CharacteristicType {
    var cbUuid: CBUUID { get }
}

extension CharacteristicType where Self : RawRepresentable {
    public var cbUuid: CBUUID {
        return CBUUID(string: self.rawValue as! String)
    }
}

public protocol CharacteristicReadType: CharacteristicType {}

public protocol CharacteristicWriteType: CharacteristicType {}

public protocol CharacteristicNotifyType: CharacteristicType {}

public protocol CharacteristicServiceType: CharacteristicType {}

public enum EnterCharacteristic {
    
    public enum DeviceInfo {
        public enum Read: String, CharacteristicReadType {
            case mac = "2A24"
            case serial = "2A25"
            case firmwareRevision = "2A26"
            case hardwareRevision = "2A27"
            case manufacturer = "2A29"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "180A"
        }
    }

    public enum Battery {
        public enum Notify: String, CharacteristicReadType, CharacteristicNotifyType {
            case battery = "2A19"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "180F"
        }
    }

    public enum Command {
        public enum Write: String, CharacteristicWriteType {
            case send = "0000FF21-1212-ABCD-1523-785FEABCD123"
        }
        public enum Notify: String, CharacteristicNotifyType {
            case receive = "0000FF22-1212-ABCD-1523-785FEABCD123"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "0000FF20-1212-ABCD-1523-785FEABCD123"
        }
    }

    public enum Connect {
        public enum Write: String, CharacteristicWriteType {
            case config = "0000FF11-1212-ABCD-1523-785FEABCD123"
        }
        public enum Notify: String, CharacteristicNotifyType {
            case state = "0000FF13-1212-ABCD-1523-785FEABCD123"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "0000FF14-1212-ABCD-1523-785FEABCD123"
        }
    }
    
    public enum MultipleOp {
        public enum MultipleNotify: String, CharacteristicNotifyType {
            case data = "0000FF31-1212-ABCD-1523-785FEABCD123"
            case contact = "0000FF32-1212-ABCD-1523-785FEABCD123"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "0000FF30-1212-ABCD-1523-785FEABCD123"
        }
    }


    public enum DFU {
        public enum Operation: String, CharacteristicWriteType {
            case control = "0000FF41-1212-ABCD-1523-785FEABCD123"
            case package = "0000FF42-1212-ABCD-1523-785FEABCD123"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "0000FF40-1212-ABCD-1523-785FEABCD123"
        }
    }


    public enum SingleOp {
        public enum Notify: String, CharacteristicNotifyType {
            case data = "0000FF51-1212-ABCD-1523-785FEABCD123"
        }
        public enum Service: String, CharacteristicServiceType {
            case uuid = "0000FF50-1212-ABCD-1523-785FEABCD123"
        }
    }
}
