//
//  ZtDL.swift
//  weixin
//
//  Created by q on 14/9/22.
//  Copyright (c) 2014年 q. All rights reserved.
//

import Foundation

//状态代理协议
protocol ZtDL {
    func isOn(zt:Zhuangtai)
    func isOff(zt:Zhuangtai)
    func meOff()
}