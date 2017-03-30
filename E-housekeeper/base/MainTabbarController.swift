import UIKit

class MainTabBarController: AnimationTabBarController, SDiffuseMenuDelegate, UITabBarControllerDelegate {
    
    fileprivate var fristLoadMainTabBarController: Bool = true
    fileprivate var adImageView: UIImageView?
 
    var menu: SDiffuseMenu!
    
    
    // MARK:- view life circle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let storyMenuItemImage            =  UIImage(named:"menuitem-normal.png")         else { fatalError("图片加载失败") }
        guard let storyMenuItemImagePressed     =  UIImage(named:"menuitem-highlighted.png")    else { fatalError("图片加载失败") }
        guard let starImage                     =  UIImage(named:"star.png")                    else { fatalError("图片加载失败") }
        guard let starItemNormalImage           =  UIImage(named:"addbutton-normal.png")        else { fatalError("图片加载失败") }
        guard let starItemLightedImage          =  UIImage(named:"addbutton-highlighted.png")   else { fatalError("图片加载失败") }
        guard let starItemContentImage          =  UIImage(named:"plus-normal.png")             else { fatalError("图片加载失败") }
        guard let starItemContentLightedImage   =  UIImage(named:"plus-highlighted.png")        else { fatalError("图片加载失败") }
        
        
        // 选项数组
        var menus = [SDiffuseMenuItem]()
        
        for _ in 0 ..< 4 {
            let starMenuItem =  SDiffuseMenuItem(image: storyMenuItemImage,
                                                 highlightedImage: storyMenuItemImagePressed, contentImage: starImage,
                                                 highlightedContentImage: nil)
            menus.append(starMenuItem)
        }
        
        // 菜单按钮
        let startItem =  SDiffuseMenuItem(image: starItemNormalImage,
                                          highlightedImage: starItemLightedImage,
                                          contentImage: starItemContentImage,
                                          highlightedContentImage: starItemContentLightedImage
        )
        //位置
        let menuRect = CGRect.init(x: self.view.bounds.size.width/2,
                                   y: self.view.bounds.size.width/2,
                                   width: self.view.bounds.size.width,
                                   height: self.view.bounds.size.width)
        // 创建菜单
        
        menu  =  SDiffuseMenu(frame: menuRect,
                                     startItem: startItem,
                                     menusArray: menus as NSArray,
                                     grapyType: SDiffuseMenu.SDiffuseMenuGrapyType.arc)
        
        menu.center   = self.view.center
        menu.delegate = self
        
        self.view.addSubview(menu)
        
        // 配置动画
        resetAnimation("")

        

        
        
        
        delegate = self
        buildMainTabBarChildViewController()
    }
    
    func resetAnimation(_ sender: Any){
        
        menu.nearRadius = 100.0
        menu.endRadius  = 110.0
        menu.farRadius = 120.0
        // 为方便使用,已枚举常见方位,可直接使用.无需再次设置 rotateAngle && menuWholeAngle
        // 若对于 rotateAngle\menuWholeAngle 不熟悉,建议查看 source 目录下的配置图片
        menu.sDiffuseMenuDirection = .myabove // 上方180°
        
    }

    
    
//    视图已完全过渡到屏幕上时调用
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fristLoadMainTabBarController {
//            返回一个字典
            let containers = createViewContainers()
            
            createCustomIcons(containers)
            fristLoadMainTabBarController = false
        }
    }
    
    // MARK: - Method
    // MARK: 初始化tabbar
    fileprivate func buildMainTabBarChildViewController() {
        
        let KeeperMessageView = KeeperMessageViewController()
        KeeperMessageView.url = URL.init(string: String.init(format: "file://%@/bundlejs/index.js", Bundle.main.bundlePath))
        
        tabBarControllerAddChildViewController(KeeperMessageView, title: "消息", imageName: "v2_home", selectedImageName: "v2_home_r", tag: 0)
        tabBarControllerAddChildViewController(AddressViewController(), title: "通讯录", imageName: "v2_order", selectedImageName: "v2_order_r", tag: 1)
        
        
        
        tabBarControllerAddChildViewController(WorksViewController(), title: "应用", imageName: "shopCart", selectedImageName: "shopCart", tag: 2)
        tabBarControllerAddChildViewController(MineViewController(), title: "我的", imageName: "v2_my", selectedImageName: "v2_my_r", tag: 3)
    }
    
    fileprivate func tabBarControllerAddChildViewController(_ childView: UIViewController, title: String, imageName: String, selectedImageName: String, tag: Int) {
        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vcItem.tag = tag
        vcItem.animation = RAMBounceAnimation()
        childView.tabBarItem = vcItem
        
        let navigationVC = BaseNavigationController(rootViewController:childView)
        addChildViewController(navigationVC)
    }
    
    
    
    fileprivate func tabBarControllerAddCenterMenu(title: String, imageName: String, selectedImageName: String, tag: Int) {
        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vcItem.tag = tag
        
        
        
    }

    
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let childArr = tabBarController.childViewControllers as NSArray
        let index = childArr.index(of: viewController)
        //这个是啥意思？
        if index == 4 {
            return false
        }
        
        return true
    }
    
    // MARK: - 动画代理方法
    
    func SDiffuseMenuDidSelectMenuItem(_ menu: SDiffuseMenu, didSelectIndex index: Int) {
        print("选中按钮at index:\(index) is: \(menu.menuItemAtIndex(index)) ")
    }
    
    func SDiffuseMenuDidClose(_ menu: SDiffuseMenu) {
        print("关闭动画关闭结束")
    }
    
    func SDiffuseMenuDidOpen(_ menu: SDiffuseMenu) {
        print("展开动画展开结束")
    }
    
    func SDiffuseMenuWillOpen(_ menu: SDiffuseMenu) {
        print("菜单将要展开")
    }
    
    func SDiffuseMenuWillClose(_ menu: SDiffuseMenu) {
        print("菜单将要关闭")
    }

    
    
}

