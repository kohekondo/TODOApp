//
//  MyTodo.swift
//  MyTodoList
//
//  Created by 近藤 康平 on 2017/12/22.
//  Copyright © 2017年 kohe. All rights reserved.
//

import Foundation

//独自クラスをシリアライズする際には,NSObjectを継承し
//NSCodingプロトコルに準拠する必要がある
class MyTodo: NSObject,NSCoding {
    //ToDoのタイトル
    var todoTitle:String?
    //ToDoを完了したかどうかを表すフラグ
    var todoDone:Bool = false
    //コンストラクタ
    override init() {
    }
    
    //NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理とも呼ばれる。
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
    
    //NSCodingプロトコルに宣言されているデシリアライズ処理。デコード処理とも呼ばれる
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone  = aDecoder.decodeBool(forKey: "todoDone")
    }
    
}
