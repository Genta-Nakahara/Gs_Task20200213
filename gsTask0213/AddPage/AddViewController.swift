//
//  AddViewController.swift
//  gsTask0213
//
//  Created by hdymacuser on 2020/02/13.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import UIKit
import PKHUD
import FirebaseFirestore
import CoreLocation


class AddViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBOutlet weak var latitude: UILabel!
    
    @IBOutlet weak var longitude: UILabel!
    
    // 緯度
    var latitudeNow: String = ""
    // 経度
    var longitudeNow: String = ""
    
    /// ロケーションマネージャ
    var locationManager: CLLocationManager!
    
    // 判定に使用するプロパティ
       var selectIndex: Int?
       
       override func viewDidLoad() {
           super.viewDidLoad()
           setupMemoTextView()
           setupNavigationBar()
        // ロケーションマネージャのセットアップ
        setupLocationManager()
           
           // Editかどうかの判定
           if let index = selectIndex {
               title = "編集"
               titleTextField.text = TaskCollection.shared.getTask(at: index).title
               memoTextView.text = TaskCollection.shared.getTask(at: index).memo
           }
       }
       
        
    
       // MARK: Setup
       fileprivate func setupMemoTextView() {
           memoTextView.layer.borderWidth = 1
           memoTextView.layer.borderColor = UIColor.lightGray.cgColor
           memoTextView.layer.cornerRadius = 3
       }
       
       fileprivate func setupNavigationBar() {
           title = "Add"
           let rightButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(tapSaveButton))
           navigationItem.rightBarButtonItem = rightButtonItem
       }
       
        
    @IBAction func getLocationInfo(_ sender: Any) {
        // マネージャの設定
        let status = CLLocationManager.authorizationStatus()
        if status == .denied {
            showAlert()
        } else if status == .authorizedWhenInUse {
            self.latitude.text = latitudeNow
            self.longitude.text = longitudeNow
        }
        
    }
    
    @IBAction func clearLabel(_ sender: Any) {
        self.latitude.text = "デフォルト"
        self.longitude.text = "デフォルト"
    }
    
    /// ロケーションマネージャのセットアップ
        func setupLocationManager() {
            locationManager = CLLocationManager()

            // 権限をリクエスト
            guard let locationManager = locationManager else { return }
            locationManager.requestWhenInUseAuthorization()

            // マネージャの設定
            let status = CLLocationManager.authorizationStatus()

            // ステータスごとの処理
            if status == .authorizedWhenInUse {
                locationManager.delegate = self
                locationManager.startUpdatingLocation()
            }
        }


        /// アラートを表示する
        func showAlert() {
            let alertTitle = "位置情報取得が許可されていません。"
            let alertMessage = "設定アプリの「プライバシー > 位置情報サービス」から変更してください。"
            let alert: UIAlertController = UIAlertController(
                title: alertTitle,
                message: alertMessage,
                preferredStyle:  UIAlertController.Style.alert
            )
            // OKボタン
            let defaultAction: UIAlertAction = UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil
            )
            // UIAlertController に Action を追加
            alert.addAction(defaultAction)
            // Alertを表示
            present(alert, animated: true, completion: nil)
        }
    
    
    
    
    // MARK: Other Method
       @objc func tapSaveButton() {
           print("Saveボタンを押したよ！")
           
           guard let title = titleTextField.text else {
               return
           }
           
           if title.isEmpty {
               print(title, "titleが空っぽ")
               
               HUD.flash(.labeledError(title: nil, subtitle: " タイトルが入力されていません"), delay: 1)
               return // return を実行すると、このメソッドの処理がここで終了する。
           }
           
           // ここで Edit か Add　かを判定している
           if let index = selectIndex {
               // Edit
               let editTask = TaskCollection.shared.getTask(at: index)
               editTask.title = title
               editTask.memo = memoTextView.text
               editTask.updatedAt = Timestamp()
               TaskCollection.shared.editTask(task: editTask, index: index)
           } else {
               // Add
               let task = TaskCollection.shared.createTask()
               task.title = title
               task.memo = memoTextView.text
               TaskCollection.shared.addTask(task)
           }
           
           HUD.flash(.success, delay: 0.3)
           // 前の画面に戻る
           navigationController?.popViewController(animated: true)
       }
                  
}

extension AddViewController: CLLocationManagerDelegate {

    /// 位置情報が更新された際、位置情報を格納する
    /// - Parameters:
    ///   - manager: ロケーションマネージャ
    ///   - locations: 位置情報
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        // 位置情報を格納する
        self.latitudeNow = String(latitude!)
        self.longitudeNow = String(longitude!)
    }
}
