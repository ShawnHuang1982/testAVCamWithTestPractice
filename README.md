# Requirement
1. user opens the app
2. show starting page (with a start button)
3. user clicks the start button
4. show camera preview page(with a capture button)
5. user clicks capture button to capture still photo
6. while the camera is capturing the still photo, show awaiting UI
7. photo capture success → back to starting page and show the photo just captured
Technical requirement:
1.use MVVM or other clean architectures, use any observable library (Combine/RxSwift/Delegate/RxCocoa...... or implement yourself) for data binding
2. write unit tests for viewModels / interactors(if any)


# Implement
## 頁面名稱
### StartPageViewController
- 首頁
- 顯示圖片
- 導頁到拍照頁面

### CameraViewController
- 拍照, 取得照片後, 並將結果返回至 前一頁StartPageViewController
- 處理畫面即時Preview

## Reference
- https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcam_building_a_camera_app

