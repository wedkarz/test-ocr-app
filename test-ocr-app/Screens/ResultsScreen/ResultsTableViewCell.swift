//
//  ResultsTableViewCell.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ResultsTableViewCell: UITableViewCell {
    static let reuseIdentifier = "ResultsTableViewCellIdentifier"
    override func prepareForReuse() {
        self.imageView?.image = nil
    }
    
    func setup(with vm: ResultItemViewModel) {
        self.accessoryType = .disclosureIndicator
        
        let processor = DownsamplingImageProcessor(size: CGSize(width: 80, height: 80))
                        |> RoundCornerImageProcessor(cornerRadius: 5)
        
        self.imageView?.kf.indicatorType = .activity
        self.imageView?.kf.setImage(with: LocalFileImageDataProvider(fileURL: vm.imageURL),
                                    placeholder: UIImage(named: "placeholder_image"),
                                    options: [
                                        .processor(processor),
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
        ])
        
        self.textLabel?.numberOfLines = 0
        self.textLabel?.text = vm.text
        
        vm.didUpdate = self.setup
    }
}
