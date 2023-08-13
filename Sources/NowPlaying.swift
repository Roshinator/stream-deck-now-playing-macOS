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
    
    static var url: URL? = URL(string: "https://github.com/Roshinator/stream-deck-now-playing-macOS")
    
    static var version: String = "0.1"
    
    static var os: [StreamDeck.PluginOS] = [.mac(minimumVersion: "10.15")]
    
    static var actions: [any StreamDeck.Action.Type] = [
        NowPlayingAction.self
    ]
    
    required init() {
        
    }
}

class NowPlayingAction : StatelessKeyAction
{
    typealias Settings = NoSettings
    
    static var name: String = "Now Playing"
    
    static var uuid: String = "nowplaying.current"
    
    static var icon: String = "Icons/actionIcon"
    
    var context: String
    
    var coordinates: StreamDeck.Coordinates?;
    
    
    //Non Action Items
    private var bundle: CFBundle
        
    private var observation: NSKeyValueObservation?
    
    private var pressed: Bool = false
    
    typealias MRMediaRemoteGetNowPlayingInfoFunction = @convention(c) (DispatchQueue, @escaping ([String: Any]) -> Void) -> Void
    private var MRMediaRemoteGetNowPlayingInfo: MRMediaRemoteGetNowPlayingInfoFunction
    
    
    
    private static let kMRMediaRemoteNowPlayingInfoArtworkData = "kMRMediaRemoteNowPlayingInfoArtworkData"
    private static let kMRMediaRemoteNowPlayingInfoArtist = "kMRMediaRemoteNowPlayingInfoArtist"
    private static let kMRMediaRemoteNowPlayingInfoAlbum = "kMRMediaRemoteNowPlayingInfoAlbum"
    private static let kMRMediaRemoteNowPlayingInfoTitle = "kMRMediaRemoteNowPlayingInfoTitle"
    
    required init(context: String, coordinates: StreamDeck.Coordinates?)
    {
        self.context = context
        self.coordinates = coordinates
        
        self.bundle = CFBundleCreate(kCFAllocatorDefault, NSURL(fileURLWithPath: "/System/Library/PrivateFrameworks/MediaRemote.framework"))
        
        // Get a Swift function for MRMediaRemoteGetNowPlayingInfo
        guard let MRMediaRemoteGetNowPlayingInfoPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteGetNowPlayingInfo" as CFString) else { abort() }
        self.MRMediaRemoteGetNowPlayingInfo = unsafeBitCast(MRMediaRemoteGetNowPlayingInfoPointer, to: MRMediaRemoteGetNowPlayingInfoFunction.self)
        
        let kMRMediaRemoteNowPlayingInfoDidChangeNotification = Notification.Name("kMRMediaRemoteNowPlayingInfoDidChangeNotification")
        
        guard let MRMediaRemoteRegisterForNowPlayingNotificationsPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteRegisterForNowPlayingNotifications" as CFString) else {abort()}
        typealias MRMediaRemoteRegisterForNowPlayingNotificationsFunction = @convention(c) (DispatchQueue) -> Void
        let MRMediaRemoteRegisterForNowPlayingNotifications = unsafeBitCast(MRMediaRemoteRegisterForNowPlayingNotificationsPointer, to: MRMediaRemoteRegisterForNowPlayingNotificationsFunction.self)
        
        MRMediaRemoteRegisterForNowPlayingNotifications(DispatchQueue.main);

        NotificationCenter.default.addObserver(self, selector: #selector(infoDidChange), name: kMRMediaRemoteNowPlayingInfoDidChangeNotification, object: nil)
        
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
            let data: Data? = self.getItemFromNowPlayingInfo(info: information, key: Self.kMRMediaRemoteNowPlayingInfoArtworkData)
            var artwork: NSImage?
            if let d = data
            {
                artwork = NSImage(data: d) ?? nil
            }
            if artwork == nil
            {
                //Create placeholder image
            }
            self.setImage(to: artwork)
        })
    }
    
    func keyDown(device: String, payload: KeyEvent<NoSettings>)
    {
        
    }
    
    func getItemFromNowPlayingInfo<T>(info: [String: Any?], key: String) -> T?
    {
        let check = info[key]
        if check == nil
        {
            return nil
        }
        return check as? T
    }
}
