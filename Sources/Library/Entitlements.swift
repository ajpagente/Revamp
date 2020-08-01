/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct Entitlements {
    public var debuggable = false
    public var applicationIdentifier = ""
    public var teamIdentifier = ""
    public var apsEnvironment = ""
    public var pushEnabled = false

    public init(_ entitlements: [String: PropertyListDictionaryValue]) {
        if entitlements["get-task-allow"] == .bool(true) { debuggable = true }
        applicationIdentifier = stringify(entitlements["application-identifier"]!)
        teamIdentifier = stringify(entitlements["com.apple.developer.team-identifier"]!)

        apsEnvironment = stringify(entitlements["aps-environment"] ?? .string(""))
        if apsEnvironment != "" { pushEnabled = true }
    }

    private func stringify(_ aString: PropertyListDictionaryValue) -> String {
        var stringValue = ""
        switch aString {
            case .string(let value):
                stringValue = value
            default:
                stringValue = ""
        }
        return stringValue
    }
}

/* NOTES from https://developer.apple.com/documentation/bundleresources/entitlements
 * 
 * key: aps-environment
 * type: String
 * description:
 * This key specifies whether to use the development or production Apple Push Notification service (APNs) environment 
 * when registering for push notifications. 
 */