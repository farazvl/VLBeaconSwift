//
//  PlayerBeaconEventStruct.swift
//  VLBeacon
//
//  Created by NEXGEN on 01/04/23.
//

import Foundation

public struct PlayerBeaconEventStruct {

    var aid: String!
    var cid: String!
    var pfm: String!
    var vid: String!
    var uid: String!
    var profid: String!
    var pa: String!
    var player: String?
    var environment: String!
    var media_type: String?
    var tstampoverride: String?
    var stream_id: String?
    var dp1: String?
    var dp2: String?
    var dp3: String?
    var dp4: String?
    var dp5: String?
    var ref: String!
    var apos: String?
    var apod: String?
    var vpos: String!
    var url: String!
    var embedUrl: String?
    var ttFirstFrame: String?
    var bitrate: String?
    var connectionSpeed: String?
    var resolutionHeight: String?
    var resolutionWidth: String?
    var bufferHealth: String?
    var plid: String?
    var fcid: String?
    var seriesid: String?
    var seasonid: String?
    var seasonnumber: String?
    var tstamp: String!
    var subscription_type: String?
    var mvpdprovider: String?
    var guid: String?
    var appversion: String?
    var duration: String?
    var deviceid: String?
    var siteid: String?
    var source: String?
    var tveProvider: String?
    
    var additionalData: [String: Any]?
    
    public init(eventName: PlayerBeaconEventEnum, vid: String? = nil, profid: String? = nil, userId: String? = nil, player: String? = nil,  media_type: String? = nil, tstampoverride: String? = nil, stream_id: String? = nil, dp1: String? = nil, dp2: String? = nil, dp3: String? = nil, dp4: String? = nil, dp5: String? = nil, ref: String? = nil, apos: Int? = nil, apod: Int? = nil, vpos: Int? = nil, url: String? = nil, embedUrl: String? = nil, ttFirstFrame: Int? = nil, bitrate: Int? = nil, connectionSpeed: Int? = nil, resolutionHeight: Int? = nil, resolutionWidth: Int? = nil, bufferHealth: Int? = nil, plid: String? = nil, fcid: String? = nil, seriesid: String? = nil, seasonid: String? = nil, seasonnumber: String? = nil, subscription_type: String? = nil, mvpdprovider: String? = nil, guid: String? = nil, appversion: String? = nil, duration: String? = nil, siteId: String? = nil, environment: String? = nil, source: String?, tveProvider: String? = nil, additionalData: [String: Any]? = nil) {
        
        self.pa = eventName.getBeaconEventNameString()
        self.vid = vid ?? ""
        self.profid = profid ?? ""
        self.player = player
        self.media_type = media_type
        self.tstampoverride = tstampoverride
        self.stream_id = stream_id
        self.dp1 = dp1
        self.dp2 = dp2
        self.dp3 = dp3
        self.dp4 = dp4
        self.dp5 = dp5
        self.ref = ref ?? ""
        self.url = url ?? ""
        self.embedUrl = embedUrl
        self.plid = plid
        self.fcid = fcid
        self.seriesid = seriesid
        self.seasonid = seasonid
        self.seasonnumber = seasonnumber
        self.subscription_type = subscription_type
        self.mvpdprovider = mvpdprovider
        self.guid = guid
        self.appversion = appversion
        self.duration = duration
        
		self.aid = VLBeacon.getInstance().tokenIdentity?.siteName ?? ""
		self.cid = VLBeacon.getInstance().tokenIdentity?.siteId ?? ""
        
        if let apos {
            self.apos = String(describing: apos)
        }
        
        if let apod {
            self.apod = String(describing: apod)
        }
        
		self.vpos = String(describing: vpos ?? 0)
        
        if let ttFirstFrame {
            self.ttFirstFrame = String(describing: ttFirstFrame)
        }
        
        if let bitrate {
            self.bitrate = String(describing: bitrate)
        }
        
        if let connectionSpeed {
            self.connectionSpeed = String(describing: connectionSpeed)
        }
        
        if let resolutionHeight {
            self.resolutionHeight = String(describing: resolutionHeight)
        }
        
        if let resolutionWidth {
            self.resolutionWidth = String(describing: resolutionWidth)
        }
        
        if let bufferHealth {
            self.bufferHealth = String(describing: bufferHealth)
        }
        
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
        
        if let environment = VLBeacon.getInstance().tokenIdentity?.siteName?.getEnvironment()?.rawValue {
            self.environment = environment
        } else {
            self.environment = environment
        }
        
        if let source{
            self.source = source
        } else {
            self.source = "VLBeacon"
        }
        
        if let appversion{
            self.appversion = appversion
        } else {
            self.appversion = Utility.sharedInstance.getAppVersion()
        }
        
        
        self.pfm = Utility.sharedInstance.getPlatform()
                
        if let aid{
            self.environment = aid.getEnvironment()?.rawValue
        }
        
        self.tstamp = Utility.sharedInstance.getCurrentTimestampInGMT()
        
        self.tveProvider = tveProvider
        self.additionalData = additionalData
    }
}


extension PlayerBeaconEventStruct: BeaconEventBodyProtocol {
    
    public func triggerEvents(authToken: String) {
        if let beaconBaseURL = APIUrl.getAPIBaseUrl(){
			DispatchQueue.global(qos: .utility).async {
				DataManger().postBeaconEvents(beaconStructBody: self, authenticationToken: authToken, baseUrl: beaconBaseURL + APIUrlEndPoint.playerBeacon.rawValue)
			}
        }
    }
    
    public func addBeaconInDBQuery() -> String? {
        var queryToAddBeaconEvent: String?
        
        let customDataString: String? = self.additionalData?.jsonString()
        
        queryToAddBeaconEvent = "insert into \(BeaconDBConstants().PLAYERTABLENAME)  (aid, cid, pfm, vid, uid, profid, pa, player, environment, media_type, tstampoverride , stream_id, dp1, dp2, dp3, dp4, dp5, ref, apos, apod, vpos, url, embedUrl, ttfirstframe, bitrate, connectionspeed, resolutionheight , resolutionwidth, bufferhealth, plid, fcid, seriesid, seasonid, seasonnumber, tstamp, subscription_type, mvpdprovider, guid, appversion, duration, deviceid, siteid, source, tveprovider, additionalData ) values('\(self.aid ?? "")','\(self.cid ?? "")','\(self.pfm ?? "")','\(self.vid ?? "")','\(self.uid ?? "")','\(self.profid ?? "")','\(self.pa ?? "")','\(self.player ?? "")','\(self.environment ?? "")','\(self.media_type ?? "")','\(self.tstampoverride ?? "")','\(self.stream_id ?? "")','\(self.dp1 ?? "")','\(self.dp2 ?? "")','\(self.dp3 ?? "")','\(self.dp4 ?? "")','\(self.dp5 ?? "")','\(self.ref ?? "")','\(self.apos ?? "")','\(self.apod ?? "")','\(self.vpos ?? "")','\(self.url ?? "")','\(self.embedUrl ?? "")','\(self.ttFirstFrame ?? "")','\(self.bitrate ?? "")','\(self.connectionSpeed ?? "")','\(self.resolutionHeight ?? "")','\(self.resolutionWidth ?? "")','\(self.bufferHealth ?? "")','\(self.plid ?? "")','\(self.fcid ?? "")','\(self.seriesid ?? "")','\(self.seasonid ?? "")','\(self.seasonnumber ?? "")','\(self.tstamp ?? "")','\(self.subscription_type ?? "")','\(self.mvpdprovider ?? "")','\(self.guid ?? "")','\(self.appversion ?? "")','\(self.duration ?? "")','\(self.deviceid ?? "")','\(self.siteid ?? "")','\(self.source ?? "")','\(self.tveProvider ?? "")','\(customDataString ?? "")')"
        
        return queryToAddBeaconEvent
        
    }
}
