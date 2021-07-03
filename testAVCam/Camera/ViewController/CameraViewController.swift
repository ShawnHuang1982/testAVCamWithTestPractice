//
//  CameraViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift


protocol CameraViewControllerDelegate: class {
    func getPhoto(image: UIImage)
}

class CameraViewController: UIViewController, PermissionChecker {
    
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet private weak var previewView: PreviewView!
    
    private var disposeBag: DisposeBag = DisposeBag()
    private var spinner: UIActivityIndicatorView!
    
    var windowOrientation: UIInterfaceOrientation {
        return view.window?.windowScene?.interfaceOrientation ?? .unknown
    }

    weak var delegate: CameraViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkPermission()
            .subscribe(onNext: { [weak self] allowed in
                if allowed {
                    self?.launchSession()
                } else {
                    self?.presentAlertView(type: .okAction(message: "發生錯誤了，請檢查相關設定", handler: { (action) in
                        self?.dismiss(animated: true, completion: nil)
                    }))
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopSession()
        super.viewWillDisappear(animated)
    }
    
    private func setupBinding() {
        
        takeButton.rx.touchUpInside.bind{
            
        }.disposed(by: self.disposeBag)
        
        dismissButton.rx.touchUpInside.bind{ [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }.disposed(by: self.disposeBag)
    }
    
    private func launchSession() {
        
    }
    
    private func stopSession() {
        
    }
}
