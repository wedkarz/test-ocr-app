//
//  AlertsFactory.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 04/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit

class AlertsFactory {
    func createCameraAlertController(text: String) -> UIViewController {
        let alert = UIAlertController(title: "Camera Access", message: text, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            alert.dismiss(animated: true, completion: nil)
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }
        
        alert.addAction(okAction)
        alert.addAction(settingsAction)
        
        return alert
    }
}
