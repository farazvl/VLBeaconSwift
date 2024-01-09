//
//  APIUrlEndPoint.swift
//  VLBeacon
//
//  Created by NEXGEN on 07/06/23.
//

import Foundation

enum APIUrl {
    static func getAPIBaseUrl() -> String? {
        return VLBeacon.getInstance().beaconBaseUrl
    }
}

enum APIUrlEndPoint: String {
    case playerBeacon = "/player-beacon"
    case userBeacon = "/user-beacon"
}
