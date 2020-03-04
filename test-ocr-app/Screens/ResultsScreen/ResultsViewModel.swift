//
//  ResultsViewModel.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit

class ResultItemViewModel {
    let imageURL: URL
    private(set) var text: String?
    var didUpdate: ((ResultItemViewModel) -> ())? = nil
    
    private let queue = DispatchQueue(label: "queue.background.image", qos: .background, target: nil)
    private let dataManager: DataManager
    

    init(imageURL: URL, dataManager: DataManager) {
        self.imageURL = imageURL
        self.dataManager = dataManager
        
        load()
    }
    
    private func load() {
        queue.async {
            self.text = self.dataManager.readTextForImage(at: self.imageURL)
            
            DispatchQueue.main.async {
                self.didUpdate?(self)
            }
        }
    }
}

class ResultsViewModel {
    let itemViewModels: [ResultItemViewModel]
    
    init(dataManager: DataManager) {
        itemViewModels = dataManager.getImages().map { ResultItemViewModel(imageURL: $0, dataManager: dataManager) }
            .sorted(by: { (el1, el2) -> Bool in
                el1.imageURL.deletingPathExtension().lastPathComponent > el2.imageURL.deletingPathExtension().lastPathComponent
        })
    }
}
