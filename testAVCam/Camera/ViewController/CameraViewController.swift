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
    func dismissed()
}

class CameraViewController: UIViewController {
    
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet private weak var previewView: PreviewView!
    
    private var disposeBag: DisposeBag = DisposeBag()
    lazy var spinner: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
        spinner.color = .blue
        self.view.addSubview(spinner)
        return spinner
    }()

    weak var delegate: CameraViewControllerDelegate?
    
    var captureController: VideoSessionController?
    var checker: PermissionManager = PermissionManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checker
            .requestVideoPermission()
            .subscribe(onNext: { [weak self] allowed in
                if allowed {
                    self?.startSession()
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
    
    deinit {
        print(#file, "deinit")
    }
    
    private func setupBinding() {
        
        takeButton.rx.touchUpInside.observe(on: MainScheduler.instance)
            .bind { [weak self] in
            self?.captureController?.tapCapture()
        }.disposed(by: self.disposeBag)
        
        dismissButton.rx.touchUpInside.observe(on: MainScheduler.instance)
            .bind{ [weak self] in
                self?.dismiss(animated: true, completion: {
                    self?.delegate?.dismissed()
                })
            }.disposed(by: self.disposeBag)
    }
    
    private func setupUI() {
        captureController = VideoSessionController(previewView: previewView)
        captureController?.delegate = self
        captureController?.setupSession()
    }
    
    private func startSession() {
        captureController?.startSession()
    }
    
    private func stopSession() {
        captureController?.stopSession()
    }
}

extension CameraViewController: VideoSessionControllerDelegate {
    func savePhoto(_ image: UIImage) {
        self.dismiss(animated: true) {
            self.delegate?.getPhoto(image: image)
        }
    }
    
    func photoProcessing(_ animate: Bool) {
        DispatchQueue.main.async {
            if animate {
                self.spinner.startAnimating()
                print("spinner start")
            } else {
                self.spinner.stopAnimating()
                print("spinner end")
            }
        }
    }
}
