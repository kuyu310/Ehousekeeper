//
//  WorksViewController.swift
//  Ehousekeeper
//
//  Created by limeng on 2017/3/17.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
class WorksViewController: BaseViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellow
        
        var bt = UIButton(frame: CGRect(x: 100, y: 100, width: 50, height: 30))
        
        bt.backgroundColor = UIColor.blue
        
        bt.setTitle("退出", for: UIControlState.normal)//设置Button的文本内容
        
       
        bt.addTarget(self, action: #selector(logOut), for: UIControlEvents.touchUpInside)
      
        
        self.view.addSubview(bt)
        
    }
    
    func logOut()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.logout()
        
    }
    
}
