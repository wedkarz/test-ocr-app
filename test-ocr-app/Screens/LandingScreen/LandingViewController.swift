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
        let photoReader = PhotoReaderFactory().createPhotoReader()
        let dataManager = DataManager()
        
        self.viewModel = LandingPageViewModel(photoReader: photoReader, dataManager: dataManager)
        
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(viewModel: viewModel)
    }
    
    @IBAction private func takePicture() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: self.presentImagePicker()
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.presentImagePicker()
                    }
                }
            
            case .denied:
                self.presentCameraAlert(text: "You have denied camera access. Without camera you're device have to sadly refuse reading text from image as it is blind. If you think we're good, please go to settings and grant access")
                return

            case .restricted:
                self.presentCameraAlert(text: "Access to camera is restricted and cannot be granted. Contact your parents or administrator")
                return
        @unknown default:
            fatalError()
        }
    }
    
    private func presentCameraAlert(text: String) {
        let alert = AlertsFactory().createCameraAlertController(text: text)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func presentImagePicker() {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.presentCameraAlert(text: "Camera is unavailable")
            return
        }
        
        let availableMediaTypes = UIImagePickerController.availableMediaTypes(for: .camera) ?? []
        if !availableMediaTypes.contains(String(kUTTypeImage)) {
            self.presentCameraAlert(text: "Camera is not capable of capturing images")
        }
        
        self.imagePicker.sourceType = .camera
        self.imagePicker.delegate = self
        self.imagePicker.cameraDevice = .rear
        
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func browseResults() {
        let resultsViewModel = ResultsViewModel(dataManager: DataManager())
        let vc = ResultsTableViewController(viewModel: resultsViewModel)
        
        self.navigationController?.pushViewController(vc, animated: true)
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
        viewModel.processPhoto(photo)
    }
}
