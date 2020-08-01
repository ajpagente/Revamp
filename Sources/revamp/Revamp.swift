/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import ArgumentParser
import Foundation
import Library

struct Revamp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility that provides signing environment query capabilities and app info.",
        subcommands: [List.self, Show.self])

    struct Options: ParsableArguments {
        @Flag(name: .shortAndLong, help: "Increase verbosity for informational output.")
        var verbose = false
    }
}




extension Revamp {
    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Print available provisioning profiles",
            subcommands: [Profile.self])
    }
    
    struct Show: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Display information about an Apple binary",
            subcommands: [Info.self])
    }

    // struct Sign: ParsableCommand {
    //     static var configuration = CommandConfiguration(abstract: "Sign and analyze signatures of Mac and iOS apps.",
    //         subcommands: [Display.self, Code.self, Verify.self],
    //         defaultSubcommand: Display.self)
    // }
}

extension Revamp.List {
    struct Profile: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Print provisioning profiles.")

        @OptionGroup()
        var options: Revamp.Options

        mutating func run() {
            let commandFactory = CommandFactory()
            var command = commandFactory.createCommand(ofType: .list, withSubCommand: "profile", arguments: ["":""])

            let status = command.execute()
            if status {
                if options.verbose {
                    for output in command.getOutput(.verbose) {
                        print(output + "\n")
                    }
                } else {
                    for output in command.getOutput(.simple) {
                        print(output)
                    }
                }
            }       
        }
    }
}

extension Revamp.Show {
    struct Info: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Display information about an Apple binary.")

        @Argument()
        var file: String

        mutating func run() {
            let commandFactory = CommandFactory()
            var command = commandFactory.createCommand(ofType: .show, withSubCommand: "info", arguments: ["file":file])

            let status = command.execute()
            if status {
                for output in command.getOutput(.simple) {
                    print(output)
                }
            }       
        }
    }
}

// extension Revamp.Sign {
//     struct Display: ParsableCommand {
//         static var configuration = CommandConfiguration(abstract: "Print app signature details.")

//         @OptionGroup()
//         var options: Options

//         @Option(name: .shortAndLong, help: "The ipa or app")
//         var file: String

//         mutating func run() {
//             let commandFactory = CommandFactory()
//             var command = commandFactory.createCommand(ofType: .sign, withSubCommand: "display", arguments: ["file": file])

//             let status = command.execute()
//             if status {
//                 if options.verbose {
//                     for output in command.getOutput(.verbose) {
//                         print(output + "\n")
//                     }
//                 } else {
//                     for output in command.getOutput(.simple) {
//                         print(output)
//                     }
//                 }
//             }       
//         }
//     }

//     struct Code: ParsableCommand {
//         static var configuration = CommandConfiguration(abstract: "(Re)sign an ipa or app")

//         @OptionGroup()
//         var options: Options

//         @Option(name: .shortAndLong, help: "The ipa or app")
//         var file: String

//         @Option(name: .shortAndLong, help: "The signing certificate Common Name or the SHA1 hash value. The hash value may contain spaces.")
//         var certificate: String

//         mutating func run() {
//             let commandFactory = CommandFactory()
//             var command = commandFactory.createCommand(ofType: .sign, withSubCommand: "code", 
//                                                     arguments: ["file": file, "certificate":certificate])
//             let status = command.execute()    
//         }
//     }

//     struct Verify: ParsableCommand {
//         static var configuration = CommandConfiguration(abstract: "Verify app signature.")

//         @OptionGroup()
//         var options: Options

//         mutating func run() {
//             let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
//             let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

//             var command = ListCommand(path: profileURL)

//             let status = command.execute()
//             if status {
//                 if options.verbose {
//                     for output in command.getOutput(.verbose) {
//                         print(output + "\n")
//                     }
//                 } else {
//                     for output in command.getOutput(.simple) {
//                         print(output)
//                     }
//                 }
//             }       
//         }
//     }
// }



// Ref: https://github.com/apple/swift-argument-parser/blob/master/Documentation/03%20Commands%20and%20Subcommands.md

