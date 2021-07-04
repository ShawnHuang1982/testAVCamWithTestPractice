//
//  StartPageViewControllerTests.swift
//  testAVCamTests
//
//  Created by huang on 2021/7/3.
//

import XCTest
import AVFoundation
import RxSwift
@testable import testAVCam

class StartPageViewControllerTests: XCTestCase {

    var disposeBag = DisposeBag()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    ///初始化時, 顯示空白圖片
    func test_init_getEmptyImage() {
        let sut = makeSUT().0
        XCTAssertNil(sut.imagePreview.imageView.image)
    }
    
    ///delegate取得圖片, 顯示圖片
    func test_afterGetImage_previewHasImage() {
        //given
        let (sut, imageProvider) = makeSUT()
        XCTAssertNil(sut.imagePreview.imageView.image)
        let testImage = UIImage(named: "CapturePhoto")!
        //when
        imageProvider.delegate?.getPhoto(image: testImage)
        //assert
        XCTAssertEqual(sut.imagePreview.imageView.image, testImage)
    }

    ///使用者拒絕相機權限, 不能進入相機頁面
    func test_permission_denied() {
        
        let sut = makeSUT(authorizationVideoStatus: .denied).0
        let exp = expectation(description: "")
        
        sut.viewModel.nextPageIfCan
            .subscribe(onNext: { (allowed) in
            //assert
            XCTAssertFalse(allowed)
            exp.fulfill()
        }).disposed(by: self.disposeBag)
        
        //when
        sut.goCameraButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    ///使用者同意相機權限, 點擊下一頁後可以進入相機頁面
    func test_permission_allowed() {
        
        let sut = makeSUT(authorizationVideoStatus: .authorized).0
        let exp = expectation(description: "")
        
        sut.viewModel.nextPageIfCan
            .subscribe(onNext: { (allowed) in
            //assert
            XCTAssertTrue(allowed)
            exp.fulfill()
        }).disposed(by: self.disposeBag)
        
        //when
        sut.goCameraButton.sendActions(for: .touchUpInside)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    private func makeSUT(authorizationVideoStatus: AVAuthorizationStatus = .authorized) -> (StartPageViewController, ImageCaptureProvider) {
        let mockImageProvider = MockImageCaptureProvider()
        let permissionChecker = PermissionManager(device: MockCaptureDevice(authorizationVideoStatus: authorizationVideoStatus, completionHandler: { _ in }, granted: true))
        let sut = StartPageViewController.instantiate (captureViewController: mockImageProvider, permissonChecker: permissionChecker)
        sut.loadViewIfNeeded()
        return (sut, mockImageProvider)
    }
    
}

class MockCaptureDevice: CaptureDevice {
    
    typealias RequestCompletionHandler = (Bool) -> Void
    
    init(authorizationVideoStatus: AVAuthorizationStatus, completionHandler: @escaping RequestCompletionHandler, granted: Bool) {
        self.authorizationVideoStatus = authorizationVideoStatus
        self.completionHandler = completionHandler
        self.granted = granted
    }
    
    var authorizationVideoStatus: AVAuthorizationStatus
    var completionHandler: RequestCompletionHandler
    var granted: Bool
    func requestAccess(completionHandler: @escaping RequestCompletionHandler) {
        self.completionHandler(granted)
    }
}

class MockImageCaptureProvider: UIViewController, ImageCaptureProvider {
    var delegate: ImageCaptureProviderDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
