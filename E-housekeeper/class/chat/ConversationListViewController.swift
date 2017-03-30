//
//  ConversationListViewController.swift
//  CloudIM
//
//  Created by 田子瑶 on 16/8/24.
//  Copyright © 2016年 田子瑶. All rights reserved.
//

import UIKit

class ConversationListViewController: RCConversationListViewController,RCIMConnectionStatusDelegate,UIAlertViewDelegate {
    
    var index = 0
    

    
    func  createDiscussion(DiscussionTital: String){
        
        
        RCIM.shared().createDiscussion(DiscussionTital, userIdList: ["111","222","333","444","555","666","777"], success: { (discussion) in
            
            
            let conversationVC = ConversationViewController()
            conversationVC.targetId = discussion?.discussionId
            
            print(conversationVC.targetId)
            
            conversationVC.conversationType = .ConversationType_DISCUSSION
            
            
            
            
//            修改讨论组名称
//            RCIM.shared().setDiscussionName(discussion?.discussionId, name: discussion?.discussionId, success: {
//                
//            }, error: { (RCErrorCode) in
//                
//            })
            
            DispatchQueue.main.async{
                self.navigationController?.pushViewController(conversationVC, animated: true)
                self.tabBarController?.tabBar.isHidden = true
            }
            
            
        }) { (RCErrorCode) in
            
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
      
            appDelegate.getUserInfo(withUserId: userIdGlob) { (userInfo) in
            
            appDelegate.connectServer(userInfo: userInfo!) {
                
                let conversationTypes = [
                    
//                    RCConversationType.ConversationType_PRIVATE.rawValue,
                    RCConversationType.ConversationType_DISCUSSION.rawValue,
//                    RCConversationType.ConversationType_GROUP.rawValue,
//                    RCConversationType.ConversationType_CHATROOM.rawValue,
                    RCConversationType.ConversationType_CUSTOMERSERVICE.rawValue,
                    RCConversationType.ConversationType_SYSTEM.rawValue,
//                    RCConversationType.ConversationType_APPSERVICE.rawValue,
                    RCConversationType.ConversationType_PUBLICSERVICE.rawValue,
                    RCConversationType.ConversationType_PUSHSERVICE.rawValue
                    
                ]
                //MARK:设置会话类型 刷新会话列表
                self.setDisplayConversationTypes(conversationTypes)
                self.showConnectingStatusOnNavigatorBar = true
                
                
                self.refreshConversationTableViewIfNeeded()
                
                
                //如果有新消息等待接受，就等待全部接受好消息后更新UI
                NotificationCenter.default.addObserver(self, selector: #selector(self.refreshCell(_:)), name: NSNotification.Name(rawValue: "RefreshConversationList"), object: nil)
                
                self.setRightNavigationItemWithFrame(image: UIImage(named: "find_1")!, frame: CGRect(x: 10, y: 3.5, width: 21, height: 19.5))
              
                
            }
        }


        //自定义空会话的背景View。当会话列表为空时，将显示该View
       
        
        let blankView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        
        
        let lb = UILabel(frame: CGRect(x: 110, y: 110, width: 100, height: 30))
        lb.text = "页面为空了。。。"
        blankView.addSubview(lb)
        
        blankView.backgroundColor  = UIColor.white
        self.emptyConversationView = blankView
        
    }
    
    
    func setRightNavigationItemWithFrame(image: UIImage ,frame: CGRect) {
        
        let rightBtn = RCDUIBarButtonItem.init(contain: image, imageViewFrame: frame, buttonTitle: nil, titleColor: nil, titleFrame: CGRect.zero, buttonFrame: CGRect(x: 0, y: 0, width: 25, height: 25), target: self, action: #selector(ConversationListViewController.rightBarButtonItemClicked))
        
        
//        这个按钮的位置有点奇特，应该是我套了两层navigation的原因，要从tabbarcontroller里去找里面的导航条里的右键item才可以
        
          self.tabBarController?.navigationItem.rightBarButtonItem = rightBtn
        
        
    }
    
    func rightBarButtonItemClicked() {
        
        
        let alertController = UIAlertController(title: "创建讨论组", message: "请输入讨论组名称", preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addTextField { (textField:UITextField) in
            textField.placeholder = "讨论组名称"
        
            let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "好的", style: UIAlertActionStyle.default) {
                (UIAlertAction) in
                let DiscussionName = alertController.textFields![0]
                
                DispatchQueue.main.async{

                self.createDiscussion(DiscussionTital: DiscussionName.text!)
                    
                }
            }
 
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
       
    }
    }
    
    
    func onRCIMConnectionStatusChanged(_ status :RCConnectionStatus) -> Void {
  
    if (status == RCConnectionStatus.ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        
        
       print("你的账号在别的地方登陆，被迫下线")
        
        }
    
    }
    
    func refreshCell(_ notification: Notification)
    {
  
       self.refreshConversationTableViewIfNeeded()
    }
    
    
    override func onSelectedTableRow(_ conversationModelType: RCConversationModelType, conversationModel model: RCConversationModel!, at indexPath: IndexPath!) {
        
        let conversationVC = ConversationViewController()
        conversationVC.targetId = model.targetId
        
        conversationVC.conversationType = .ConversationType_DISCUSSION
//        conversationVC.enableUnreadMessageIcon = true
//        conversationVC.enableSaveNewPhotoToLocalSystem = true
        conversationVC.title = model.conversationTitle
        self.navigationController?.pushViewController(conversationVC, animated: true)
        self.tabBarController?.tabBar.isHidden = true
        
        
        print(model.conversationTitle)
        
        

        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 将要呈现此View时展示tabbar
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.refreshConversationTableViewIfNeeded()
        
    }



    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //MARK: 转场前隐藏tabbar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
}
