// Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"


var locList = [
    "上海","东京","上海","大连","北京","上海"
]

var numList = [
    22,10,-10,22,0,22
]


//获取正确的删除索引
func getRemoveIndex<T: Equatable>(value: T, aArray: [T]) -> [Int] {
    var indexArray = [Int]()
    var correctArray = [Int]()
    
    // 获取指定值在数组中的索引并保存
    for (index, _) in enumerate(aArray)  {
        if ( value == aArray[index] ) {
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
func removeValueFromArray<T: Equatable>(value: T, inout aArray: [T]) {
    var correctArray = [Int]()
    
    correctArray = getRemoveIndex(value, aArray)
    
    // 从原数组中删除指定元素(用正确的索引)
    for index in correctArray {
        aArray.removeAtIndex(index)
    }
}



removeValueFromArray("上海", &locList)

var locList2 = [
    "上海","东京","上海","大连","北京","上海","东京","南京","东京","深圳"
]

removeValueFromArray("东京", &locList2)

removeValueFromArray(22, &numList)


