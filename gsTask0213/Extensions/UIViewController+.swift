//
//  UIViewController+.swift
//  gsTask0213
//
//  Created by hdymacuser on 2020/02/13.
//  Copyright © 2020 GentaNakahara. All rights reserved.
//

import UIKit

extension UIViewController {
    // OKを選択させるエラーアラートを表示する
    func showErrorAlert(text: String){
        let alertController = UIAlertController(title: "エラー", message: text , preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
