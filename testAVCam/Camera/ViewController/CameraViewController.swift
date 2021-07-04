//
//  CameraViewController.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit
import RxSwift

class CameraViewController: UIViewController, ImageCaptureProvider {
    
    
    @IBOutlet weak var takeButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet private weak var previewView: PreviewView!
    
    lazy var spinner: UIActivityIndicatorView! = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
        spinner.color = .blue
        self.view.addSubview(spinner)
        return spinner
    }()

    private var disposeBag: DisposeBag = DisposeBag()
    var captureController: VideoSessionImageCaptureProvider?
    var permissionChecker: PermissionManager!
    var delegate: ImageCaptureProviderDelegate?
    var viewModel: CameraViewModel = CameraViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        permissionChecker
            .requestVideoPermission()
            .subscribe(onNext: { [weak self] allowed in
                if allowed {
                    self?.viewModel.startSession.accept(())
                } else {
                    self?.presentAlertView(type: .okAction(message: "發生錯誤了，請檢查相關設定", handler: { (action) in
                        self?.dismiss(animated: true, completion: nil)
                    }))
                }
            }).disposed(by: self.disposeBag)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.stopSession.accept(())
        super.viewWillDisappear(animated)
    }
    
    convenience init(captureController: VideoSessionImageCaptureProvider = VideoSessionController(), imageCaptureProviderDelegate: ImageCaptureProviderDelegate?, permissionChecker: PermissionManager = PermissionManager()) {
        self.init()
        self.captureController = captureController
        self.captureController?.delegate = self
        self.delegate = imageCaptureProviderDelegate
        self.permissionChecker = permissionChecker
    }
    
    private func setupUI() {
        self.captureController?.previewView = previewView
        viewModel.setupSession.accept(())
    }
    
    private func setupBinding() {
        
        takeButton.rx.touchUpInside.observe(on: MainScheduler.instance)
            .bind { [weak self] in
            self?.captureController?.tapCapture()
        }.disposed(by: self.disposeBag)
        
        dismissButton.rx.touchUpInside.observe(on: MainScheduler.instance)
            .bind{ [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }.disposed(by: self.disposeBag)
        
        viewModel.isLoading.subscribe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] animate in
                animate ?
                    self?.spinner.startAnimating() :
                    self?.spinner.stopAnimating()
            }).disposed(by: self.disposeBag)
        
        viewModel.setupSession.subscribe(onNext: { [weak self] in
            self?.captureController?.setupSession()
        }).disposed(by: self.disposeBag)
        
        viewModel.startSession.subscribe(onNext: { [weak self] in
            self?.captureController?.startSession()
        }).disposed(by: self.disposeBag)
        
        viewModel.stopSession.subscribe(onNext: { [weak self] in
            self?.captureController?.stopSession()
            self?.viewModel.isLoading.accept(false)
        }).disposed(by: self.disposeBag)
    }
}

extension CameraViewController: VideoSessionControllerDelegate {
    func savePhoto(_ image: UIImage) {
        self.dismiss(animated: true) { [weak self] in
            self?.delegate?.getPhoto(image: image)
        }
    }
    
    func photoProcessing(_ animate: Bool) {
        self.viewModel.isLoading.accept(animate)
    }
}
