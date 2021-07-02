//
//  CameraViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift
import AVFoundation
import CoreLocation
import Photos

protocol CameraViewControllerDelegate: class {
    func getPhoto(image: UIImage)
}
class CameraViewController: UIViewController {

    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    private var disposeBag: DisposeBag = DisposeBag()
    
    weak var delegate: CameraViewControllerDelegate?
    
    private var spinner: UIActivityIndicatorView!
    
    var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .unknown
    }
    
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    private func setupBinding() {
        
        takeButton.rx.touchUpInside.bind{
            
        }.disposed(by: self.disposeBag)
        
        dismissButton.rx.touchUpInside.bind{ [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    }
    
    

}
//
//extension CameraViewController: AVCaptureFileOutputRecordingDelegate, ItemSelectionViewControllerDelegate {
//}
