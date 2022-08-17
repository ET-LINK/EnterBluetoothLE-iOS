//
//  File.swift
//  
//
//  Created by Enter on 2022/4/15.
//

import CombineCoreBluetooth
import Combine
import PromiseKit

public class EnterCentralManager {
    
    public let centralManager: CentralManager
    
    public class func setup(identifierKey: String) {
        restoreIdentifierKey = identifierKey
    }
    
    public init() {
        if EnterCentralManager.restoreIdentifierKey != nil {
            centralManager = .live(.init(showPowerAlert: true, restoreIdentifierKey: EnterCentralManager.restoreIdentifierKey))
        } else {
            
            centralManager = .live()
        }
    }
    
    //param
    static var restoreIdentifierKey: String?
    var cancellables: Set<AnyCancellable> = []
    var peripherals: [PeripheralDiscovery] = []
    var scanTask: AnyCancellable?
    
    /// 检索周边设备
    /// - Parameters:
    ///   - interval: 扫描时间
    ///   - services: 连接服务
    ///   - mac: 物理地址, 默认为空, 当有字段时, 按照广播物理地址连接
    /// - Returns: 扫描到的设备列表
    public func searchForPeripherals(in interval: TimeInterval, services: [CBUUID], mac: Data? = nil) -> Promise<[PeripheralDiscovery]> {
        scanTask = centralManager.scanForPeripherals(withServices: services)
            .scan([], { list, discovery -> [PeripheralDiscovery] in
                guard !list.contains(where: { $0.id == discovery.id}) else { return list } //避免重复
                guard (mac == nil ? true : mac == discovery.advertisementData.manufacturerData) else {return list} //过滤mac地址
              return list + [discovery]
            }).sink(receiveValue: { list in
                self.peripherals.removeAll()
                self.peripherals.append(contentsOf: list)
            })
            
        return Promise.init { resolver in
            DispatchQueue.global().asyncAfter(deadline: DispatchTime.now()+interval) {
                self.stopSearching()
                resolver.fulfill(self.peripherals)
            }
        }
    }
    
    
    /// 停止扫描
    public func stopSearching() {
        scanTask?.cancel()
        scanTask = nil
    }
    
    
    /// 连接设备
    /// - Parameter discovery: 扫描到的设备列表中的设备
    /// - Returns: 周边设备的服务
    public func connect(_ discovery: PeripheralDiscovery) -> Promise<Peripheral> {

        return Promise.init { resolver in
            centralManager.connect(discovery.peripheral)
                .sink { completion in
                guard case let .failure(error) = completion else { return }
                
                resolver.reject(error)
            } receiveValue: { peripheral in
                resolver.fulfill(peripheral)
            }.store(in: &cancellables)
        }
        
    }
    
    
    /// 断开连接
    /// - Parameter peripheral: 需要断开的周边
    public func disconnect(peripheral: Peripheral) {
        centralManager.cancelPeripheralConnection(peripheral)

    }
    
    
    /// 断开通知
    /// - Returns: 监听
    public func disconnectPublisher() -> AnyPublisher<(Peripheral, Error?), Never> {
        return centralManager.didDisconnectPeripheral
    }
    
    
    /// 连接通知
    /// - Returns: 监听内容
    public func connectSuccessPublisher() -> AnyPublisher<Peripheral, Never> {
        return centralManager.didConnectPeripheral
    }
    
    
    /// 连接失败通知
    /// - Returns: 监听内容
    public func connectFailPublisher() -> AnyPublisher<(Peripheral, Error?), Never> {
        return centralManager.didFailToConnectPeripheral
    }
    
    
    /// 获取服务中的特征
    /// - Parameters:
    ///   - peripheral: 周边
    ///   - id: 特征id
    ///   - service: 服务id
    /// - Returns: 特征
    public func getCharacteristic(peripheral: Peripheral, id: CBUUID, in service: CBUUID) -> Promise<CBCharacteristic> {
        Promise.init { res in
            peripheral.discoverCharacteristic(withUUID: id, inServiceWithUUID: service)
                .sink { completion in
                    guard case let .failure(error) = completion else { return }
                    
                    res.reject(error)
                } receiveValue: { characteristic in
                    res.fulfill(characteristic)
                }.store(in: &cancellables)
        }
        
    }
    
    /// 释放
    public func clear() {
        stopSearching()
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        cancellables.removeAll()
    }

}

