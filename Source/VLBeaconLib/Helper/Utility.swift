//
//  Utility.swift
//  VLBeacon
//
//  Created by NEXGEN on 29/03/23.
//

import Foundation
import UIKit

internal class Utility {
    
    static let sharedInstance = Utility()
   
    private init() {}
    
    //MARK: Method to get uuid from sskeychain
    func getUUID() -> String {
        guard let deviceIdentifier = UIDevice.current.identifierForVendor else { return "" }
        return deviceIdentifier.uuidString
    }
    
    func getDeviceUserAgent() -> String {
        guard let bundleDict = Bundle.main.infoDictionary else {return "VLBeacon"}
        let appVersion = bundleDict["CFBundleShortVersionString"] as? String ?? "1.0"
        let appDescriptor = "VLBeacon" + "/" + appVersion
        let currentDevice = UIDevice.current
        let osDescriptor = (getPlatform() == "iOS" ? "iOS" : "tvOS") + "/" + currentDevice.systemVersion
        return appDescriptor + " " + osDescriptor + " (" + UIDevice.current.model + ")"
    }
    
    // MARK : GET Current TimeStamp
    /// This method returns Current Time Stamp.
    ///
    /// - Returns: current time stamp in string format in the Universal Time Coordinated (UTC)
    func getCurrentTimeStampInUTC() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        let currentTimeStamp = formatter.string(from: Date())
        return currentTimeStamp
    }
    ///- Returns: current time stamp in string format in the Eastern Standard Time (EST)
    func getCurrentTimestampInEST() -> String {
        let estTimeZone = TimeZone(abbreviation: "EST")!
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = estTimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let estTimestamp = dateFormatter.string(from: currentDate)
        return estTimestamp
    }
    ///- Returns: current time stamp in string format in the (GMT)
    func getCurrentTimestampInGMT() -> String {
        let estTimeZone = TimeZone(abbreviation: "GMT")!
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = estTimeZone
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let estTimestamp = dateFormatter.string(from: currentDate)
        return estTimestamp
    }
    
    func getPlatform() -> String{
        var platform : String
        #if os(iOS)
        platform = "iOS"
        #else
        platform = "Apple TV"
        #endif
        
        return platform
    }
    
    func getAppVersion() -> String {
        guard let dict = Bundle.main.infoDictionary,
              let versionString = dict["CFBundleShortVersionString"] as? String, let appBuild =  Bundle.main.infoDictionary!["CFBundleVersion"] else { return "1.0.0" }

        return "\(versionString).\(appBuild)"
    }
    
    func getBoolType(_ value: Bool) -> String {
        return value ? "yes" : "no"
    }
}


