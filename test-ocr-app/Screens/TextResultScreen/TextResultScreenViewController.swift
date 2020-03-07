//
//  ResultScreen.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 07/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit

class TextResultScreenViewController: UIViewController {
    private let viewModel: TextResultScreenViewModel
    
    private let textView = UITextView()
    private lazy var closeButton: UIButton = {
        if #available(iOS 13.0, *) {
            return UIButton(type: .close)
        } else {
            return UIButton(type: .system)
        }
    }()
    
    init(viewModel: TextResultScreenViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = UIColor.systemBackground
        } else {
            self.view.backgroundColor = UIColor.white
        }
        
        configureCloseButton()
        configureTextView()
        configureAutolayout()
        setup(with: self.viewModel)
    }
    
    private func setup(with vm: TextResultScreenViewModel) {
        textView.text = vm.text
    }
    
    private func configureTextView() {
        view.addSubview(textView)
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
    
    private func configureAutolayout() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10).isActive = true
        closeButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 10).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
    }
}
