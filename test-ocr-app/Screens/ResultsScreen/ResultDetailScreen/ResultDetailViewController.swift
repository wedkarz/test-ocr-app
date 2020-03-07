//
//  ResultDetailViewController.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 07/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ResultDetailViewController: UIViewController {
    private let viewModel: ResultDetailViewModel
    
    private let imageView: UIImageView = UIImageView()
    private let textView: UITextView = UITextView()
    
    private var imageViewConstraints: (portrait: [NSLayoutConstraint], landscape: [NSLayoutConstraint]) = ([], [])
    private var textViewConstraints: (portrait: [NSLayoutConstraint], landscape: [NSLayoutConstraint]) = ([], [])
    
    private lazy var closeButton: UIButton = {
        if #available(iOS 13.0, *) {
            return UIButton(type: .close)
        } else {
            return UIButton(type: .system)
        }
    }()
    
    init(viewModel: ResultDetailViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = UIColor.white
        }
        
        view.addSubview(imageView)
        view.addSubview(textView)
        
        textView.isEditable = false
        textView.isScrollEnabled = true
        
        setup(with: viewModel)
        configureCloseButton()
        setupConstraints()
    }
    
    private func setup(with viewModel: ResultDetailViewModel) {
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: LocalFileImageDataProvider(fileURL: viewModel.imageURL),
                                    placeholder: UIImage(named: "placeholder_image"),
                                    options: [
                                        .transition(.fade(1)),
                                        .cacheOriginalImage
        ])
        
        textView.text = viewModel.text
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let imageViewPortraitConstraints =
            [imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             imageView.topAnchor.constraint(equalTo: view.topAnchor),
             imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
             imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)]
        
        let imageViewLandscapeConstraints =
            [imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)]
        
        self.imageViewConstraints = (imageViewPortraitConstraints, imageViewLandscapeConstraints)
        
        let textViewPortraitConstraints =
            [textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
             textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
             textView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
             textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 8.0)]
        
        let textViewLandscapeConstraints =
            [textView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8.0),
         textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
         textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
         textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)]
        
        self.textViewConstraints = (textViewPortraitConstraints, textViewLandscapeConstraints)
        
        updateConstraints()
    }
    
    private func configureCloseButton() {
        view.addSubview(closeButton)
        
        
        if #available(iOS 13.0, *) {
        } else {
             closeButton.setTitle("Close", for: .normal)
        }
        
        closeButton.addTarget(self, action: #selector(closeModal), for: .touchUpInside)
    }
    
    @objc private func closeModal() {
        dismiss(animated: true, completion: nil)
    }
    
    private func updateConstraints() {
        if UIDevice.current.orientation.isPortrait {
            NSLayoutConstraint.deactivate(imageViewConstraints.landscape)
            NSLayoutConstraint.deactivate(textViewConstraints.landscape)
            
            NSLayoutConstraint.activate(imageViewConstraints.portrait)
            NSLayoutConstraint.activate(textViewConstraints.portrait)
        } else {
            NSLayoutConstraint.deactivate(imageViewConstraints.portrait)
            NSLayoutConstraint.deactivate(textViewConstraints.portrait)
            
            NSLayoutConstraint.activate(imageViewConstraints.landscape)
            NSLayoutConstraint.activate(textViewConstraints.landscape)
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        updateConstraints()
    }
}
