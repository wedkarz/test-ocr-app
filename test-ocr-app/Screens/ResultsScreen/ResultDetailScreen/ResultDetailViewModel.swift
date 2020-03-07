//
//  ResultDetailViewModel.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 07/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation

class ResultDetailViewModel {
    let text: String
    let imageURL: URL
    
    init(text: String, imageURL: URL) {
        self.text = text
        self.imageURL = imageURL
    }
}
