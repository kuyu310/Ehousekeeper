
//  AppDelegate.swift
//  E-housekeeper
//
//  Created by limeng on 2017/3/1.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit
import Alamofire
import UserNotifications
@UIApplicationMain


class AppDelegate: UIResponder,RCIMUserInfoDataSource,HyPopMenuViewDelegate,UIApplicationDelegate,RCIMReceiveMessageDelegate {
   
    
    
    
    /*!
     接收消息的回调方法
     
     @param message     当前接收到的消息
     @param left        还剩余的未接收的消息数，left>=0
     
     @discussion 如果您设置了IMKit消息监听之后，SDK在接收到消息时候会执行此方法（无论App处于前台或者后台）。
     其中，left为还剩余的、还未接收的消息数量。比如刚上线一口气收到多条消息时，通过此方法，您可以获取到每条消息，left会依次递减直到0。
     您可以根据left数量来优化您的App体验和性能，比如收到大量消息时等待left为0再刷新UI。
     */
    public func onRCIMReceive(_ message: RCMessage!, left: Int32) {
        print("reseive a message")
        
        if left == 0 {
           NotificationCenter.default.post(name: Notification.Name(rawValue: "RefreshConversationList"), object: nil)
          
            
        }
    }


    var window: UIWindow?
    var adViewController: ADViewController?
    var guideViewController: GuideViewController?
    
    public func popMenuView(_ popMenuView: HyPopMenuView!, didSelectItemAt index: UInt) {
        SVProgressHUD.showInfo(withStatus: "点击：\(index) 页面")    }

    //        融云服务器的设置相关全局方法
    
    func getUserInfo(withUserId userId: String!, completion: ((RCUserInfo?) -> Void)!){
        
        let userInfo = RCUserInfo()
        
      
        
        
        Alamofire.request("http://ojjpkscxv.bkt.clouddn.com/tokenJsonLogin_pic").responseJSON{response in
            
            switch response.result.isSuccess {
                
            case true:
                
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    switch userId {
                    case "111":
                        userInfo.name = "李萌"
                        userInfo.portraitUri = json["data"]["user"][0]["userPic"].string
                       
                    case "222":
                        userInfo.name = "黄谦"
                        userInfo.portraitUri = json["data"]["user"][1]["userPic"].string
                    case "333":
                        userInfo.name = "沈树人"
                        userInfo.portraitUri = json["data"]["user"][2]["userPic"].string
                        
                    case "444":
                        userInfo.name = "金晨康"
                        userInfo.portraitUri = json["data"]["user"][3]["userPic"].string
                    case "555":
                        userInfo.name = "赵天田"
                        userInfo.portraitUri = json["data"]["user"][4]["userPic"].string
                        
                    case "666":
                        userInfo.name = "单露"
                        userInfo.portraitUri = json["data"]["user"][5]["userPic"].string
                        
                    case "777":
                        userInfo.name = "颜成杰"
                        userInfo.portraitUri = json["data"]["user"][6]["userPic"].string
                        
                        
                    default:
                        print("无此用户")
                    }
                    
                    return completion(userInfo)
                    
                    
                }
                
                
            case false:
                print(response.result.error)
            }
            
            
            
        }

        
        
    }
    
    
    
    func getUserInfo(withUserId userId: String!, completion: ((userInfoTemp?) -> Void)!) {
        
        let userInfo = userInfoTemp()
        
//        var json: JSON?
        userInfo.userID = userId

        
        Alamofire.request("http://ojjpkscxv.bkt.clouddn.com/tokenJsonLogin_pic").responseJSON{response in
           
            switch response.result.isSuccess {
                
            case true:
                  
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    switch userId {
                    case "111":
                        userInfo.userNick = "李萌"
                        userInfo.userToken = json["data"]["user"][0]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][0]["userPic"].string
                        print(userInfo.userToken)
                    case "222":
                        userInfo.userNick = "黄谦"
                        userInfo.userToken = json["data"]["user"][1]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][1]["userPic"].string
                    case "333":
                        userInfo.userNick = "沈树人"
                        userInfo.userToken = json["data"]["user"][2]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][2]["userPic"].string
                        
                    case "444":
                        userInfo.userNick = "金晨康"
                        userInfo.userToken = json["data"]["user"][3]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][3]["userPic"].string
                    case "555":
                        userInfo.userNick = "赵天田"
                        userInfo.userToken = json["data"]["user"][4]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][4]["userPic"].string
                        
                    case "666":
                        userInfo.userNick = "单露"
                        userInfo.userToken = json["data"]["user"][5]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][5]["userPic"].string
                        
                    case "777":
                        userInfo.userNick = "颜成杰"
                        userInfo.userToken = json["data"]["user"][6]["userToken"].string
                        userInfo.userPicUrl = json["data"]["user"][6]["userPic"].string
                        
                        
                    default:
                        print("无此用户")
                    }
                    
                    return completion(userInfo)
                    
                    
                }
                
                
            case false:
                print(response.result.error)
            }
            
            
            
        }
        
        
        
    }
    
    //        连接融云的服务器
    func connectServer(userInfo: userInfoTemp, completion: @escaping ()-> Void) {
        
                
        var userToken: String = ""
        
       
            userToken = (userInfo.userToken)!
            
        

            //MARK: 1.3用Token测试连接
            RCIM.shared().connect(withToken: userToken, success: { (_) in
                //        如果获取token由服务器完成，不要在app端做，太复杂了，客户端登录本地服务器成功后，服务器从融云获取token，传回客户端，客户端用这个token进行登录
                let currentUserInfo = RCUserInfo(userId:userInfo.userID , name: userInfo.userNick, portrait: userInfo.userPicUrl)
                RCIMClient.shared().currentUserInfo = currentUserInfo
                
                DispatchQueue.main.async(execute: {
                    //MARK: 执行闭包
                    completion()
                })
                
                
            }, error: { (_) in
                print("连接失败")
            }) {
                print("Token不正确或已失效")
                //            服务端加一个接口回来，让客户端再起请求本地服务向融云申请token
                
                
                
                
            }


    }
    
    
    
    //退出登录
    func logout() {
    UIApplication.shared.applicationIconBadgeNumber = 0
        
        var userDefault:UserDefaults = UserDefaults.standard
   
        userDefault.removeObject(forKey: "userToken")
        userDefault.removeObject(forKey: "userCookie")
        userDefault.removeObject(forKey: "isLogin")
        userDefault.synchronize()
        let loginVC = LoginViewController()
        
        window!.rootViewController = UINavigationController.init(rootViewController: loginVC)

        //断开与融云服务器的连接，并不再接收远程推送
        RCIMClient.shared().logout()
        
    
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //初始化融云服务
        initRongClould()
        
//        registerAppNotificationSettings(launchOptions:launchOptions)
        
//       登录
        var userDefault:UserDefaults = UserDefaults.standard
        
        var token = userDefault.object(forKey: "userToken")
        var userId = userDefault.object(forKey: "useId")
        var userName = userDefault.object(forKey: "userName")
        var password = userDefault.object(forKey: "userPwd")
        var userNickName = userDefault.object(forKey: "userNickName")
        var userPortraitUri = userDefault.object(forKey: "userPortraitUri")

        

        
        
        
        
        
//        添加消息中心消息
        addNotification()
        WXAppConfiguration.setAppGroup("授权棒银企管家")
        WXAppConfiguration.setAppName("授权棒银企管家")
        WXAppConfiguration.setAppVersion("1.0.0")
        
        WXLog.setLogLevel(WXLogLevel.all)
        
        // register event module
        WXSDKEngine.registerModule("event", with: NSClassFromString("WXEventModule"))
        
        // register handler，注册协议，这个协议是load image的协议，weex并没有实现远程图片加载，需要自己实现这个协议
        WXSDKEngine.registerHandler(WXImageLoaderDefaultImplement(), with:NSProtocolFromString("WXImgLoaderProtocol"))
        
        //init WeexSDK
        WXSDKEngine.initSDKEnvironment()
        // 注册地图组件，高德地图
        WXSDKEngine.registerComponent("map", with: WXMapComponent.self)
//        WXSDKEngine.registerComponent("ble", with: WXBlutoochComponent.self)

        buildKeyWindow()
        
        
        return true
    }

    
    // MARK: - Public Method
    fileprivate func buildKeyWindow() {
        
        window = UIWindow(frame: ScreenBounds)
        window!.makeKeyAndVisible()
        
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        //UserDefaults 适合存储轻量级的本地客户端数据，比如记住密码功能，要保存一个系统的用户名、密码。使用 UserDefaults 是首选
        if isFristOpen == nil {
            guideViewController = GuideViewController()
            window!.rootViewController = UINavigationController.init(rootViewController: guideViewController!)
//          先测试用，屏蔽下面的这行
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
        } else {
            
            loadADRootViewController()
        }
    }
    
//MARK: load广告视图控制器
    func loadADRootViewController() {
        
//        adViewController = ADViewController()

        var adImageUrl:String?
       
        var data :Data?
        
            Alamofire.request("http://ojjpkscxv.bkt.clouddn.com/AD").responseData {response in

            switch response.result.isSuccess {
                
            case true:
                let data = response.result.value
                
                let path = Bundle.main.path(forResource: "AD", ofType: nil)
                
                
                do {
                    try data?.write(to: URL(fileURLWithPath: path!), options: .atomic)
                } catch {
                    print(error)
                }
                
        
                
            case false:
                print(response.result.error)
            }
            
            
            
            }
        
            
        
//        //从json文件中加载相关数据
           MjMainAD.loadADData( completion: { (data, error) -> Void in
            if data?.img_name != nil {
                adImageUrl = data!.img_name
                
                var LaunchAdPage = DHLaunchAdPageHUD.init(frame: ScreenBounds, aDduration: Int(6.0), isConnectNet: true, aDImageUrl: adImageUrl, hideSkipButton: false, launchAdClick: {() -> Void  in
//                    UIApplication.shared.openURL(URL.init(string: "https://www.sunyard.com")!)
                    
                })
                
            }
            else
            {
                //后面这里添加连不上网的情况
                
                var LaunchAdPage = DHLaunchAdPageHUD.init(frame: ScreenBounds, aDduration: Int(6.0), isConnectNet: false, aDImageUrl: adImageUrl, hideSkipButton: false, launchAdClick: {() -> Void  in
//                    UIApplication.shared.openURL(URL.init(string: "https://www.sunyard.com")!)
                    
                })
                
            }
        })

        
    }

    
    
    func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerSucess(_:)), name: NSNotification.Name(rawValue: ADImageLoadSecussed), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerFale), name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.shoMainTabBarController), name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.loginSuncessForMainTabbarController(_:)), name: NSNotification.Name(rawValue: loginSuncessForMainTabbar), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.loginFailForMainTabbarController(_:)), name: NSNotification.Name(rawValue: loginFailForMainTabbar), object: nil)
        
        
        
        
    }

    
    func loginSuncessForMainTabbarController(_ noti: Notification){
        
//        let mainViewController = MainViewController()
//        let mainViewController = MainTabBarController()
//        mainViewController.url = URL.init(string: String.init(format: "file://%@/bundlejs/index.js", Bundle.main.bundlePath))
        
//        window!.rootViewController = UINavigationController.init(rootViewController: mainViewController)
        //window!.rootViewController = mainViewController
        
        
        window!.rootViewController = ESMainTabbarController.customIrregularityStyle(delegate: nil)
        
        
    }
    func loginFailForMainTabbarController(_ noti: Notification){
        
        let mainViewController = MainTabBarController()
//        mainViewController.url = URL.init(string: String.init(format: "file://%@/bundlejs/index.js", Bundle.main.bundlePath))
        window!.rootViewController = UINavigationController.init(rootViewController: mainViewController)
        
    }
 
    func showMainTabbarControllerSucess(_ noti: Notification) {
        
        let mLoginViewController = LoginViewController()
        
        
        window!.rootViewController = UINavigationController.init(rootViewController: mLoginViewController)
        
        
    }

    func showMainTabbarControllerFale() {
        let mainViewController = MainTabBarController()
//         mainViewController.url = URL.init(string: String.init(format: "file://%@/bundlejs/index.js", Bundle.main.bundlePath))

        window!.rootViewController = UINavigationController.init(rootViewController: mainViewController)
    }
    
    func shoMainTabBarController() {
        let mainViewController = MainTabBarController()
//         mainViewController.url = URL.init(string: String.init(format: "file://%@/bundlejs/index.js", Bundle.main.bundlePath))

        
       
window!.rootViewController = UINavigationController.init(rootViewController: mainViewController)
    }

    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    
    
    
}



// MARK: - 设置应用程序额外信息
extension AppDelegate {
    
    private func setupAdditions() {
        
        // 1. 设置 SVProguressHUD 最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        
        
        // 2. 设置用户授权显示通知
        // #available 是检测设备版本，如果是 10.0 以上
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .carPlay, .sound]) { (success, error) in
                print("授权 " + (success ? "成功" : "失败"))
            }
        } else {
            // 10.0 以下
            // 取得用户授权显示通知[上方的提示条/声音/BadgeNumber]
            let notifySettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(notifySettings)
        }
    }
}
// MARK: - 从服务器加载应用程序信息
extension AppDelegate {
    
    fileprivate func loadAppInfo() {
        
//        // 1. 模拟异步
//        DispatchQueue.global().async {
//            
//            // 1> url
//            let url = Bundle.main.urlForResource("main.json", withExtension: nil)
//            
//            // 2> data
//            let data = NSData(contentsOf: url!)
//            
//            // 3> 写入磁盘
//            let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//            let jsonPath = (docDir as NSString).appendingPathComponent("main.json")
//
//            // 直接保存在沙盒，等待下一次程序启动使用！
//            data?.write(toFile: jsonPath, atomically: true)
//            
//            print("应用程序加载完毕 \(jsonPath)")
//        }
    }
    
//MARK: - 初始化融云服务器
    fileprivate func  initRongClould(){
        
        //MARK: 1.1查询userdefault中是否有Token
        //deviceToken是系统提供的，从苹果服务器获取的，用于APNs远程推送必须使用的设备唯一值。
        let deviceTokenCache = UserDefaults.standard.object(forKey: "kDeviceToken") as? String
        //MARK: 1.2初始化Appkey
        RCIM.shared().initWithAppKey(RONGCLOUD_IM_APPKEY)
        RCIMClient.shared().setDeviceToken(deviceTokenCache)
        //MARK: 3 设置用户信息提供者为自己--融云
        RCIM.shared().userInfoDataSource = self
        
        RCIM.shared().receiveMessageDelegate = self
        //开启输入状态监听
        
        RCIM.shared().enableTypingStatus = true
        //开启消息撤回功能
        
        RCIM.shared().enableMessageRecall = true
        
        //开启用户信息和群组信息的持久化
        RCIM.shared().enablePersistentUserInfoCache = true
        //开启发送已读回执
        RCIM.shared().enabledReadReceiptConversationTypeList = [RCConversationType.ConversationType_PRIVATE,RCConversationType.ConversationType_DISCUSSION,RCConversationType.ConversationType_GROUP]
        
        RCIM.shared().enableTypingStatus = true
        RCIM.shared().enableMessageAttachUserInfo = true;
        
        
        //注册
        RCIM.shared().registerMessageType(RCDTestMessage.self)
        RCIM.shared().registerMessageType(WMVideoMessage.self)
        
    }
    
    

}
class userInfoTemp
{
    var userNick: String?
    
    var userToken: String?
    
    var userID: String?
    
    var userPicUrl: String?
    
    
    
}
