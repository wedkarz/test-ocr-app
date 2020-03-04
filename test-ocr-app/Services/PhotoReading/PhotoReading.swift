//
//  PhotoReading.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 03/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoReading {
    typealias TextResultHandler = (String) -> ()
    
    func read(photo: URL, handler: @escaping TextResultHandler)
}
