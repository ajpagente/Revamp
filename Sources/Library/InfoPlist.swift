/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation
import Files

public struct InfoPlist: Codable {
    private enum CodingKeys: String, CodingKey {
        case bundleName         = "CFBundleDisplayName"
        case bundleVersionShort = "CFBundleShortVersionString"
        case bundleVersion      = "CFBundleVersion"
        case bundleIdentifier   = "CFBundleIdentifier"
        case minOSVersion       = "MinimumOSVersion"
        case buildType          = "method"

        case platformVersion    = "DTPlatformVersion"
        case sdkName            = "DTSDKName"

        case supportedPlatforms = "CFBundleSupportedPlatforms"
    }

    public var bundleName:         String
    public var bundleVersionShort: String
    public var bundleVersion:      String
    public var bundleIdentifier:   String
    public var minOSVersion:       String

    public var platformVersion:    String
    public var sdkName:            String
    
    public var supportedPlatforms: [String]

    @DecodableDefault.EmptyString  var buildType: String

    public func getBuildType() -> String {
        return buildType
    }
}

public extension InfoPlist {
    static func parse(from file: File) throws -> InfoPlist {
        let data = try! Data(contentsOf: file.url)
        let decoder = PropertyListDecoder()
        return try! decoder.decode(InfoPlist.self, from: data)
    }
}



