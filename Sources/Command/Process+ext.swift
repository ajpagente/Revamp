import Foundation
struct ProcessOutput {
    var output: String
    var status: Int32
    init(status: Int32, output: String){
        self.status = status
        self.output = output
    }
}
extension Process {
    func launchSynchronous() -> ProcessOutput {
        self.standardInput = FileHandle.nullDevice
        let pipe = Pipe()
        self.standardOutput = pipe
        self.standardError = pipe
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
    
    func execute(_ launchPath: String, arguments: [String]?)->ProcessOutput{
        self.launchPath = launchPath
        if arguments != nil {
            self.arguments = arguments
        }
        return self.launchSynchronous()
    }
    
}
