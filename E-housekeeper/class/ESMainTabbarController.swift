//
//  ESMainTabbarController.swift
//  Ehousekeeper
//
//  Created by limeng on 2017/3/19.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation

class ESMainTabbarController:  NSObject{
    
    
    static func customIrregularityStyle(delegate: UITabBarControllerDelegate?) -> KeeperNavigationController {
        
        let menu = HyPopMenuView.sharedPopMenuManager()

        let tabBarController = ESTabBarController()
        tabBarController.delegate = delegate
        tabBarController.title = "Irregularity"
        tabBarController.tabBar.shadowImage = UIImage(named: "transparent")
        tabBarController.tabBar.backgroundImage = UIImage(named: "background_dark")
        tabBarController.shouldHijackHandler = {
            tabbarController, viewController, index in
            if index == 2 {
                return true
            }
            return false
        }
        tabBarController.didHijackHandler = {
            [weak tabBarController] tabbarController, viewController, index in
            
            
            let model = PopMenuModel.allocPopMenuModel(withImageNameString: "tabbar_compose_idea", atTitleString: "报销", atTextColor: UIColor.gray, at: PopMenuTransitionTypeCustomizeApi, atTransitionRenderingColor: nil)
            
            let model1 = PopMenuModel.allocPopMenuModel(withImageNameString: "tabbar_compose_camera", atTitleString: "付款", atTextColor: UIColor.gray, at: PopMenuTransitionTypeCustomizeApi, atTransitionRenderingColor: nil)
            
            let model2 = PopMenuModel.allocPopMenuModel(withImageNameString: "tabbar_compose_lbs", atTitleString: "对账", atTextColor: UIColor.gray, at: PopMenuTransitionTypeSystemApi, atTransitionRenderingColor: nil)
            
            let model3 = PopMenuModel.allocPopMenuModel(withImageNameString: "tabbar_compose_review", atTitleString: "报表", atTextColor: UIColor.gray, at: PopMenuTransitionTypeSystemApi, atTransitionRenderingColor: nil)
            
            let model4 = PopMenuModel.allocPopMenuModel(withImageNameString: "tabbar_compose_photo", atTitleString: "财富", atTextColor: UIColor.gray, at: PopMenuTransitionTypeSystemApi, atTransitionRenderingColor: nil)
            
            let model5 = PopMenuModel.allocPopMenuModel(withImageNameString: "tabbar_compose_more", atTitleString: "设置", atTextColor: UIColor.gray, at: PopMenuTransitionTypeSystemApi, atTransitionRenderingColor: nil)
            
            
            menu?.dataSource = [ model, model1, model2,model3,model4,model5]
            let tempAppDelegate = UIApplication.shared.delegate  ;
            
            menu?.delegate = tempAppDelegate as! HyPopMenuViewDelegate!
            menu?.popMenuSpeed = 12.0
            menu?.automaticIdentificationColor = false
            
            
            
            //好大个坑，调用的静态方法不能跟类重名，不然swift找不到oc的方法
            let topView = popMenvTopView.fromXib()
            
            topView?.frame = CGRect(x: 0, y: 44, width: ScreenWidth, height: 92)
            menu?.topView  = topView
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                             
            menu?.openMenu()

          }
        }
        let v1 = KeeperMessageViewController()
        let v2 = AddressViewController()
        let v3 = MineViewController()
        let v4 = WorksViewController()
        let v5 = ConversationListViewController()
        
        
        
        
        v1.url = URL.init(string: String.init(format: "file://%@/bundlejs/index.js", Bundle.main.bundlePath))
        
        
        v1.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "消息", image: UIImage(named: "home"), selectedImage: UIImage(named: "home_1"))
        v2.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "通讯录", image: UIImage(named: "find"), selectedImage: UIImage(named: "find_1"))
        v3.tabBarItem = ESTabBarItem.init(ExampleIrregularityContentView(), title: nil, image: UIImage(named: "photo_verybig"), selectedImage: UIImage(named: "photo_verybig"))
        v4.tabBarItem = ESTabBarItem.init(ExampleIrregularityBasicContentView(), title: "应用", image: UIImage(named: "favor"), selectedImage: UIImage(named: "favor_1"))
        v5.tabBarItem = ESTabBarItem.init(ExampleTipsContentView(), title: "我的", image: UIImage(named: "me"), selectedImage: UIImage(named: "me_1"))
        
        
        if let tabBarItem = v1.tabBarItem as? ESTabBarItem {
            tabBarItem.badgeValue = "2"
        }
        if let tabBarItem = v4.tabBarItem as? ESTabBarItem {
            tabBarItem.badgeValue = "9"
        }

        
        
        tabBarController.viewControllers = [v1, v2, v3, v4, v5]
        
        
        let navigationController = KeeperNavigationController.init(rootViewController: tabBarController)
        tabBarController.title = "银企管家"
        return navigationController
    }
    

    
}
