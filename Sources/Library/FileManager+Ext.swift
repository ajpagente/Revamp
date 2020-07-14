/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

extension FileManager {
    func createTemporaryDirectory(atPath path: String) throws -> URL {
        // let fileManager = FileManager.default

        let tempDirectoryURL   = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let tempExtractionURL  = tempDirectoryURL.appendingPathComponent(path)
        let tempExtractionPath = tempExtractionURL.path

        if self.fileExists(atPath: tempExtractionPath) {
            try self.removeItem(atPath: tempExtractionPath)
        }

        try self.createDirectory(atPath: tempExtractionPath, withIntermediateDirectories: false, attributes: nil)

        return tempExtractionURL
    }    
    
}