//
//  DataManagement.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 03/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit.UIImage

protocol DataManagement {
    func getImages() -> [URL]
    
    func saveImage(_ image: UIImage) -> URL?
    @discardableResult func saveTextForImage(at url: URL, text: String) -> Bool
    
    func readImage(at url: URL) -> UIImage?
    func readTextForImage(at url: URL) -> String?
}
