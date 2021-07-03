//
//  PermissionChecker+Camera.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import Foundation
import RxSwift
import AVFoundation


protocol CaptureDevice {
    var authorizationVideoStatus: AVAuthorizationStatus { get }
    func requestAccess(completionHandler: @escaping (Bool)->Void)
}

class AVDevice: CaptureDevice {
    
    init() {
        
    }
    
    deinit {
        print("av device deint")
    }
    
    func requestAccess(completionHandler: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
            completionHandler(granted)
        })
    }
    
    var authorizationVideoStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
    
}

class PermissionManager {
    
    var device: CaptureDevice?
    
    init(device: CaptureDevice? = nil) {
        self.device = AVDevice()
    }
    
    deinit {
        print("PermissionManager deint")
    }
    
    func requestVideoPermission() -> Observable<Bool> {
        return Observable.create { [weak self] observer -> Disposable in
            switch self?.device?.authorizationVideoStatus {
            case .authorized:
                observer.onNext(true)
            case .notDetermined:
                self?.device?.requestAccess { (granted) in
                    observer.onNext(granted)
                }
            default:
                observer.onNext(false)
            }
            return Disposables.create()
        }
    }
}
