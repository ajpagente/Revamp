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
    @Argument() var arguments: [String]

    @Option(name: [.short, .customLong("target")], help: "The item to list. Accepts: profile, certificate") 
    var target: String

    @Flag(name: .shortAndLong)
    var verbose: Bool

    mutating func run() throws {
        
        let commandString = arguments[0]

        let command = CommandDispatcher.handleCommand(commandString, with: ["target": target, "verbose": String(verbose)])
    }
}

Revamp.main()
