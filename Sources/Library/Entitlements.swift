/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*/

import Foundation

public struct Entitlements {
    public var applicationIdentifier: String = ""
    public var teamIdentifier: String  = ""
    public var apsEnvironment: String  = ""
    public var debuggable: Bool  = false
    public var pushEnabled: Bool {
        if apsEnvironment != "" { return true } 
        else { return false }
    }

    public init(_ entitlements: [String: PropertyListDictionaryValue]) {
        applicationIdentifier = stringify(entitlements["application-identifier"]!)
        teamIdentifier = stringify(entitlements["com.apple.developer.team-identifier"]!)
        apsEnvironment = stringify(entitlements["aps-environment"] ?? .string(""))

        if entitlements["get-task-allow"] == .bool(true) { debuggable = true }
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