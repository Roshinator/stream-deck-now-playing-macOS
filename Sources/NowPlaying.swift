// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import StreamDeck
import MediaPlayer
import AppKit

@main
class NowPlayingPlugin: PluginDelegate
{
    typealias Settings = NoSettings
    
    static var name: String  = "Now Playing"
    
    static var description: String = "This plugin displays the album art of the currently playing media."
    
    static var category: String? = nil
    
    static var categoryIcon: String? = nil
    
    static var author: String = "Roshinator"
    
    static var icon: String = "Icons/pluginIcon"
    
    static var url: URL? = nil
    
    static var version: String = "0.1"
    
    static var os: [StreamDeck.PluginOS] = [.mac(minimumVersion: "10.15")]
    
    static var actions: [any StreamDeck.Action.Type] = [
        NowPlayingAction.self
    ]
    
    required init() {
        
    }
}

class NowPlayingAction : KeyAction
{
    typealias Settings = NoSettings
    
    static var name: String = "Now Playing"
    
    static var uuid: String = "nowplaying.current"
    
    static var icon: String = "Icons/actionIcon"
    
    static var states: [StreamDeck.PluginActionState]? = nil
    
    var context: String
    
    var coordinates: StreamDeck.Coordinates?;
    
    private var bundle: CFBundle
        
    private var observation: NSKeyValueObservation?
    
    private var pressed: Bool = false
    
    typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
    private var MRMediaRemoteGetNowPlayingInfo: MRMediaRemoteGetNowPlayingInfoFunction
    
    required init(context: String, coordinates: StreamDeck.Coordinates?)
    {
        self.context = context
        self.coordinates = coordinates
        
        self.bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
        
        // Get a Swift function for MRMediaRemoteGetNowPlayingInfo
        guard let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString) else { abort() }
        self.MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)

        //Subscribe to notifications
//        guard let kMRMediaRemoteNowPlayingInfoDidChangeNotificationPointer = CFBundleGet(bundle, "kMRMediaRemoteNowPlayingInfoDidChangeNotification" as CFString) else {abort()}
//        let kMRMediaRemoteNowPlayingInfoDidChangeNotification = unsafeBitCast(kMRMediaRemoteNowPlayingInfoDidChangeNotificationPointer, to: CFString.self)
        
        let kMRMediaRemoteNowPlayingInfoDidChangeNotification = "kMRMediaRemoteNowPlayingInfoDidChangeNotification" as CFString
        
        guard let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString) else {abort()}
        typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
        let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)
        
        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main);

        NotificationCenter.default.addObserver(self, selector: #selector(infoDidChange), name: kMRMediaRemoteNowPlayingInfoDidChangeNotification as NSNotification.Name, object: nil)
        
        getArt();
    }
    
    @objc func infoDidChange(notification: NSNotification)
    {
        getArt();
    }
    
    func getArt()
    {
        // Get song info
        MRMediaRemoteGetNowPlayingInfo(DispatchQueue.main, { (information) in
            var artwork: NSImage?;
            artwork = NSImage(data: information["kMRMediaRemoteNowPlayingInfoArtworkData"] as! Data) ?? nil
            self.setImage(to: artwork)
        })
    }
    
    func keyDown(device: String, payload: KeyEvent<NoSettings>)
    {
        pressed = !pressed
        setTitle(to: "\(pressed)")
    }
}
