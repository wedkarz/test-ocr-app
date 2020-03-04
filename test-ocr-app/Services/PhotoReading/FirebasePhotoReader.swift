//
//  OtherPhotoReader.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import Firebase
import AVFoundation

class FirebasePhotoReader: PhotoReading {
    init() {
        FirebaseApp.configure()
    }
    
    func read(photo: URL, handler: @escaping TextResultHandler) {
        guard let uiImage = UIImage(contentsOfFile: photo.path) else { return }
        let vision = Vision.vision()
        let textRecognizer = vision.onDeviceTextRecognizer()
        
        let visionImage = VisionImage(image: uiImage)
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                return
            }
            
            let text = result.blocks.map { $0.text }.joined(separator: "\n")
            handler(text)
        }
    }
}
