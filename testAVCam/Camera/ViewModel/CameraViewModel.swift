//
//  CameraViewModel.swift
//  testAVCam
//
//  Created by huang on 2021/7/3.
//

import Foundation
import RxSwift
import RxCocoa

class CameraViewModel {
    
    var startSession = PublishRelay<Void>()
    
    var stopSession = PublishRelay<Void>()
    
    var setupSession = PublishRelay<Void>()
    
    var isLoading = BehaviorRelay<Bool>(value: false)
    
}

