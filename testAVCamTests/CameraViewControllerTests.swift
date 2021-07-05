//
//  CameraViewControllerTests.swift
//  testAVCamTests
//
//  Created by huang on 2021/7/3.
//

import XCTest
import AVFoundation
import RxSwift
import UIKit
@testable import testAVCam

class CameraViewControllerTests: XCTestCase {

    var disposeBag = DisposeBag()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    ///初始化 isloading false
    func test_afterProcessing_isLoadingOff() {
        let sut = makeSUT().0
        let exp = expectation(description: "isLoading false")
        sut.viewModel.isLoading
            .subscribe(onNext: { isLoading in
            //assert
                XCTAssertFalse(isLoading)
                exp.fulfill()
            }).disposed(by: self.disposeBag)
        sut.captureController?.delegate?.photoProcessing(false)
        wait(for: [exp], timeout: 1)
    }
    
    ///點擊拍照鈕, 當圖片處理中, isloading為true(顯示activity)
    func test_whenProcessing_isLoadingOn() {
        let sut = makeSUT().0
        let exp = expectation(description: "isLoading true")
        sut.viewModel.isLoading
            .subscribe(onNext: { isLoading in
            //assert
                XCTAssertTrue(isLoading)
                exp.fulfill()
            }).disposed(by: self.disposeBag)
        sut.captureController?.tapCapture()
        wait(for: [exp], timeout: 1)
    }
    
    ///點擊拍照鈕, 得到照片
    func test_tapCaptureButton_getPhoto() {
        let (sut, spyDelegate) = makeSUT()
        let exp = expectation(description: "get photo")
        spyDelegate.asyncExpectation = exp
        sut.delegate = spyDelegate
        XCTAssertNil(spyDelegate.imageWithDelegateAsyncResult)
       
        sut.captureController?.tapCapture()
        
        waitForExpectations(timeout: 1) { (error) in
            XCTAssertEqual(spyDelegate.imageWithDelegateAsyncResult, UIImage(named: "CapturePhoto"))
        }
    }
    
    private func makeSUT(authorizationVideoStatus: AVAuthorizationStatus = .authorized) -> (CameraViewController, MockImageCaptureProviderDelegate) {
        let mockVideoSessionCaptureImageProvider: VideoSessionImageCaptureProvider = MockVideoSessionController()
        let permissionChecker = PermissionManager(device: MockCaptureDevice(authorizationVideoStatus: authorizationVideoStatus, completionHandler: { _ in }, granted: true))
        let delegate = MockImageCaptureProviderDelegate()
        let sut = CameraViewController(captureController: mockVideoSessionCaptureImageProvider, imageCaptureProviderDelegate: delegate, permissionChecker: permissionChecker)
        sut.loadViewIfNeeded()
        return (sut, delegate)
    }

}

class MockVideoSessionController: UIViewController, VideoSessionImageCaptureProvider {
    
    var previewView: PreviewView?
    var delegate: VideoSessionControllerDelegate?
    
    func tapCapture() {
        delegate?.photoProcessing(true)
        self.delegate?.savePhoto(UIImage(named: "CapturePhoto")!)
    }
    
    func setupSession() {
        //test if need
    }
    
    func startSession() {
        //test if need
    }
    
    func stopSession() {
        //test if need
    }
    
}

class MockImageCaptureProviderDelegate: ImageCaptureProviderDelegate {
    var asyncExpectation: XCTestExpectation?
    var imageWithDelegateAsyncResult: UIImage?
    
    func getPhoto(image: UIImage) {
        guard let expectation = asyncExpectation else {
          XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
          return
        }
        imageWithDelegateAsyncResult = image
        expectation.fulfill()
    }
}
