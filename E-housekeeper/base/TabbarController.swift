import UIKit

class MainTabBarController: AnimationTabBarController, UITabBarControllerDelegate {
    
    fileprivate var fristLoadMainTabBarController: Bool = true
    fileprivate var adImageView: UIImageView?
    //adImage带有属性观察期，如果外部调用改变了adimage的值，就会触发{}内的操作。
    var adImage: UIImage? {
        //属性观察者,广告
        didSet {
            weak var tmpSelf = self
            adImageView = UIImageView(frame: ScreenBounds)
            adImageView!.image = adImage!
            self.view.addSubview(adImageView!)
            
            UIImageView.animate(withDuration: 2.0, animations: { () -> Void in
                tmpSelf!.adImageView!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                tmpSelf!.adImageView!.alpha = 0
            }, completion: { (finsch) -> Void in
                tmpSelf!.adImageView!.removeFromSuperview()
                tmpSelf!.adImageView = nil
            })
        }
    }
    
    // MARK:- view life circle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        delegate = self
        buildMainTabBarChildViewController()
    }
//    视图已完全过渡到屏幕上时调用
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fristLoadMainTabBarController {
//            返回一个字典
            let containers = createViewContainers()
            
//            createCustomIcons(containers)
            fristLoadMainTabBarController = false
        }
    }
    
    // MARK: - Method
    // MARK: 初始化tabbar
    fileprivate func buildMainTabBarChildViewController() {
//        tabBarControllerAddChildViewController(HomeViewController(), title: "首页", imageName: "v2_home", selectedImageName: "v2_home_r", tag: 0)
//        tabBarControllerAddChildViewController(ShopCartViewController(), title: "闪电超市", imageName: "v2_order", selectedImageName: "v2_order_r", tag: 1)
//        tabBarControllerAddChildViewController(ShopCartViewController(), title: "购物车", imageName: "shopCart", selectedImageName: "shopCart", tag: 2)
//        tabBarControllerAddChildViewController(HomeViewController(), title: "我的", imageName: "v2_my", selectedImageName: "v2_my_r", tag: 3)
    }
    
    fileprivate func tabBarControllerAddChildViewController(_ childView: UIViewController, title: String, imageName: String, selectedImageName: String, tag: Int) {
        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vcItem.tag = tag
        vcItem.animation = RAMBounceAnimation()
        childView.tabBarItem = vcItem
        
        let navigationVC = BaseNavigationController(rootViewController:childView)
        addChildViewController(navigationVC)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let childArr = tabBarController.childViewControllers as NSArray
        let index = childArr.index(of: viewController)
        
        if index == 2 {
            return false
        }
        
        return true
    }
}

