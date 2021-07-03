//
//  StartPageViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift

class StartPageViewController: UIViewController {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imagePreview: ImagePreviewer!
    private var disposeBag: DisposeBag = DisposeBag()
    var permissonChecker: PermissionManager = PermissionManager()
    var captureViewController: ImageCaptureProvider = CameraViewController()
    
    internal static func instantiate(captureViewController: ImageCaptureProvider, permissonChecker: PermissionManager) -> StartPageViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "StartPageViewController") as! StartPageViewController
        vc.captureViewController = captureViewController
        vc.permissonChecker = permissonChecker
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinidng()
    }
    
    private func setupBinidng() {
        //啟動拍照程序前, 需檢查
        takePhotoButton.rx
            .touchUpInside
            .flatMap{ [unowned self] in permissonChecker.requestVideoPermission() }
            .subscribe(onNext: { [weak self] allowed in
                self?.launchCameraIfCan(allowed)
            }).disposed(by: self.disposeBag)
        
        self.captureViewController.delegate = self
    }
    
    private func launchCameraIfCan(_ isCan: Bool) {
        DispatchQueue.main.async {
            if isCan {
                self.captureViewController.modalPresentationStyle = .fullScreen
                self.present(self.captureViewController, animated: true)
            } else {
                self.presentAlertView(type: .okAction(message: "請同意權限", handler: { (action) in
                    //handle redirect to setting app
                }))
            }
        }
    }
}

extension StartPageViewController: ImageCaptureProviderDelegate {
    
    func getPhoto(image: UIImage) {
        //取得圖片
        self.imagePreview.imageView.image = image
    }

}
