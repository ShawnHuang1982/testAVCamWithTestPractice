//
//  ImageCaptureProvider.swift
//  testAVCam
//
//  Created by huang on 2021/7/3.
//

import UIKit

protocol ImageCaptureProvider where Self: UIViewController {
    var delegate: ImageCaptureProviderDelegate? { get set }
}

protocol ImageCaptureProviderDelegate: class {
    func getPhoto(image: UIImage)
}
