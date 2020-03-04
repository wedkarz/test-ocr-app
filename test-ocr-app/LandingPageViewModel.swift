//
//  LandingPageViewModel.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 03/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol LandingPageViewModeling {
    func takePicture()
    func browseResults()
    func newPhoto(_ photo: UIImage)
}

class LandingPageViewModel: LandingPageViewModeling {
    private let photoReader: PhotoReading
    private let dataManager: DataManagement
    
    private(set) var image: UIImage? = nil {
        didSet {
            didUpdate?(self)
        }
    }
    
    private(set) var text: String? = nil {
        didSet {
            didUpdate?(self)
        }
    }
    
    var didUpdate: ((LandingPageViewModel) -> ())? = nil
    
    init(photoReader: PhotoReading, dataManager: DataManagement) {
        self.photoReader = photoReader
        self.dataManager = dataManager
    }
    
    
    func takePicture() {
        
    }
    
    func browseResults() {
        
    }
    
    func newPhoto(_ photo: UIImage) {
        let fixedPhoto = photo.fixOrientation()
        guard let imageURL = dataManager.saveImage(fixedPhoto) else { return }
        
        image = fixedPhoto
        text = nil
        
        photoReader.read(photo: imageURL) { [weak self] text in
            guard let self = self else { return }
            
            self.dataManager.saveTextForImage(at: imageURL, text: text)
            self.text = text
        }
    }
}
