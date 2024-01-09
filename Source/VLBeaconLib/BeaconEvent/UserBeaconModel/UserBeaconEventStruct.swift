//
//  UserBeaconStruct.swift
//  VLBeacon
//
//  Created by NEXGEN on 30/03/23.
//

import Foundation

public struct UserBeaconEventStruct {
    
    var ename: String
    var uid: String!
    var profid: String!
    var siteid: String!
    var pfm: String!
    var etstamp: String!
    var environment: String!
    var deviceid: String?
    var ref: String!
    var url: String!
    var appversion: String!
    var source: String?
    var eventData: [String: Any]?
    var additionalData: [String: Any]?
    
    public init(eventName: UserBeaconEventEnum, userId: String? = nil, profileId: String? = nil, siteId: String? = nil, pfm: String? = nil, etstamp: String? = nil, environment: String? = nil, appversion: String? = nil, source: String?, eventData: BeaconEventPayloadProtocol? = nil, additionalData: [String : Any]? = nil) {
        
        self.ename = eventName.getBeaconEventNameString()
        self.profid = profileId ?? ""
        
        if let userID = VLBeacon.getInstance().tokenIdentity?.userId {
            self.uid = userID
        } else {
            self.uid = userId
        }
        
        if let deviceID = VLBeacon.getInstance().tokenIdentity?.deviceId {
            self.deviceid = deviceID
        } else {
            self.deviceid = Utility.sharedInstance.getUUID()
        }
        
        if let siteID = VLBeacon.getInstance().tokenIdentity?.siteId {
            self.siteid = siteID
        } else {
            self.siteid = siteId
        }
        
        self.environment = VLBeacon.getInstance().tokenIdentity?.siteName?.getEnvironment()?.rawValue
        
        if let source{
            self.source = source
        } else {
            self.source = "VLBeacon"
        }
        
        self.pfm = Utility.sharedInstance.getPlatform()
        
        self.appversion = Utility.sharedInstance.getAppVersion()
        
        self.etstamp = Utility.sharedInstance.getCurrentTimestampInGMT()
        
        self.eventData = eventData?.toDictionary()
        
        self.additionalData = additionalData
        
    }
}

extension UserBeaconEventStruct: BeaconEventBodyProtocol {
    
    public func triggerEvents(authToken: String) {
        
        if let beaconBaseURL = APIUrl.getAPIBaseUrl() {
//        print(">>>>> triggerBeacon: UserBeaconEventStruct: \(beaconBaseURL + APIUrlEndPoint.userBeacon.rawValue) -> \(self.toDictionary())")
			DispatchQueue.global(qos: .utility).async {
				DataManger().postBeaconEvents(beaconStructBody: self, authenticationToken: authToken, baseUrl: beaconBaseURL + APIUrlEndPoint.userBeacon.rawValue)
			}
        }
    }
    
    public func addBeaconInDBQuery() -> String? {
        var queryToAddBeaconEvent: String?
        
        let additionalDataString: String? = additionalData?.jsonString()
        
        let eventDataString: String? = eventData?.jsonString()
        
        queryToAddBeaconEvent = "insert into \(BeaconDBConstants().USERTABLENAME) (ename, uid, profid, siteid, pfm, etstamp, environment, deviceid, ref, url, appversion, source, eventData, additionalData) values('\(self.ename )','\(self.uid ?? "")','\(profid ?? "")','\(self.siteid ?? "")','\(self.pfm ?? "")','\(self.etstamp ?? "")','\(self.environment ?? "")','\(self.deviceid ?? "")','\(self.ref ?? "")','\(self.url ?? "")','\(self.appversion ?? "")','\(self.source ?? "")','\(eventDataString ?? "")','\(additionalDataString ?? "")')"
        
        return queryToAddBeaconEvent
    }
}
