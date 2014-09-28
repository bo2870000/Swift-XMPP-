//
//  WXMessage.swift
//  weixin
//
//  Created by q on 14/9/22.
//  Copyright (c) 2014年 q. All rights reserved.
//

import Foundation

//好友消息结构
struct WXMessage {
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isMe = false
}

//状态结构
struct Zhuangtai {
    var name = ""
    var isOnline = false
}

//获取正确的删除索引
func getRemoveIndex(value: String, aArray: [WXMessage]) -> [Int] {
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    // 获取指定值在数组中的索引并保存
    for (index, _) in enumerate(aArray)  {
        if ( value == aArray[index].from ) {
            //如果在数组中找到指定的值,则把索引添加到 索引数组
            indexArray.append(index)
            
        }
    }
    
    
    // 计算正确的删除索引
    for (index, originIndex) in enumerate(indexArray) {
        // 正确的索引
        var y = 0
        
        //用指定值在原数组中的索引,减去 索引数组中的索引
        y = originIndex - index
        
        //添加到正确索引数组中
        correctArray.append(y)
    }
    
    
    // 返回正确的删除索引
    return correctArray
}

// 从数组中删除指定的元素
func removeValueFromArray(value: String, inout aArray: [WXMessage]) {
    var correctArray = [Int]()
    
    correctArray = getRemoveIndex(value, aArray)
    
    // 从原数组中删除指定元素(用正确的索引)
    for index in correctArray {
        aArray.removeAtIndex(index)
    }
}
