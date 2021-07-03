//
//  StartPageViewControllerTests.swift
//  testAVCamTests
//
//  Created by huang on 2021/7/3.
//

import XCTest
import AVFoundation
@testable import testAVCam

class StartPageViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_init_getEmptyImage() {
        let mockImageProvider = MockImageCaptureProvider()
        let permissionChecker = PermissionManager(device: MockCaptureDevice(authorizationVideoStatus: .authorized, completionHandler: { _ in }, granted: true))
        let sut = StartPageViewController.instantiate (captureViewController: mockImageProvider, permissonChecker: permissionChecker)
        sut.loadViewIfNeeded()
        XCTAssertNil(sut.imagePreview.imageView.image)
    }
    
    func test_afterGetImage_previewHasImage() {
        let mockImageProvider = MockImageCaptureProvider()
        let permissionChecker = PermissionManager(device: MockCaptureDevice(authorizationVideoStatus: .authorized, completionHandler: { _ in }, granted: true))
        let sut = StartPageViewController.instantiate (captureViewController: mockImageProvider, permissonChecker: permissionChecker)
        sut.loadViewIfNeeded()
        XCTAssertNil(sut.imagePreview.imageView.image)

        let testImage = UIImage(named: "CapturePhoto")!
        mockImageProvider.delegate?.getPhoto(image: testImage)
        XCTAssertEqual(sut.imagePreview.imageView.image, testImage)
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
