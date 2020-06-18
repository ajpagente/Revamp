/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

struct ProcessOutput {
    var status: Int32
    var output: String
}

extension Process {
    func launchSynchronous() -> ProcessOutput {
        let pipe = Pipe()
        self.standardOutput = pipe
        self.standardError  = pipe
        self.standardInput  = FileHandle.nullDevice

        let pipeFile = pipe.fileHandleForReading
        
        self.launch()
        
        let data = NSMutableData()
        while self.isRunning {
            data.append(pipeFile.availableData)
        }
        
        pipeFile.closeFile();
        self.terminate();
        
        if let output = String.init(data: data as Data, encoding: String.Encoding.utf8) {
            return ProcessOutput(status: self.terminationStatus, output: output)
        } else {
            return ProcessOutput(status: self.terminationStatus, output: "")
        }        
    }
    
    func execute(_ launchPath: String, arguments: [String]?) -> ProcessOutput {
        self.launchPath = launchPath
        if arguments != nil {
            self.arguments = arguments
        }
        return self.launchSynchronous()
    }
}
