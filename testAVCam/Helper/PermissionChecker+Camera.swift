//
//  PermissionChecker+Camera.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import Foundation
import RxSwift
import AVFoundation


protocol PermissionChecker {
    func checkPermission() -> Observable<Bool>
}

extension PermissionChecker {
    func checkPermission() -> Observable<Bool> {
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
}
