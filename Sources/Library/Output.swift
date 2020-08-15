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
    public var overrideMaxCount: Int
    
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
        if maxCount < overrideMaxCount { maxCount = overrideMaxCount }
        return maxCount
    }

    public init(lines: [String], header: String?, separator: Character = ":", overrideMaxCount: Int = 0) {
        self.lines = lines
        self.header = header
        self.separator = separator
        self.overrideMaxCount = overrideMaxCount
    }
}

public struct OutputGroups {
    public var groups: [OutputGroup]

    public init(_ groups: [OutputGroup]) {
        self.groups = groups
        setOverallMaxCount()
    }

    /// Returns the highest maxCount among the groups
    private func getOverallMaxCount() -> Int {
        var maxCount = 0
        for group in groups {
            if group.maxCount > maxCount { maxCount = group.maxCount }
        }
        return maxCount
    }

    // Overrides the maxCount in the groups with the overall maxCount
    private mutating func setOverallMaxCount() {
        let maxCount = getOverallMaxCount()
        var newGroups: [OutputGroup] = []
        for var group in groups {
            group.overrideMaxCount = maxCount
            newGroups.append(group)
        }
        groups = newGroups
    }
}

public struct OutputFormatter {
    // A character that indicates the separation of the field from the value.
    // The first matching character from the beginning of the String is taken
    // as the separation point.
    public var separator: String = ":"

    private struct Layout {
        var maxCount: Int
        var spacesCountAtBeginning: Int = 0
        var spacesCountBeforeSeparator: Int
        var spacesCountAfterSeparator: Int 
    }

    public init(){}

    public func string(from outputGroup: OutputGroup) -> String {

        return strings(from: outputGroup).joined(separator: "\n")
    }
   
    public func strings(from outputGroup: OutputGroup) -> [String] {
        if outputGroup.maxCount < 1 { return outputGroup.lines }
        var lines: [String] = []
        var spacesCountAtBeginning = 0
        if let header = outputGroup.header {
            lines.append(format(header: header))
            spacesCountAtBeginning = 3
        }

        let layout = Layout(maxCount: outputGroup.maxCount,
                            spacesCountAtBeginning: spacesCountAtBeginning,
                            spacesCountBeforeSeparator: 2,
                            spacesCountAfterSeparator: 2)
        
        
        for line in outputGroup.lines {
            let array = line.split(separator: outputGroup.separator, maxSplits: 1).map(String.init)
            lines.append(format(field: array.first!, value: array.last!, with: layout))
        }

        return lines
    }

    private func format(header: String) -> String {
        return header.uppercased()
    }

    private func format(field: String, value: String, with layout: Layout) -> String {
        let spacesCountBeforeSeparator = layout.spacesCountBeforeSeparator + layout.maxCount - field.count
        let spacesBeforeSeparator = String(repeating: " ", count: spacesCountBeforeSeparator)
        let spacesAfterSeparator = String(repeating: " ", count: layout.spacesCountAfterSeparator)

        var spacesAtBeginning = ""
        if layout.spacesCountAtBeginning > 0 { 
            spacesAtBeginning = String(repeating: " ", count: layout.spacesCountAtBeginning)
        }
        return spacesAtBeginning + field + spacesBeforeSeparator + separator + spacesAfterSeparator + value
    }
}