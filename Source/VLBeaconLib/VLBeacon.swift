// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class VLBeacon {
    
    public static let sharedInstance: VLBeacon = {
        let instance = VLBeacon()
        instance.setupConfiguration()
        return instance
    }()
    
    private init() {}
    
    private let bundleIdentifier = "com.viewlift.beacon"
    
    internal var tokenIdentity: TokenIdentity?
    
    internal var beaconBaseUrl : String?
    
    public var tveProvider: String?
    
    public var authorizationToken : String? {
        didSet {
            guard let authorizationToken else { return }
            self.tokenIdentity = JWTTokenParser().jwtTokenParser(jwtToken: authorizationToken)
        }
    }
    
    public var debugLogs: Bool? = false {
        didSet{
            guard let debugLogs else { return }
            Log.shared.isLoggingEnabled = debugLogs
            if debugLogs{
                Log.shared.d("VLBeacon debug logs enabled!")
                Log.shared.d("Beacon events pointing to \(String(describing: beaconBaseUrl))")
            }
            
        }
    }
    
    public func startSyncBeaconEvents() {
        
        let sharedSyncManager = BeaconSyncManager.sharedInstance
        
        if NetworkStatus.sharedInstance.isNetworkAvailable() {
            if let authToken = VLBeacon.sharedInstance.authorizationToken {
                sharedSyncManager.startSyncingTheEvents(authenticationToken: authToken, withSuccess: {(_ success: Bool) -> Void in
                })
            }
        }
    }
    
    public func triggerBeaconEvent(_ eventStructBody: BeaconEventBodyProtocol) {
        if var event = eventStructBody as? PlayerBeaconEventStruct {
            event.tveProvider = tveProvider
            event.triggerEvents()
        } else {
            eventStructBody.triggerEvents()
        }
    }
    
}

extension VLBeacon{
    
    func getBeaconBaseUrl() -> String? {
        guard let bundlePath = Bundle.main.path(forResource: "SiteConfig", ofType: "plist"),
              let dict = NSDictionary.init(contentsOfFile: bundlePath),
              let apiEndpoint = dict["BeaconApiUrl"] as? String else { return self.getBeaconBaseUrlFromConfiguration() }
        return apiEndpoint
    }
    
    private func getDebugLogger() -> Bool? {
        guard let bundlePath = Bundle.main.path(forResource: "SiteConfig", ofType: "plist"),
              let dict = NSDictionary.init(contentsOfFile: bundlePath),
              let loggerValue = dict["VLBeaconDebugLogger"] as? Bool else {return false}
        return loggerValue
    }
    
    private func getBeaconBaseUrlFromConfiguration() -> String? {
        
        var filePath : String?
        let classBundle = Bundle(for: type(of: self))
        if let classBundlePath = classBundle.path(forResource: "VLBeacon", ofType: "bundle"), let bundle = Bundle(path: classBundlePath) {
            filePath = bundle.path(forResource: "Configuration", ofType: "plist")
        }
        if filePath == nil {
            guard let bundle = Bundle(identifier: bundleIdentifier) else {
                return nil
            }
            filePath = bundle.path(forResource: "Configuration", ofType: "plist")
        }
        
        guard let filePath else { return nil }
        if let configData = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let configuration = try? PropertyListDecoder().decode(VLConfiguration.self, from: configData),
           let apiUrl = configuration.beaconApiUrl {
            return apiUrl
        }
        return nil
    }
    
    private func setupConfiguration() {
        beaconBaseUrl = getBeaconBaseUrl()
        debugLogs = getDebugLogger()
    }
    
}
