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
    var todoList:[String] = []
    
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
                self.todoList.insert(textField.text!, at: 0)

                //テーブル(配列)に行が追加されたことをテーブルに通知
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.right)
                print(self.todoList)
                //ToDoの保存処理
                let userDefault = UserDefaults.standard
                userDefault.set(self.todoList, forKey: "todoList")
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
        if let stredTodoList = userDefault.array(forKey: "todoList") as? [String] {
            todoList.append(contentsOf: stredTodoList)
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
        
        //行番号に合ったToDoのタイトルを取得
        let todoTitle = todoList[indexPath.row]
        
        //セルのラベルにToDoのタイトルをセット
        cell.textLabel?.text = todoTitle
        
        return cell
    }
    
}

