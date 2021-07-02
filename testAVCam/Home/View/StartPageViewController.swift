//
//  StartPageViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift
import AVFoundation

class StartPageViewController: UIViewController {

    @IBOutlet weak var takePhotoButton: UIButton!
    private var disposeBag: DisposeBag = DisposeBag()
    
    lazy var cameraViewController: CameraViewController = {
        let vc = CameraViewController()
        vc.delegate = self
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinidng()
        
    }
    
    private func setupBinidng() {
        takePhotoButton.rx
            .touchUpInside.bind {
            [weak self] in
            guard let self = self else { return }
            self.checkPermission { (isCanLaunchCamera) in
                DispatchQueue.main.async {
                    if isCanLaunchCamera {
                        self.present(self.cameraViewController, animated: true)
                    } else {
                        self.presentAlertView(type: .okAction(message: "請同意權限", handler: { (action) in
                            //handle redirect to setting app
                        }))
                    }
                }
            }
           
        }.disposed(by: self.disposeBag)
    }
    
    private func checkPermission(_ callback: @escaping (Bool) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            callback(true)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                callback(granted)
            })
        default:
            callback(false)
        }
    }


}

extension StartPageViewController: CameraViewControllerDelegate {
    
    func getPhoto(image: UIImage) {
        //取得圖片
    }
}
