//
//  ViewController.swift
//  MyTodoList
//
//  Created by 近藤 康平 on 2017/11/20.
//  Copyright © 2017年 kohe. All rights reserved.
//

import UIKit

//UITableViewDataSource,UITableViewDelegateのプロトコルを実装する旨の宣言を行う
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {


    @IBOutlet weak var tableView: UITableView!
    // ToDoを格納した配列
    var todoList:[MyTodo] = []
    //+ ボタンが押されたときに実行
    @IBAction func tapAddButton(_ sender: Any) {
        //アラートダイアログを生成
        let alertController = UIAlertController(title: "TODO追加", message: "TODOを入力してください", preferredStyle: UIAlertControllerStyle.alert)

        //テキストエリア追加
        alertController.addTextField(configurationHandler: nil)

        //OKボタンを追加
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action:UIAlertAction) in
            //OKボタンが押されたときの処理
            if let textField = alertController.textFields?.first {
                //ToDoの配列に入力値を挿入。先頭に挿入する
                let myTodo = MyTodo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)

                //テーブル(配列)に行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
                print(self.todoList)
                //ToDoの保存処理
                let userDefault = UserDefaults.standard
                //Data型にシリアライズする
                let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                userDefault.set(data, forKey: "todoList")
                userDefault.synchronize()

            }
        }
        //OKボタン追加
        alertController.addAction(okAction)
        
        //キャンセルボタン追加
        let cancelButton = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelButton)
        
        //アラートダイアログを表示
        present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate   = self
        tableView.dataSource = self
        
        //保存しているToDoの読み込み処理
        let userDefault      = UserDefaults.standard
        if let stredTodoList = userDefault.object(forKey: "todoList") as? Data {
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: stredTodoList) as? [MyTodo] {
                todoList.append(contentsOf: unarchiveTodoList)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Storyboaardで指定したtodoCell識別子を利用して再利用可能なセルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        
        //行番号に合ったToDoの情報を取得
        let myTodo = todoList[indexPath.row]
        
        //セルのラベルにToDoのタイトルをセット
        cell.textLabel?.text = myTodo.todoTitle
        
        //セルのチェックマークの状態をセット
        if myTodo.todoDone {
            //チェックあり
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            //チェックなし
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        return cell
    }
    
    //セルをタップしたときの処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone{
            myTodo.todoDone = false
        } else {
            myTodo.todoDone = true
        }

        //セルの状態を変更
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        
        //データ保存。Data型にシリアライズする
        let data:Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        
        //userDefaultsに保存
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
        
    }
}

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











