//
//  CameraAvailabilityService.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation

class CameraAvailabilityService {
    func checkCameraAvailability() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized: self.presentImagePicker()
            case .notDetermined: // The user has not yet been asked for camera access.
                
            
            case .denied: // The user has previously denied access.
                return

            case .restricted: // The user can't grant access due to restrictions.
                return
        }
    }
}
