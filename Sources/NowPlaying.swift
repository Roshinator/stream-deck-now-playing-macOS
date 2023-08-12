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
    
    static var category: String? = "Utilities"
    
    static var categoryIcon: String? = nil
    
    static var author: String = "Roshinator"
    
    static var icon: String = ""
    
    static var url: URL? = nil
    
    static var version: String = "0.0.1"
    
    static var os: [StreamDeck.PluginOS] = [.mac(minimumVersion: "10.15")]
    
    static var actions: [any StreamDeck.Action.Type] = [
        NowPlayingAction.self
    ]
    
    required init() {
        
    }
}

class NowPlayingAction : Action
{
    typealias Settings = NoSettings
    
    static var name: String = "Now Playing"
    
    static var uuid: String = "nowplaying.current"
    
    static var icon: String = ""
    
    static var states: [StreamDeck.PluginActionState]? = []
    
    static var controllers: [StreamDeck.ControllerType] = []
    
    static var encoder: StreamDeck.RotaryEncoder? = nil
    
    var context: String = ""
    
    var coordinates: StreamDeck.Coordinates? = nil;
    
    private var infoCenter: MPNowPlayingInfoCenter
    
    private var observation: NSKeyValueObservation?
    
    required init(context: String, coordinates: StreamDeck.Coordinates?)
    {
        self.context = context
        self.coordinates = coordinates
        self.infoCenter = MPNowPlayingInfoCenter.default()
        self.observation = infoCenter.observe(\.nowPlayingInfo, options: [.new], changeHandler: changedHandler)
    }
    
    @Sendable
    func changedHandler(infoCenter: MPNowPlayingInfoCenter, change: NSKeyValueObservedChange<[String: Any]?>)
    {
        var image: NSImage? = nil;
        while true
        {
            var newInfo: [String: Any];
            if change.newValue == nil || change.newValue! == nil
            {
                break;
            }
            newInfo = change.newValue!!
            let maybeArtAny = newInfo[MPMediaItemPropertyArtwork]
            if maybeArtAny == nil
            {
                break;
            }
            let artwork = maybeArtAny! as! MPMediaItemArtwork;
            let maybeImage = artwork.image(at: CGSize(width: 144, height: 144))
            if maybeImage == nil
            {
                break;
            }
            image = maybeImage!
        }
        self.setImage(to: image)
    }
    
    //MPMediaItemPropertyArtwork
}
