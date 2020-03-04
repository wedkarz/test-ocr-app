//
//  PhotoReaderFactory.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation

class PhotoReaderFactory {
    func createPhotoReader() -> PhotoReading {
        if #available(iOS 13.0, *) {
            return VisionPhotoReader()
        } else {
            return FirebasePhotoReader()
        }
    }
}
