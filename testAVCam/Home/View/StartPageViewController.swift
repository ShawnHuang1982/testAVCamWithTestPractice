//
//  StartPageViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift

class StartPageViewController: UIViewController, PermissionChecker {

    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var imagePreview: ImagePreviewer!
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
        
        //啟動拍照程序前, 需檢查
        takePhotoButton.rx
            .touchUpInside
            .flatMap{ [unowned self] in self.checkPermission() }
            .subscribe(onNext: { [weak self] isCanLaunchCamera in
                self?.launchCamerInCan(isCan: isCanLaunchCamera)
            }).disposed(by: self.disposeBag)
    }
    
    
    
    private func launchCamerInCan(isCan: Bool) {
        DispatchQueue.main.async {
            if isCan {
                self.present(self.cameraViewController, animated: true)
            } else {
                self.presentAlertView(type: .okAction(message: "請同意權限", handler: { (action) in
                    //handle redirect to setting app
                }))
            }
        }
    }
}

extension StartPageViewController: CameraViewControllerDelegate {
    
    func getPhoto(image: UIImage) {
        //取得圖片
        self.imagePreview.imageView.image = image
    }
}
