//
//  DataManager.swift
//  test-ocr-app
//
//  Created by Artur Rybak on 03/03/2020.
//  Copyright © 2020 IT ART. All rights reserved.
//

import Foundation
import UIKit

class DataManager: DataManagement {
    private let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
    }
    
    func getImages() -> [URL] {
        guard let documentsDir = getDocumentsDirectory(fileManager: fileManager) else { return [] }
        
        let allFiles = (try? fileManager.contentsOfDirectory(at: documentsDir, includingPropertiesForKeys: nil, options: [])) ?? []
        
        return allFiles.filter { $0.pathExtension == "png" }
    }
    
    func saveImage(_ image: UIImage) -> URL? {
        guard let documentsDir = getDocumentsDirectory(fileManager: fileManager) else { return nil }
        
        let imageName = "ocr_\(Date().timeIntervalSince1970).png"
        let imageFilePath = "\(documentsDir.path)/\(imageName)"
        
        if fileManager.fileExists(atPath: imageFilePath) {
           try? fileManager.removeItem(atPath: imageFilePath)
        }
        
        let isSuccess = fileManager.createFile(atPath: imageFilePath, contents: image.pngData(), attributes: nil)
        
        return isSuccess ? URL(fileURLWithPath: imageFilePath) : nil
    }
    
    func saveTextForImage(at url: URL, text: String) -> Bool {
        guard let documentsDir = getDocumentsDirectory(fileManager: fileManager) else { return false }
        
        let imageName = url.deletingPathExtension().lastPathComponent
        let textfileName = "\(imageName)_text.txt"
        let textfilePath = "\(documentsDir.path)/\(textfileName)"
        
        if fileManager.fileExists(atPath: textfilePath) {
           try? fileManager.removeItem(atPath: textfilePath)
        }
        
        let isSuccess = fileManager.createFile(atPath: textfilePath, contents: text.data(using: .utf8), attributes: nil)
        
        return isSuccess
    }
    
    func readImage(at url: URL) -> UIImage? {
        return UIImage(contentsOfFile: url.path)
    }
    
    func readTextForImage(at url: URL) -> String? {
        guard let filePath = textfilePathForImageURL(url) else { return nil }
        
        return try? String(contentsOfFile: filePath)
    }
    
    private func textfilePathForImageURL(_ url: URL) -> String? {
        guard let documentsDir = getDocumentsDirectory(fileManager: fileManager) else { return nil }
        
        let imageName = url.deletingPathExtension().lastPathComponent
        let textfileName = "\(imageName)_text.txt"
        let textfilePath = "\(documentsDir.path)/\(textfileName)"
        
        return textfilePath
    }
    
    private func getDocumentsDirectory(fileManager: FileManager) -> URL? {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
}
