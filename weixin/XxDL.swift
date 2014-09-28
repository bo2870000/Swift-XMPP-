//
//  XxDL.swift
//  weixin
//
//  Created by q on 14/9/22.
//  Copyright (c) 2014年 q. All rights reserved.
//

import Foundation

//消息代理协议
protocol XxDL {
    func newMsg(aMsg:WXMessage)
}