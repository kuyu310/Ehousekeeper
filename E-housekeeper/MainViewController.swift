//
//  ViewController.swift
//  E-housekeeper
//
//  Created by limeng on 2017/3/1.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit


class MainViewController: BaseViewController ,UIGestureRecognizerDelegate{

    var instance:WXSDKInstance?;
    var weexView = UIView()
    var weexHeight:CGFloat?;
    var top:CGFloat?;
    var url:URL?;
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(false, animated: false)

        
        render()
//搜索蓝牙设备
        DiscoverToPeripherals()

    }

    override func viewDidAppear(_ animated: Bool) {
//        baby?.cancelAllPeripheralsConnection()
//        baby?.scanForPeripherals().begin()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }


    deinit {
        if instance != nil {
            instance!.destroy()
        }
    }
    // 停止扫描服务
    func CancelScan(){
        
        baby?.cancelScan()
    }

//  发现蓝牙设备
    func DiscoverToPeripherals(){
        
        let rhythm = BabyRhythm()
        
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
                     // 停止扫描
                    self.CancelScan()
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
            
            SVProgressHUD.showInfo(withStatus: "设备连接成功：\(peripheral?.name)!")
            
            
        };
        
        baby?.setBlockOnFailToConnect({ (centralManager, peripheral, error) in
            SVProgressHUD.showInfo(withStatus: "设备连接失败：\(peripheral?.name)")
        })
        
        baby?.setBlockOnDisconnect({ (centralManager, peripheral, error) in
            SVProgressHUD.showInfo(withStatus: "设备断开连接：\(peripheral?.name)")
            self.baby?.autoReconnect(peripheral)
            SVProgressHUD.showInfo(withStatus: "设备自动重连：\(peripheral?.name)")
        })
        
        //        设置查找服务的block
        baby?.setBlockOnDiscoverServices { (p, error) in
            print("discover services:\(p?.services)");
            
            
             rhythm.beats()
            
            
        }
        //        设置查找到Characteristics的block
        baby?.setBlockOnDiscoverCharacteristics { (p, s, err) in
            print("discover characteristics:\(s?.characteristics) on uuid \(s?.uuid.uuidString)");
            
            for c in (s?.characteristics!)! {
                
                if c.uuid.uuidString == self.DescriptorNameForNodify{
                    
                    p?.setNotifyValue(true, for: c)
                    
                     }
                
                if c.uuid.uuidString == self.DescriptorNameForWrite{
                    
                    self.currcharacteristic = c
                    self.writeValue()
                }
            }

            
            
        }
        //设置beats break委托
        rhythm.setBlockOnBeatsBreak { (bry) in
            print("setBlockOnBeatsBreak call")
        }
        
        //设置beats over委托
        rhythm.setBlockOnBeatsOver { (bry) in
            print("setBlockOnBeatsOver call")
        }

        
        
        baby?.scanForPeripherals().enjoy()
        
    }
 
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
    func writeValue(){
        BabyToy.writeValue(self.currPeripheral, characteristic: self.currcharacteristic)
        
    }
    
    
    
    
    func render(){
        if instance != nil {
            instance!.destroy()
        }
        instance = WXSDKInstance();
        instance!.viewController = self
        let width = self.view.frame.size.width
        
        instance!.frame = CGRect(x: 0, y: NavigationH, width: width, height: self.view.frame.size.height)
        weak var weakSelf:MainViewController? = self
        
       
        instance?.onCreate = {
            (view:UIView?)-> Void in
            weakSelf!.weexView.removeFromSuperview()
            weakSelf!.weexView = view!;
            weakSelf!.view.addSubview(self.weexView)
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, weakSelf!.weexView)
        }
        
        instance?.onFailed = {
            (error:Error?)-> Void in
            
            print("faild at error: %@", error!)
        }
        
        instance?.renderFinish = {
            (view:UIView?)-> Void in
            print("render finish")
        }
        instance?.updateFinish = {
            (view:UIView?)-> Void in
            print("update finish")
        }
        
        instance!.render(with: url!, options: ["bundleUrl":String.init(format: "file://%@/bundlejs/", Bundle.main.bundlePath)], data: nil)
    }
    
    
}

