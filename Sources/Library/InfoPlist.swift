/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct InfoPlist: Codable {
    private enum CodingKeys: String, CodingKey {
        case bundleName       = "CFBundleDisplayName"
        case bundleVersionShort = "CFBundleShortVersionString"
        case bundleVersion    = "CFBundleVersion"
        case bundleIdentifier = "CFBundleIdentifier"
        case minOSVersion     = "MinimumOSVersion"
        case buildType        = "method"
    }

    public var bundleName:         String
    public var bundleVersionShort: String
    public var bundleVersion:      String
    public var bundleIdentifier:   String
    public var minOSVersion:       String
    public var buildType:          String

    // public init(from decoder: Decoder) throws {
    //     let values = try decoder.container(keyedBy: CodingKeys.self)
    //     print(">>HERE")
    //     bundleIdentifier = try values.decode(String.self, forKey: .bundleIdentifier)
    //     minOSVersion     = try values.decode(String.self, forKey: .minOSVersion)
    //     buildType        = try values.decode(String.self, forKey: .buildType)
    // }

    // public func encode(to encoder: Encoder) throws {
    //     var values = encoder.container(keyedBy: CodingKeys.self)
        
    //     try values.encode(bundleIdentifier, forKey: .bundleIdentifier)
    //     try values.encode(minOSVersion, forKey: .minOSVersion)
    //     try values.encode(buildType, forKey: .buildType)
    // }
}

public extension InfoPlist {
    static func parse(from file: File) throws -> InfoPlist {
        let data = try! Data(contentsOf: file.url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(InfoPlist.self, from: data)
    }
}