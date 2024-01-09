//
//  BeaconEventProtocols.swift
//  VLBeacon
//
//  Created by NEXGEN on 01/04/23.
//

import Foundation

public protocol BeaconEventNameProtocol {
    func getBeaconEventNameString() -> String
}

public protocol StructToDictionaryProtocol {
    func toDictionary() -> Dictionary<String, Any>
}

extension StructToDictionaryProtocol {

    //returns a Dictionary of Struct
    public func toDictionary() -> Dictionary<String, Any> {
        let mirror = Mirror(reflecting: self)
        var dict = [String: Any]()
        for case let (label?, value) in mirror.children {
            if let value = value as? String, !value.isEmpty {
                if value != "nil" {
                    dict[label.lowercased()] = value
                }
            }
//            if label == additionalData, let value = value as? [String: Any] {
//                dict.merge(value) { (current, _) in current }
//            }
//			if let value = value as? [String: String] {
//				dict[label] = value
//			}
//            else
			if let value = value as? [String: Any] {
                dict[label.lowercased()] = value
            }
            else if let value = value as? [String] {
                dict[label.lowercased()] = value
            }
            else if let value = value as? [StructToDictionaryProtocol] {
                dict[label.lowercased()] = value.map { $0.toDictionary() }
            }
        }
        return dict
    }
}

public protocol BeaconDBQueryProtocol {
    func addBeaconInDBQuery() -> String?
}

public protocol BeaconEventPayloadProtocol: StructToDictionaryProtocol {}


public protocol BeaconEventBodyProtocol: StructToDictionaryProtocol, BeaconDBQueryProtocol {
    func triggerEvents(authToken: String)
}
