//
//  UIViewController+Alert.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit

extension UIViewController {
    public func presentAlertView(type: AlertType) {
        var alertViewController: UIAlertController?
        switch type {
        case .okNoAction(let message):
            alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertViewController?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        case .okAction(let message, let handler):
            alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alertViewController?.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        }
        
        guard let alertVC = alertViewController else {
            // handle it if needed
            return
        }
        DispatchQueue.main.async {
            self.present(alertVC, animated: true)
        }
    }
}

public enum AlertType {
    case okNoAction(message: String)
    case okAction(message: String, handler: (UIAlertAction) -> Void)
}
