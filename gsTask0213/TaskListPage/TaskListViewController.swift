//
//  ViewController.swift
//  gsTask0213
//
//  Created by hdymacuser on 2020/02/12.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import UIKit
import FirebaseAuth

class TaskListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "CustomCell", bundle: nil)
        tableView.register( nib, forCellReuseIdentifier: "CustomCell")
        TaskCollection.shared.delegate = self
        setupNavigationBar()
    }
    
    fileprivate func setupNavigationBar() {
        let rightButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAddScreen))
        navigationItem.rightBarButtonItem = rightButtonItem
        
        #warning("leftButton を作成して、 logout を実行する")
        let leftButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    @objc func showAddScreen() {
        let vc = AddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func logout() {
        do {
            try Auth.auth().signOut()
            // 強制的に現在の表示している vc を変更する
            let vc = LoginViewController()
            let sceneDelegate = view.window?.windowScene?.delegate as! SceneDelegate
            sceneDelegate.window?.rootViewController = vc
        } catch {
            print("error:",error.localizedDescription)
        }
    }
    
     // MARK: UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskCollection.shared.taskCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.titleLabel?.text = TaskCollection.shared.getTask(at: indexPath.row).title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("タップした後に色がつくのを消す処理を追加")
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = AddViewController()
        vc.selectIndex = indexPath.row
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            TaskCollection.shared.removeTask(index: indexPath.row)
        }
        
    }

    extension TaskListViewController: TaskCollectionDelegate {
        // デリゲートのメソッド
        func saved() {
            // tableView をリロードして、画面を更新する。
            tableView.reloadData()
        }
        
        func loaded() {
            tableView.reloadData()
        }
}

