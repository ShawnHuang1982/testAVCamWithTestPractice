//
//  UIViewController+Xib.swift
//  testAVCam
//
//  Created by huang on 2021/7/4.
//

import UIKit
//https://stackoverflow.com/questions/37046573/loading-viewcontroller-from-xib-file
extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }

        return instantiateFromNib()
    }
}
