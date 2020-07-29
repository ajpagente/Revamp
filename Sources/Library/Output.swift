/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct OutputGroup {
    public var lines: [String]
    public var header: String?
    public var separator: Character

    /// Returns the number of characters of the longest String in the array.
    /// The character is counted from the beginning of the String until the first occurence of the separator.
    public var maxCount: Int {
        var maxCount = 0

        for line in lines {
            let firstSeparator = line.firstIndex(of: separator) ?? line.startIndex
            let fieldName = line[..<firstSeparator]
            let fieldNameCount = fieldName.count
            if  fieldNameCount > maxCount { maxCount = fieldNameCount }
        }    
        return maxCount
    }

    public init(lines: [String], header: String?, separator: Character = ":") {
        self.lines = lines
        self.header = header
        self.separator = separator
    }
}

public struct OutputFormatter {
    // A character that indicates the separation of the field from the value.
    // The first matching character from the beginning of the String is taken
    // as the separation point.
    public var separator: String = ":"

    private struct Layout {
        var maxCount: Int
        var spacesCountBeforeSeparator: Int
        var spacesCountAfterSeparator: Int 
    }

    public init(){}

    public func strings(from outputGroup: OutputGroup) -> [String] {
        if outputGroup.maxCount < 1 { return outputGroup.lines }

        let layout = Layout(maxCount: outputGroup.maxCount,
                            spacesCountBeforeSeparator: 2,
                            spacesCountAfterSeparator: 2)
        
        var lines: [String] = []
        for line in outputGroup.lines {
            let array = line.split(separator: outputGroup.separator, maxSplits: 1).map(String.init)
            lines.append(format(field: array.first!, value: array.last!, with: layout))
        }

        return lines
    }

    private func format(field: String, value: String, with layout: Layout) -> String {
        let spacesCountBeforeSeparator = layout.spacesCountBeforeSeparator + layout.maxCount - field.count
        let spacesBeforeSeparator = String(repeating: " ", count: spacesCountBeforeSeparator)
        let spacesAfterSeparator = String(repeating: " ", count: layout.spacesCountAfterSeparator)

        return field + spacesBeforeSeparator + separator + spacesAfterSeparator + value
    }
}