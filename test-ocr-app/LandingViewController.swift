//
//  LandingViewController.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 03/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices

class LandingViewController: UIViewController {
    @IBOutlet private weak var previewView: UIImageView!
    @IBOutlet private weak var takePictureButton: UIButton!
    @IBOutlet private weak var browseResultsButton: UIButton!
    @IBOutlet private weak var resultTextView: UITextView!
    
    private let viewModel: LandingPageViewModel
    
    private let imagePicker: UIImagePickerController = UIImagePickerController()
    
    required init?(coder: NSCoder) {
        if #available(iOS 13.0, *) {
            self.viewModel = LandingPageViewModel(photoReader: VisionPhotoReader(), dataManager: DataManager())
        } else {
            self.viewModel = LandingPageViewModel(photoReader: OtherPhotoReader(), dataManager: DataManager())
        }
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(viewModel: viewModel)
    }
    
    @IBAction private func takePicture() {
        // TODO: handle revoking authorization
        // TODO: handle denied/restricted states
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: self.presentImagePicker()
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.presentImagePicker()
                    }
                }
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        }
    }
    
    private func presentImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
        } else {
            // TODO: present info that camre permission is needed
            return
        }
        
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        if !availableMediaTypes.contains(String(kUTTypeImage)) {
            // TODO: error - cannot take still image
        }
        
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        self.imagePicker.cameraDevice = .rear
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func browseResults() {
        self.viewModel.browseResults()
    }
    
    private func setup(viewModel: LandingPageViewModel) {
        self.resultTextView.text = viewModel.text
        self.previewView.image = viewModel.image
        self.resultTextView.isHidden = (viewModel.text?.count == 0)
        
        viewModel.didUpdate = self.setup
    }
}

extension LandingViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.imagePicker.dismiss(animated: true, completion: nil)
        
        guard let photo = info[.originalImage] as? UIImage else { return }
        viewModel.newPhoto(photo)
    }
}
