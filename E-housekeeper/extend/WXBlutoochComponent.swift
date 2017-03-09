//
//  WXBlutoochComponent.swift
//  Ehousekeeper
//  微信的蓝牙组件
//  Created by limeng on 2017/3/9.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
import UIKit



class WXBlutoochComponent: WXComponent{
    
    let baby = BabyBluetooth.share();
    let testPeripleralName = "JDY-08";
    let characteristicName = "FEE7"
    
    let DescriptorNameForWrite = "FEC7"
    let DescriptorNameForNodify = "FEC8"
    
    let channelOnPeropheral = "channelOnPeropheral"
    let channelOnCharacteristic = "channelOnCharacteristic"
    
   
    
    var currPeripheral :CBPeripheral?
    var currcharacteristic : CBCharacteristic?
    var services = [NSMutableArray]()
    
    //这是爆漏给js的标签选项
    override init(ref: String, type: String, styles: [AnyHashable : Any]?, attributes: [AnyHashable : Any]? = nil, events: [Any]?, weexInstance: WXSDKInstance) {
        super.init(ref: ref, type: type, styles: styles, attributes: attributes, events: events, weexInstance: weexInstance);
       
    }
    
    
    
    
    
    
//    复位蓝牙
    func restartBle(){
        //停止之前的连接
        baby?.cancelAllPeripheralsConnection()
        //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
        baby?.scanForPeripherals().begin()
        
        
    }
// 停止扫描服务
    func CancelScan(){
       
        baby?.cancelScan()
    }
 
    //  发现蓝牙设备 实例方法
  func DiscoverToPeripherals(){
        //设置查找Peripherals的规则
        baby?.setFilterOnDiscoverPeripherals { (name, adv, RSSi) -> Bool in
            if let name = adv?["kCBAdvDataLocalName"] as? String {
                if name == self.testPeripleralName as String {
                    return true;
                }
                
            }
            return false
        }
        //        设置连接Peripherals的规则
        //        kCBAdvDataLocalName是广播包中的固定名称，是蓝牙模块的规则名称
        baby?.setFilterOnConnectToPeripherals { (name, adv, RSSI) -> Bool in
            if let name = adv?["kCBAdvDataLocalName"] as? String {
                if (name == self.testPeripleralName){
                    return true;
                }
                
            }
            return false;
        }
        
        //        找到Peripherals的block
        baby?.setBlockOnDiscoverToPeripherals { (centralManager, peripheral, adv, RSSI) in
           
        };
        
        //        连接Peripherals成功的block
        baby?.setBlockOnConnected { (centralManager, peripheral) in
            print("connect on :\(peripheral?.name)");
//            把外设传出来
            self.currPeripheral = peripheral
//            停止扫描
            self.CancelScan()
            
            SVProgressHUD.showInfo(withStatus: peripheral?.name)
            
            
        };
        //        设置查找服务的block
        baby?.setBlockOnDiscoverServices { (p, error) in
            print("discover services:\(p?.services)");
        }
        //        设置查找到Characteristics的block
        baby?.setBlockOnDiscoverCharacteristics { (p, s, err) in
            print("discover characteristics:\(s?.characteristics) on uuid \(s?.uuid.uuidString)");
        }
        
        baby?.scanForPeripherals().enjoy();
        
    }
//    设置发现设备的服务和特征委托
    func BabyDelegateForPeripheralServer(){
        
        
        let rhythm = BabyRhythm()
        
        
        //设置读取characteristics的委托
        baby?.setBlockOnConnectedAtChannel(channelOnPeropheral, block: { (central, peripheral) in
            print("外设名称:\(peripheral?.name)")
        })
        
  

        
        //设置设备连接失败的委托
        baby?.setBlockOnFailToConnectAtChannel(channelOnPeropheral, block: { (central, peripheral, error) in
            print("设备连接失败\(peripheral?.name)")
            
        })
        
          //设置设备断开连接的委托
        baby?.setBlockOnDisconnectAtChannel(channelOnPeropheral, block: { (central, peripheral, error) in
            print("设备：断开连接 \(peripheral?.name)");
        })
        
        
      //设置发现设备的Services的委托
        baby?.setBlockOnDiscoverServicesAtChannel(channelOnPeropheral, block: { (peripheral, error) in
//            rhythm.beats()  //建立心跳
        })
        
        //设置发现设service的Characteristics的委托
    
        baby?.setBlockOnDiscoverCharacteristicsAtChannel(channelOnPeropheral, block: { (peripheral, service, error) -> Void in
//            print("===service name:%@",service?.uuid);
            
            for c in (service?.characteristics!)! {
                
                if c.uuid.uuidString == self.DescriptorNameForNodify{
                    
                    peripheral?.setNotifyValue(true, for: c)
                    
                    
                }
                
                
                
                if c.uuid.uuidString == self.DescriptorNameForWrite{
                    
                    self.currcharacteristic = c
                }
            }
            
            
            

        })
        
        //设置读取characteristics的委托
        baby?.setBlockOnReadValueForCharacteristicAtChannel(channelOnPeropheral, block: { (peripheral, characteristic, error) in
//            将特征付对象传出去
           
            
            print("characteristic name:%@ value is:%@",characteristic?.uuid as Any,characteristic?.value)
        })
        
        //设置发现characteristics的descriptors的委托
         baby?.setBlockOnDiscoverDescriptorsForCharacteristicAtChannel(channelOnPeropheral, block: { (peripheral, characteristic, error) in
            print("===characteristic name:%@",characteristic?.service.uuid);
         })
        
        //设置beats break委托
        rhythm.setBlockOnBeatsBreak { (bry) in
            print("setBlockOnBeatsBreak call");
        }
        
        //设置beats over委托
         rhythm.setBlockOnBeatsOver { (bry) in
            NSLog("setBlockOnBeatsOver call");
        }
        
        let scanForPeripheralsWithOptions = ["CBCentralManagerScanOptionAllowDuplicatesKey" : 1]
        
     
            
        let connectOptions = ["CBConnectPeripheralOptionNotifyOnConnectionKey" : 1,
            "CBConnectPeripheralOptionNotifyOnDisconnectionKey":1,
            "CBConnectPeripheralOptionNotifyOnNotificationKey":1];
        
        
       
        
        baby?.setBabyOptionsAtChannel(channelOnPeropheral, scanForPeripheralsWithOptions: scanForPeripheralsWithOptions, connectPeripheralWithOptions: connectOptions, scanForPeripheralsWithServices: nil, discoverWithServices: nil, discoverWithCharacteristics: nil)
        
        
        loadDataForPeripheral()
    }
    func loadDataForPeripheral(){
        
        baby?.having(self.currPeripheral).and().channel(channelOnPeropheral).then().connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin()
        
        
    }
    
    func writeValue(s:String){
        

    
       BabyToy.writeValue(self.currPeripheral, characteristic: self.currcharacteristic)
        
    }

    

}
