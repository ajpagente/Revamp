/**
*  Revamp
*  Copyright (c) Alvin John Pagente 2020
*  MIT license, see LICENSE file for details
*
*  The code is based on https://github.com/Sherlouk/SwiftProvisioningProfile
*/

import Foundation


public struct Certificate: Encodable, Equatable {
  public enum InitError: Error, Equatable {
    case failedToFindValue(key: String)
    case failedToCastValue(expected: String, actual: String)
    case failedToFindLabel(label: String)
  }
  
  public let notValidBefore: Date
  public let notValidAfter:  Date
  
  public let issuerCommonName:  String
  public let issuerCountryName: String
  public let issuerOrgName:     String
  public let issuerOrgUnit:     String

  public let serialNumber:      String
  public let fingerprints:      [String:String]
  
  public let commonName:  String?
  public let countryName: String
  public let orgName:     String?
  public let orgUnit:     String
  
  public init(results: [CFString: Any], commonName: String?) throws {
    self.commonName = commonName

    notValidBefore = try Certificate.getValue(for: kSecOIDX509V1ValidityNotBefore, from: results)
    notValidAfter = try Certificate.getValue(for: kSecOIDX509V1ValidityNotAfter, from: results)
    
    let issuerName: [[CFString: Any]] = try Certificate.getValue(for: kSecOIDX509V1IssuerName, from: results)
    issuerCommonName = try Certificate.getValue(for: kSecOIDCommonName, fromDict: issuerName)
    issuerCountryName = try Certificate.getValue(for: kSecOIDCountryName, fromDict: issuerName)
    issuerOrgName = try Certificate.getValue(for: kSecOIDOrganizationName, fromDict: issuerName)
    issuerOrgUnit = try Certificate.getValue(for: kSecOIDOrganizationalUnitName, fromDict: issuerName)

    serialNumber = try Certificate.getValue(for: kSecOIDX509V1SerialNumber, from: results)

    let shaFingerprints: [[CFString: Any]] = try Certificate.getValue(for: "Fingerprints" as CFString, from: results)
    let sha1Fingerprint: Data   = try Certificate.getValue(for: "SHA-1" as CFString, fromDict: shaFingerprints)
    let sha256Fingerprint: Data = try Certificate.getValue(for: "SHA-256" as CFString, fromDict: shaFingerprints)
    
    let sha1   = sha1Fingerprint.map { String(format: "%02x", $0) }.joined()
    let sha256 = sha256Fingerprint.map { String(format: "%02x", $0) }.joined()

    self.fingerprints = ["SHA-1":   sha1.uppercased(), 
                         "SHA-256": sha256.uppercased()]

    let subjectName: [[CFString: Any]] = try Certificate.getValue(for: kSecOIDX509V1SubjectName, from: results)
    countryName = try Certificate.getValue(for: kSecOIDCountryName, fromDict: subjectName)
    orgName = try? Certificate.getValue(for: kSecOIDOrganizationName, fromDict: subjectName)
    orgUnit = try Certificate.getValue(for: kSecOIDOrganizationalUnitName, fromDict: subjectName)
  }

  static func getValue<T>(for key: CFString, from values: [CFString: Any]) throws -> T {
    let node = values[key] as? [CFString: Any]

    guard let rawValue = node?[kSecPropertyKeyValue] else {
        throw InitError.failedToFindValue(key: key as String)
    }
    
    if T.self is Date.Type {
        if let value = rawValue as? TimeInterval {
            // Force unwrap here is fine as we've validated the type above
            return Date(timeIntervalSinceReferenceDate: value) as! T
        }
    }
    
    guard let value = rawValue as? T else {
        let type = (node?[kSecPropertyKeyType] as? String) ?? String(describing: rawValue)
        throw InitError.failedToCastValue(expected: String(describing: T.self), actual: type)
    }
    
    return value
  }
  
  static func getValue<T>(for key: CFString, fromDict values: [[CFString: Any]]) throws -> T {  
    guard let results = values.first(where: { ($0[kSecPropertyKeyLabel] as? String) == (key as String) }) else {
        throw InitError.failedToFindLabel(label: key as String)
    }
    
    guard let rawValue = results[kSecPropertyKeyValue] else {
        throw InitError.failedToFindValue(key: key as String)
    }
    
    guard let value = rawValue as? T else {
        let type = (results[kSecPropertyKeyType] as? String) ?? String(describing: rawValue)
        throw InitError.failedToCastValue(expected: String(describing: T.self), actual: type)
    }
    
    return value
  }  
}

// MARK: - Certificate Encoder/Decoder
public struct BaseCertificate: Codable, Equatable {
  public let data: Data
  public let certificate: Certificate?
  
  // MARK: - Codable
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    data = try container.decode(Data.self)
    certificate = try? Certificate.parse(from: data)
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(data)
  }
  
  // MARK: - Convenience
  public var base64Encoded: String {
    return data.base64EncodedString()
  }
}

