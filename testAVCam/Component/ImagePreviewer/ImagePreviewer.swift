//
//  ImagePreviewer.swift
//  testAVCam
//
//  Created by huang on 2021/7/2.
//

import UIKit

class ImagePreviewer: UIView, NibOwnerLoadable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipsLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        setupView()
    }
    
    func customInit() {
        loadNibContent()
    }
    
    private func setupView() {
        self.tipsLabel.text = "預覽圖片"
        self.backgroundColor = .green
    }
}
