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
        abstract: """
        An application for viewing iOS binary and provisioning profile information.
        """,
        subcommands: [List.self, Show.self])

    struct Options: ParsableArguments {
        @Flag(name: .shortAndLong, help: "Increase verbosity for informational output.")
        var verbose = false

        @Flag(name: .customLong("use-color"), help: "Apply color to output.")
        var colorize = false
    }

}

extension Revamp {
    struct List: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Show available provisioning profiles.",
            subcommands: [Profile.self])
    }
    
    struct Show: ParsableCommand {
        static var configuration = CommandConfiguration(
            abstract: "Show information about an ipa or provisioning profile.",
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
        static var configuration = CommandConfiguration(abstract: "Enumerate provisioning profiles in the default folder.")

        @Option(name: .shortAndLong, help: "The folder to enumerate. This overrides the default folder.")
        var path: String = ""

        @OptionGroup()
        var commonFlags: Revamp.Options

        mutating func run() {
            let engine = Engine.initialize()
            var flags: [String]          = []
            var options: [String:String] = [:]

            if commonFlags.verbose  { flags.append("verbose") }
            if commonFlags.colorize { flags.append("colorize") }
            if !path.isEmpty { options["path"] = path }

            let input  = CommandInput(subCommand: "profile", arguments: [], options: options, flags: flags)
            let output = engine.execute("list", input: input)

            for output in output.message {
                print(output)
            }       
        }
    }
}

extension Revamp.Show {
    struct Info: ParsableCommand {
        static var configuration = CommandConfiguration(abstract: "Show information about an ipa or provisioning profile.")

        @Option(name: [.customLong("translate-device"), .customShort("t")], 
                help: ArgumentHelp(
                    "The device UDID translation file.",
                    valueName: "path"))
        var deviceTranslationFilePath: String = ""

        @OptionGroup()
        var commonFlags: Revamp.Options

        @Argument var file: String

        mutating func validate() throws {
            if !(file.hasSuffix(".ipa") || file.hasSuffix(".mobileprovision")) {
                throw ValidationError("A file must be an ipa or a mobileprovision.")
            }
        }

        mutating func run() {
            let engine = Engine.initialize()
            var flags: [String] = []
            var options: [String:String] = [:]

            if commonFlags.verbose  { flags.append("verbose")}
            if commonFlags.colorize { flags.append("colorize") }
            if !deviceTranslationFilePath.isEmpty { options["translation-path"] = deviceTranslationFilePath }

            let input  = CommandInput(subCommand: "info", arguments: [file], options: options, flags: flags)
            let output = engine.execute("show", input: input)

            for output in output.message {
                print(output)
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

fileprivate struct Engine {
    fileprivate static func initialize() -> CommandEngine {
        let listHandler = CommandHandler(commandType: ListCommand.self)
        let showHandler = CommandHandler(commandType: ShowCommand.self)
        listHandler.next = showHandler
        return CommandEngine(handler: listHandler)
    }
}

// Ref: https://github.com/apple/swift-argument-parser/blob/master/Documentation/03%20Commands%20and%20Subcommands.md

