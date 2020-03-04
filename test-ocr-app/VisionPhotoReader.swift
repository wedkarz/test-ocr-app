//
//  PhotoReader.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 03/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import Vision

@available(iOS 13.0, *)
class VisionPhotoReader: PhotoReading {    
    func read(photo: URL, handler: @escaping TextResultHandler) {
        let requestHandler = VNImageRequestHandler(url: photo, options: [:])
        
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            let textFromPicture = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            handler(textFromPicture)
        }
        
        request.recognitionLevel = .accurate
        
        try? requestHandler.perform([request])
    }
}
