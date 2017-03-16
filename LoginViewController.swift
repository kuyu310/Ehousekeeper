//
//  LoginViewController.swift
//  Ehousekeeper
//
//  Created by limeng on 2017/3/15.
//  Copyright © 2017年 limeng. All rights reserved.
//

import Foundation
import SnapKit


class LoginViewController: BaseViewController , UITextFieldDelegate{
    
    var txtUser: UITextField! //用户名输入框
    var txtPwd: UITextField! //密码输入款
    var formView: UIView! //登陆框视图
    var horizontalLine: UIView! //分隔线
    var confirmButton:UIButton! //登录按钮
    var titleLabel: UILabel! //标题标签
    
    var topConstraint: Constraint? //登录框距顶部距离约束
    
    
    
    
    
    
    
    
    
    var fd : UITextField?
    var decimal:UITextField?

    var kb : NHKeyboard?
    var kb2: NHKeyboard?
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        var kb = NHKeyboard(type: NHKBTypeASCIICapable)
        self.view.backgroundColor = UIColor(red: 1/255, green: 170/255, blue: 235/255,
                                            alpha: 1)
        self.navigationController?.isNavigationBarHidden = true
        
        // 注册通知中心，监听键盘弹起的状态
        NotificationCenter.default.addObserver(self,selector: #selector(LoginViewController.keyboardWillChange(_:)),name: .UIKeyboardWillShow, object: nil)
        // 注册通知中心，监听键盘回落的状态
        NotificationCenter.default.addObserver(self,selector: #selector(LoginViewController.keyboardWillHiden(_:)),name: .UIKeyboardWillHide, object: nil)
        
        
        //登录框高度
        let formViewHeight = 90
        
        //登录框背景
        self.formView = UIView()
        self.formView.layer.borderWidth = 0.5
        self.formView.layer.borderColor = UIColor.lightGray.cgColor
        self.formView.backgroundColor = UIColor.white
        self.formView.layer.cornerRadius = 5
        self.view.addSubview(self.formView)
        
        //最常规的设置模式
        self.formView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            //存储top属性
            self.topConstraint = make.centerY.equalTo(self.view).constraint
            make.height.equalTo(formViewHeight)
        }
        
        //分隔线
        self.horizontalLine =  UIView()
        self.horizontalLine.backgroundColor = UIColor.lightGray
        self.formView.addSubview(self.horizontalLine)
        self.horizontalLine.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(0.5)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.centerY.equalTo(self.formView)
        }
        
        
        //用户名图标
        let imgLock1 =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgLock1.image = UIImage(named:"iconfont-user")
        
        //密码图标
        let imgLock2 =  UIImageView(frame:CGRect(x: 11, y: 11, width: 22, height: 22))
        imgLock2.image = UIImage(named:"iconfont-password")
        
        
        //用户名输入框
        self.txtUser = UITextField()
        self.txtUser.delegate = self
        self.txtUser.placeholder = "用户名"
        self.txtUser.tag = 100
        self.txtUser.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        self.txtUser.leftViewMode = UITextFieldViewMode.always
        self.txtUser.returnKeyType = UIReturnKeyType.next
        
        //用户名输入框左侧图标
        self.txtUser.leftView!.addSubview(imgLock1)
        self.formView.addSubview(self.txtUser)

        
        //布局
        self.txtUser.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(self.formView).offset(-formViewHeight/4)
        }

        kb = NHKeyboard(type: NHKBTypeASCIICapable)
        self.fd = self.txtUser
        kb.enterprise = "信雅达安全输入";
        kb.icon = "security_logo.jpg"
        self.fd?.inputView = kb;
        kb.inputSource = self.txtUser
        self.kb = kb

        
        
        
        
        
        //密码输入框
        self.txtPwd = UITextField()
        self.txtPwd.delegate = self
        self.txtPwd.placeholder = "密码"
        self.txtPwd.tag = 101
        self.txtPwd.leftView = UIView(frame:CGRect(x: 0, y: 0, width: 44, height: 44))
        self.txtPwd.leftViewMode = UITextFieldViewMode.always
        self.txtPwd.isSecureTextEntry = true
        self.txtPwd.clearsOnBeginEditing = true
        self.txtPwd.returnKeyType = UIReturnKeyType.next
        
        //密码输入框左侧图标
        self.txtPwd.leftView!.addSubview(imgLock2)
        self.formView.addSubview(self.txtPwd)
        
      

        self.txtPwd.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
            make.centerY.equalTo(self.formView).offset(formViewHeight/4)
        }

        kb = NHKeyboard(type: NHKBTypeNumberPad)
        self.fd = self.txtPwd
        kb.enterprise = "信雅达安全输入";
        kb.icon = "security_logo.jpg"
        self.fd?.inputView = kb;
        kb.inputSource = self.txtPwd
        self.kb = kb
        
        
        
        
        //登录按钮
        self.confirmButton = UIButton()
        self.confirmButton.setTitle("登录", for: UIControlState())
        self.confirmButton.setTitleColor(UIColor.black,
                                         for: UIControlState())
        self.confirmButton.layer.cornerRadius = 5
        self.confirmButton.backgroundColor = UIColor(colorLiteralRed: 1, green: 1, blue: 1,
                                                     alpha: 0.5)
        self.confirmButton.addTarget(self, action: #selector(loginConfrim),
                                     for: .touchUpInside)
        self.view.addSubview(self.confirmButton)
        self.confirmButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(15)
            make.top.equalTo(self.formView.snp.bottom).offset(20)
            make.right.equalTo(-15)
            make.height.equalTo(44)
        }
        
        //标题label
        self.titleLabel = UILabel()
        self.titleLabel.text = "银企管家"
        self.titleLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont.systemFont(ofSize: 36)
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self.formView.snp.top).offset(-20)
            make.centerX.equalTo(self.view)
            make.height.equalTo(74)
        }

        
 
        
        
    }
    deinit {
        // 移除通知中心
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func keyboardWillChange(_ notification: Notification) {
        
        
       

        
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: -125)
            
//            这里需要关闭动画效果，不然输入的文本会发生动画漂移，很难看
           // self.view.layoutIfNeeded()
        })

        
        
    }
    func keyboardWillHiden(_ notification: Notification) {
        
        
        
        //视图约束恢复初始设置
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.topConstraint?.update(offset: 0)
            self.view.layoutIfNeeded()
        })
    }
  
    
    //输入框返回时操作
    
//   
//    func textFieldShouldEndEditing(_ textField:UITextField) -> Bool
//    {
//        let tag = textField.tag
//        switch tag {
//        case 100:
//
//            
//         //   self.txtUser.resignFirstResponder()
//         
//            self.txtUser.endEditing(true)
//
//        case 101:
//            
//            loginConfrim()
//        default:
//            print(textField.text!)
//        }
//        return true
//        
//    }


    
    
    //登录按钮点击
    func loginConfrim(){
        //收起键盘
        self.view.endEditing(true)
        
    }
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func dismissKeyboard() {
        self.view.endEditing(true)
        

    }

    
    
    
    
}
