/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files


public class ShowCommand: Command {
    private var basicOutput: [String] = []
    private var groups: [OutputGroup] = []
    private var verbose: Bool {
        return input.flags.contains("verbose")
    }
    private var colorize: Bool {
        return input.flags.contains("colorize")
    }
    private var translationFile: File? {
        if let translationPath = input.options["translation-path"] {
            do { 
                return try File(path: translationPath)
            } catch {
                return nil
            }
        } 
        return nil
    }
    private var isUUID: Bool {
        return input.flags.contains("uuid")
    }

    public override class var assignedName: String {
        return "show"
    }

    public override func execute() -> CommandOutput {
        let subCommand = input.subCommand

        switch subCommand {
            case "info":
                do {
                    let commandArgument = input.arguments.first!
                    let split = commandArgument.components(separatedBy: ".")
                    switch split.last {
                    case "ipa":
                        let file = try File(path: input.arguments.first!)
                        return processIpa(files: [file])
                    case "mobileprovision":
                        let file = try File(path: input.arguments.first!)
                        return processProfile(files: [file])
                    default:
                        if isUUID {
                            do {
                                let files = try findProfile(from: input.arguments.first!)
                                return processProfile(files: files)
                                // TODO: What happens if UUID does not match?
                            } catch {
                                return CommandOutput(errorCode: .invalidArgument, message: ["File not found or the file is corrupt."])
                            }

                        } else {
                          return CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
                        }
                    }
                } catch {
                    return CommandOutput(errorCode: .invalidArgument, message: ["File not found or the file is corrupt."])
                }
                
            default:
                return CommandOutput(errorCode: .unknownCommand, message: ["Unknown command"])
        }
    }

    private func processIpa(files: [File]) -> CommandOutput {
        return getIpaInfo(files.first!)
    }

    private func processProfile(files: [File]) -> CommandOutput {
        do {
            if files.count > 1 {
                var output = [String]()
                output.append("Multiple profiles found:")
                for file in files {
                    output.append(try ProfileAnalyzer.getNameUUID(from: file))
                }
                return CommandOutput(message: output)
            } else {
                guard let file = files.first else {
                    return CommandOutput(errorCode: .invalidArgument, message: ["File not found or the file is corrupt."])
                }
                return getProfileInfo(file)
            }
        } catch {
            return CommandOutput(errorCode: .invalidArgument, message: ["File not found or the file is corrupt."])
        }
        
    }
    
    private func findProfile(from uuid: String) throws -> [File] {
        var matchingFiles = [File]()

        let profileFolder = try Folder.home.subfolder(at: "Library/MobileDevice/Provisioning Profiles")
        let files = profileFolder.files
        for file in files {
            if file.extension == "mobileprovision" {
                let uuidFromFile = try ProfileAnalyzer.getUUID(from: file)
                if uuidFromFile.contains(uuid) {
                    matchingFiles.append(file)
                }
            }             
        }
        return matchingFiles
    }

    private func getIpaInfo(_ file: File) -> CommandOutput {
        do {
            if verbose { 
                groups  = try AppAnalyzer.getAllInfo(from: file, colorize: colorize, translateWith: translationFile) 
            } else {
                groups  = try AppAnalyzer.getLimitedInfo(from: file, colorize: colorize)
            }
            basicOutput = formatOutput(groups)
        } catch {
            print("\(error)")
            return CommandOutput(errorCode: .ipaParsingError, message: ["Error when parsing ipa."])
        }

        return CommandOutput(message: basicOutput)
    }

    private func getProfileInfo(_ file: File) -> CommandOutput {
        do {
            if verbose { 
                groups  = try ProfileAnalyzer.getAllInfo(from: file, colorize: colorize, translateWith: translationFile) 
            } else {
                groups  = try ProfileAnalyzer.getLimitedInfo(from: file, colorize: colorize)
            }
            basicOutput = formatOutput(groups)
        } catch {
            print("\(error)")
            return CommandOutput(errorCode: .ipaParsingError, message: ["Error when parsing profile."])
        }

        return CommandOutput(message: basicOutput)
    }

    private func formatOutput(_ groups: [OutputGroup]) -> [String] {
        var formatted:[String] = []
        let formatter = OutputFormatter()
        for group in groups {
            formatted.append(contentsOf: formatter.strings(from: group))
        }
        return formatted
    }
}