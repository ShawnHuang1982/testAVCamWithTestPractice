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
            .touchUpInside
            .flatMap{ [unowned self] in self.checkPermission() }
            .subscribe(onNext: { [weak self] isCanLaunchCamera in
                self?.launchCamerInCan(isCan: isCanLaunchCamera)
            }).disposed(by: self.disposeBag)
    }
    
    private func checkPermission() -> Observable<Bool> {
        return Observable.create { observer -> Disposable in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                observer.onNext(true)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                    observer.onNext(granted)
                })
            default:
                observer.onNext(false)
            }
        return Disposables.create()
        }
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
    }
}
