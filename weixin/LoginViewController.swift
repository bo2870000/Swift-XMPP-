//
//  LoginViewController.swift
//  weixin
//
//  Created by q on 14/9/22.
//  Copyright (c) 2014年 q. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var autologinSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var serverTF: UITextField!
    @IBOutlet weak var pwdTF: UITextField!
    @IBOutlet weak var userTF: UITextField!
    
    //需要登陆
    var requireLogin = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if sender as UIBarButtonItem == self.doneButton {
            
            NSUserDefaults.standardUserDefaults().setObject(userTF.text, forKey: "weixinID")
            NSUserDefaults.standardUserDefaults().setObject(pwdTF.text, forKey: "weixinPwd")
            NSUserDefaults.standardUserDefaults().setObject(serverTF.text, forKey: "wxserver")
            
            //配置自动登陆
            NSUserDefaults.standardUserDefaults().setBool(self.autologinSwitch.on, forKey: "wxautologin")
            
            //同步用户配置
            NSUserDefaults.standardUserDefaults().synchronize()
            
            //需要登陆
            requireLogin = true
            
        }
    }
    

}
