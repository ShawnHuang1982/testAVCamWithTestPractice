//
//  StartPageViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift

class StartPageViewController: UIViewController {

    @IBOutlet weak var goCameraButton: UIButton!
    @IBOutlet weak var imagePreview: ImagePreviewer!
    private var disposeBag: DisposeBag = DisposeBag()
    var permissonChecker: PermissionManager = PermissionManager()
    var captureViewController: ImageCaptureProvider?
    var viewModel: StartPageViewModel = StartPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinidng()
    }
    
    private func setupBinidng() {
        
        goCameraButton.rx
            .touchUpInside
            .flatMap{ [unowned self] in permissonChecker.requestVideoPermission() }
            .bind(to: viewModel.nextPageIfCan)
            .disposed(by: self.disposeBag)
        
        viewModel.nextPageIfCan.subscribe(onNext: { [weak self] allowed in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if allowed {
                    self.captureViewController = CameraViewController(imageCaptureProviderDelegate: self)
                    self.captureViewController?.modalPresentationStyle = .fullScreen
                    self.present(self.captureViewController!, animated: true)
                } else {
                    self.presentAlertView(type: .okAction(message: "請同意權限", handler: { (action) in
                        //handle redirect to setting app
                    }))
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        self.captureViewController?.delegate = self
    }
    
}

extension StartPageViewController: ImageCaptureProviderDelegate {
    
    func getPhoto(image: UIImage) {
        //取得圖片
        self.imagePreview.imageView.image = image
    }

}

extension StartPageViewController {
    internal static func instantiate(captureViewController: ImageCaptureProvider, permissonChecker: PermissionManager) -> StartPageViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: NSStringFromClass(self)) as! StartPageViewController
        vc.captureViewController = captureViewController
        vc.permissonChecker = permissonChecker
        return vc
    }
}
