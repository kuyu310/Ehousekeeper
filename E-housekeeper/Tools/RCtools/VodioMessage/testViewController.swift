//
//  testViewController.swift
//  Ehousekeeper
//
//  Created by limeng on 2017/3/27.
//  Copyright © 2017年 limeng. All rights reserved.
//

import UIKit

class testViewController: UIViewController {

    @IBAction func CancelbuttonClick(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        要给webView分配大小的，不然都不知道怎么显示
        let webView = UIWebView(frame: CGRect(x: 0, y: 58, width: ScreenWidth, height: ScreenHeight))
        
        
        
        let url:NSURL = NSURL.init(string: "http://www.baidu.com")!
        
        
        
        self.view.addSubview(webView)
        
        webView.loadRequest(NSURLRequest.init(url: url as URL) as URLRequest)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
