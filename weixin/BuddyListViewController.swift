//
//  BuddyListViewController.swift
//  weixin
//
//  Created by q on 14/9/22.
//  Copyright (c) 2014年 q. All rights reserved.
//

import UIKit

class BuddyListViewController: UITableViewController, ZtDL, XxDL {
    @IBAction func log(sender: UIBarButtonItem) {
       //根据当前在线状态,调整状态图片和进行上下线操作
        
        if logged {
            //下线
            logoff()
            
            //图片更改成离线
            sender.image = UIImage(named: "off")
            
        } else {
            //上线
            login()
            
            //图片更改成离线
            sender.image = UIImage(named: "on")
        }
        
    }
    @IBOutlet weak var mystatus: UIBarButtonItem!
    
    //未读消息数组
    var unreadList = [WXMessage]()
    
    //好友状态数组，作为表格的数据源
    var ztList = [Zhuangtai]()
    
    //已登入
    var logged = false
    
    //选择聊天的好友用户名
    var currentBuddyName = ""
    
    //自己离线
    func meOff() {
        logoff()
    }

    //收到离线或未读消息
    func newMsg(aMsg: WXMessage) {
        
        //如果消息有正文
        if (aMsg.body != "") {
            //则加入到未读消息组
            unreadList.append(aMsg)
            
            //通知表格刷新
            self.tableView.reloadData()
        }
        
    }
    
    //上线状态处理
    func isOn(zt: Zhuangtai) {
        //逐条查找
        for (index, oldzt) in enumerate(ztList)  {
            //如果找到旧的用户状态
            
            if (zt.name == oldzt.name ) {
                
                //就移除掉旧的用户状态
                ztList.removeAtIndex(index)
                
                //一旦找到,就不找了,退出循环
                break
            }
            
            
        }
        //添加新状态到状态数组
        ztList.append(zt)
        
        //通知表格刷新
        self.tableView.reloadData()
    }
    
    
    //下线状态处理
    func isOff(zt: Zhuangtai) {
        //逐条查找
        for (index, oldzt) in enumerate(ztList)  {
            //如果找到旧的用户状态
            
            
            if (zt.name == oldzt.name ) {
                
                //更改旧的用户状态, 为上线
                ztList[index].isOnline = false
                
                //一旦找到,就不找了,退出循环
                break
            }
            
            
        }
        
        //通知表格刷新
        self.tableView.reloadData()

    }
    
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    //登入
    func login() {
        //清空未读和状态数组
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        zdl().connect()
        
        //导航左边按钮图片改为上线状态
        mystatus.image = UIImage(named: "on")
        
        logged = true
        
        
        
        //取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        
        //导航标题改成 "我"的好友
        self.navigationItem.title = myID! + "的好友"
        
        //通知表格更新数据
        self.tableView.reloadData()
        
        
    }
    
    
    //登出
    func logoff() {
        //清空未读和状态数组
        unreadList.removeAll(keepCapacity: false)
        ztList.removeAll(keepCapacity: false)
        
        
        zdl().disConnect()
        
         //导航左边按钮图片改为下线状态
        mystatus.image = UIImage(named: "off")
        
        logged = false
        
        //通知表格更新数据
        self.tableView.reloadData()
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //取用户名
        let myID = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        
        //取自动登陆
        let autologin = NSUserDefaults.standardUserDefaults().boolForKey("wxautologin")
        
        //如果配置了用户名和自动登陆,开始登陆
        if ( myID != nil && autologin ) {
            
            self.login()
            
            
            
            //其他情况,则转到登陆视图
        } else {
            self.performSegueWithIdentifier("toLoginSegue", sender: self)
        }
        
        
        //接管状态代理
        zdl().ztdl = self
        
        
        
    }
    

    override func viewDidAppear(animated: Bool) {
        //接管消息代理
        zdl().xxdl = self
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    //表格有几个组
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //表格的组内有多少行
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ztList.count
    }

    
    //单元格内容
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("buddyListCell", forIndexPath: indexPath) as UITableViewCell
        
        //好友状态
        let online = ztList[indexPath.row].isOnline
        
        //好友的名称
        let name = ztList[indexPath.row].name
        
        //未读消息的条数
        var unreads = 0
        
        //查找相应好友的未读条数
        for msg in unreadList {
            if ( name == msg.from ) {
                unreads++
            }
        }
        
        //单元格的文本 bear@xiaoboswift.com(5)
        cell.textLabel?.text = name + "(\(unreads))"
        
        
        
        //根据状态切换单元格的图像
        if online {
            cell.imageView?.image = UIImage(named: "on")
        } else {
            cell.imageView?.image = UIImage(named: "off")

        }
        
        return cell

    }
    
    
    //选择单元格
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        //保存好友用户名
        currentBuddyName = ztList[indexPath.row].name
        
        //跳转到聊天视图
        self.performSegueWithIdentifier("toChatSegue", sender: self)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        // 判断是否转到聊天界面
        if ( segue.identifier == "toChatSegue" ) {
            
            //取聊天视图的控制器
            let dest = segue.destinationViewController as ChatViewController
            
            //把当前选择单元格的用户名传递给聊天视图
            dest.toBuddyName = currentBuddyName
            
            //把未读消息传递给聊天视图
            for msg in unreadList {
                if msg.from == currentBuddyName {
                    //加入到聊天视图的消息组中
                    dest.msgList.append(msg)
                }
            }
            
            
            
            //把相应的未读消息从未读消息组中移除
//            removeValueFromArray(currentBuddyName, &unreadList)
            unreadList = unreadList.filter{ $0.from != self.currentBuddyName }
            
            
            //通知表格更新数据
            self.tableView.reloadData()
            
            
        }
        
    }
    
    
    @IBAction func unwindToBList(segue: UIStoryboardSegue) {
        //如果是登陆界面的完成按钮点击了, 开始登陆
        let source = segue.sourceViewController as LoginViewController
        
        if source.requireLogin {
            //注销前一个用户
            self.logoff()
            
            //登陆现用户
            self.login()
        }
        
        
    }

}
