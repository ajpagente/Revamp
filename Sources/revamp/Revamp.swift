/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import ArgumentParser
import Foundation
import Library
import Command

struct Revamp: ParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "A utility for signing iOS apps and provides signing environment query capabilities.",
        subcommands: [List.self, Sign.self])

}

// TODO: Fix why this does not appear in help
struct Options: ParsableArguments {
    @Flag(name: .shortAndLong, help: "Show more details in the output.")
    var verbose: Bool
}


extension Revamp {
    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Print provisioning profiles or signing certificates.",
            subcommands: [Profile.self])
    }
    
    struct Sign: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Sign and analyze signatures of Mac and iOS apps.",
            subcommands: [Display.self, Verify.self])
    }
}

extension Revamp.List {
    struct Profile: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Print provisioning profiles.")

        @OptionGroup()
        var options: Options

        mutating func run() {
            let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
            let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

            var command = ListCommand(path: profileURL)

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

extension Revamp.Sign {
    struct Display: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Print app signature details.")

        @OptionGroup()
        var options: Options

        @Option(name: .shortAndLong, help: "The ipa or app")
        var file: String

        mutating func run() {
            let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
            let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

            var command = SignCommand(with: ["subcommand":"display", "file": file])

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

    struct Verify: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Verify app signature.")

        @OptionGroup()
        var options: Options

        mutating func run() {
            let userHomeURL = URL(fileURLWithPath: NSHomeDirectory())
            let profileURL  = userHomeURL.appendingPathComponent("Library/MobileDevice/Provisioning Profiles", isDirectory: true)

            var command = ListCommand(path: profileURL)

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



// Ref: https://github.com/apple/swift-argument-parser/blob/master/Documentation/03%20Commands%20and%20Subcommands.md

