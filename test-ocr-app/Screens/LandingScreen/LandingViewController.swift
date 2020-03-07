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
    @IBOutlet private weak var cardView: UIView!
    
    private var resultScreenVC: UIViewController? = nil
    
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
        
        setup(imagePicker: imagePicker)
        setup(cardView: cardView)
        setup(viewModel: viewModel)
    }
    
    private func setup(imagePicker: UIImagePickerController) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.cameraDevice = .rear
            imagePicker.cameraCaptureMode = .photo
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.imageExportPreset = .current
    }
    
    private func setup(cardView: UIView) {
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showResult)))
    }
    
    @objc private func showResult() {
        let vm = TextResultScreenViewModel(text: viewModel.text ?? "")
        let vc = TextResultScreenViewController(viewModel: vm)
        
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction private func takePicture() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:  self.presentImagePicker()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                // The completion handler is called on an arbitrary dispatch queue. Is it the client's responsibility to ensure that any UIKit-related updates are called on the main queue or main thread as a result.
                
                if granted {
                    DispatchQueue.main.async { self.presentImagePicker() }
                } else {
                    DispatchQueue.main.async { self.presentCameraAlert(text: "You have denied camera access. Without camera you're device have to sadly refuse reading text from image as it is blind. If you think we're good, please go to settings and grant access") }
                }
            }
            
        case .denied:
            self.presentCameraAlert(text: "You have denied camera access. Without camera you're device have to sadly refuse reading text from image as it is blind. If you think we're good, please go to settings and grant access")
            return
            
        case .restricted:
            self.presentCameraAlert(text: "Access to camera is restricted and cannot be granted. Contact your parents or administrator")
            return
        @unknown default:
            assertionFailure("Unhandled camera permission state")
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
        self.cardView.isHidden = ((viewModel.text?.count ?? 0) == 0)
        
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
