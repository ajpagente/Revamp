import ArgumentParser

struct Revamp: ParsableCommand {
    @Argument() var files: [String]

    mutating func run() throws {
        print("Hello")
    }
}

Revamp.main()
