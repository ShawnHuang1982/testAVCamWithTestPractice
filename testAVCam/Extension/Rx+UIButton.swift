//
//  Rx+UIButton.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    public var touchUpInside: ControlEvent<Void> {
        self.controlEvent(.touchUpInside)
    }
}
