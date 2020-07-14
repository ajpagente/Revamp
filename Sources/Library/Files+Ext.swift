/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Files

public extension Folder { 
    /// Search for subfolders by providing the expected folder extensions
    func findSubfolders(withExtension extensions: [String]) -> [Folder] {
        let folders        = self.subfolders.recursive
        var matchedFolders = [Folder]()

        for folder in folders {
            for suffix in extensions {
                if folder.name.hasSuffix(suffix) {
                    matchedFolders.append(folder)
                }
            }
        }

        return matchedFolders
    }
}