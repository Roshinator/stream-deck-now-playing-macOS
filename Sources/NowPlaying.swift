// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import StreamDeck
import MediaPlayer
import AppKit

struct Constants
{
    static let DEFAULT_IMG = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAASAAAAEgCAYAAAAUg66AAAAOy0lEQVR4Xu3dzcvU5R7H8SstzOyBkhKElkklJNG2gtoZuIsQF1mrIuhRI1RCweiB8A5a9GBtDCHqHwj3/QMGbdrWqoVRIUFF55xrzrmrk97OwzXz+/zmN6+BaHFm5ju95jvvfnN5n7urSin/+s9fbgQIEOhc4CoB6tzcQAIE/icgQFaBAIGYgADF6A0mQECA7AABAjEBAYrRG0yAgADZAQIEYgICFKM3mAABAbIDBAjEBAQoRm8wAQICZAcIEIgJCFCM3mACBATIDhAgEBMQoBi9wQQICJAdIEAgJiBAMXqDCRAQIDtAgEBMQIBi9AYTICBAdoAAgZiAAMXoDSZAQIDsAAECMQEBitEbTICAANkBAgRiAgIUozeYAAEBsgMECMQEBChGbzABAgJkBwgQiAkIUIzeYAIEBMgOECAQExCgGL3BBAgIkB0gQCAmIEAxeoMJEBAgO0CAQExAgGL0BhMgIEB2gACBmIAAxegNJkBAgOwAAQIxAQGK0RtMgIAA2QECBGICAhSjN5gAAQGyAwQIxAQEKEZvMAECAmQHCBCICQhQjN5gAgQEyA4QIBATEKAYvcEECAiQHSBAICYgQDF6gwkQECA7QIBATECAYvQGEyAgQHaAAIGYgADF6A0mQECA7AABAjEBAYrRG0yAgADZAQIEYgICFKM3mAABAbIDBAjEBAQoRm8wAQICZAcIEIgJCFCM3mACBATIDhAgEBMQoBi9wQQICJAdIEAgJiBAMXqDCRAQIDtAgEBMQIBi9AYTICBAdoAAgZiAAMXoDSZAQIDsAAECMQEBitEbTICAANkBAgRiAgIUozeYAAEBsgMECMQEBChGbzABAgJkBwgQiAkIUIzeYAIEBMgOECAQExCgGL3BBAgIkB0gQCAmIEAxeoMJEBAgO0CAQExAgGL0BhMgIEB2gACBmIAAxegNJkBAgOwAAQIxAQGK0RtMgIAA2QECBGICAhSjN5gAAQGyAwQIxAQEKEZvMAECAmQHCBCICQhQjN5gAgQEyA4QIBATEKAYvcEECAiQHSBAICYgQDF6gwkQECA7QIBATECAYvQGEyAgQHaAAIGYgADF6A0mQECAFrQDu3fvLi+++GLZsmVLefPNN8vXX3+9oEmelsDyCgjQnN+76667rrz00kvlmWeeKVu3bh09+6+//lo++uij8vbbb5cff/xxzhM93eUEtm3bVl5//fXy/PPPNwGdPn26vPzyy963JsWNHyxAc4Kt4Tlw4EA5fPhw2bFjx2Wf9fvvvy9ra2vl7Nmz5eLFi3Oa7Gn+KbB3797y1ltvldtvv73cfPPNTUA//PBD+fbbb8srr7xSvvjii6bn8uBLBQRoDlvx8MMPl+PHj5d77rlnomerX8dOnjxZzp07N9H93WkygVtuuaUcOXKkHDx4sFxzzTWjB80jQPV5fvvtt3LmzJnyxhtvlAsXLkz2gtxrrIAAjSXa+A533nlnOXbsWHnkkUfKpk2bpn6mGqAaIudDU9Nd8oD777+/nDp1quzatev//rd5BWj9Sb/55pty6NCh8uWXX7a/aM9QBGiGJdi+ffvobOGJJ54oN9xwwwzP8NdD6lex+pWsfjWrX9HcphOo/vWw/+mnn/7zzO3vzzDvANXn/uWXX8oHH3xQ3nnnnfLzzz9P94Ld+/8EBGiKhbj22mvL/v37R4eSO3funOKR4+/qfGi80T/vUb/yvvvuu2XPnj0bPngRAVofdv78+fLcc8+Vr776avoX7xEjAQGacBEefPDBcuLEiXLvvfdO+IjZ7uZ8aLxb/dPFesVTr3zGXYEuMkD1ldYroHolVK+I6pWR23QCAjTG64477ihHjx4t+/btK5s3b55Ot+Hezocuj1fPeOpZTz3zmeS26ACtv4Z6JlTPhuoZkdvkAgI0xuq7774r9WdKErf680Pvv/9+ee+991b+fOjqq68ujz766OiHOm+66aaJ346uAlRfUD3Pq39c/9lnn5Xff/994te4yncUoDHvfv05kPRt1c+H6s/z1J/rqT/fM+2tywCtv7b680I1RPXnh9yuLCBASxCg9Ze4iudDjz322OhHFW677baZPsuJANUXWv+l8eqrr5bPP/98pte9Kg8SoCUK0PpLXaXzodYr0FSA1t+r1vlDD5EALWGA1s8bVuHnhwRo2AkSoCUN0PrLHvr5kAAJ0LAFljxAQz8fEqBhf/xcAQ0kQEM9HxIgARq2wMACNLTzIQEa9sfPFdAAAzSk8yEBEqBhCww4QEM4HxKgYX/8XAGtQICW+XxIgARo2AIrFKBlPB8SoGF//FwBrViAlu18SIAEaNgCKxqgZTkfEqBhf/xcAa14gPp+PiRAAjRsAQH6U6CPv59agIb98XMFJECXCPTp/18mQAI0bAEB2lCgD79/SICG/fFzBSRAYzc8+fuHBGjs27PUdxAgAZpogVPnQwI00duztHcSIAGaanm7Ph8SoKnenqW7swAJ0ExL29X5kADN9PYszYMESICalnXRv/NYgJrent4/WIAEqGlJBejKfIv2aXrzevBgARKgpjVc9AfMFVDT29P7BwuQADUtqQC5AmpZIAESoJb9KQIkQC0LJEAC1LI/AjRGb9GBbnrzevBgARKgpjVc9AfMGVDT29P7BwuQADUtqQD5CtayQAIkQC374yuYr2BN+yNAAtS0QK6AXAG1LJAACVDL/rgCcgXUtD8CJEBNC+QKyBVQywIJkAC17I8rIFdATfsjQALUtECugFwBtSyQAAlQy/64AnIF1LQ/AiRATQvkCsgVUMsCCZAAteyPKyBXQE37I0AC1LRAroBcAbUskAAJUMv+uAJyBdS0PwIkQE0L5ArIFVDLAgmQALXsjysgV0BN+yNAAtS0QK6AXAG1LJAACVDL/rgCcgXUtD8CJEBNC+QKyBVQywIJkADNtD/+w4STsS060JO9iv7eS4AEaKrt9J9mnopr4V9Rp3s1/bu3AAnQRFt58eLFcvbs2bK2tlZqhLq6+Z3QXUln5giQAI3dvHPnzpWTJ0+W+rWr65sAdS3e7TwBEqANBbo657nSWyBA3Qah62kCJECXCHR9ziNAXX/s+zNPgAToT4HUOY8A9ScIXb8SARKgkUDynEeAuv7Y92eeAK14gPpwziNA/QlC169EgFY0QH065xGgrj/2/ZknQCsWoD6e8whQf4LQ9SsRoBUKUF/PeQSo6499f+YJ0AoEqO/nPALUnyB0/UoEaMABWpZzHgHq+mPfn3kCNMAALds5jwD1JwhdvxIBGliAlvGcR4C6/tj3Z54ADSRAy3zOI0D9CULXr0SAljxAQzjnEaCuP/b9mSdASxqgIZ3zCFB/gtD1KxGgJQzQ0M55BKjrj31/5gnQEgVoqOc8V3oLHn/88XLixImZf7Vp6+9knvX3EdXH1df9ySef9OfT3sNXIkBLEKChn/OM+1zs3r27fPjhh6X+fdpbIkD1XxRPPfVU5DdITuuTvr8AjXkHLly4UK66qjJ1f/vjjz/Kxx9/XE6dOtXp72Hu/p90/MQakuPHj5eDBw+Ov/Pf7tF1gD799NNy7NixMuuV01T/cAO4swCNeRPvu+++0eI/8MADnb7dq3TOMw3stF/JugqQr1zTvIt/3VeAJnDbvHlz2bdvXzly5EjZtWvXBI+Y/S6reM4zrdY0X8m6CJCvXNO+gwI0k9iNN95YnnzyyfLss8+W7du3z/QcGz1o1c95psWsYamHvPWK6Eq3RQeoHjLX1+Er17Tv4H/v7wpoBredO3eWw4cPl/3795etW7fO8Ax/PWRVfp6nCekKDx73lWxRAfKVaz7vqAA1OO7Zs2d0PvTQQw/N9CzOeWZiu+RBd999dzl9+vRl/5RsEQHylWs+75sroDk4btq0qezdu3f0Jx933XXXRM/onGcipqnutNFXsnkHyFeuqd6WsXd2BTSWaLI7XH/99aPziBdeeKHceuutl32Qc57JLFvu9c+vZPMKkK9cLe/Kxo8VoDm77tixoxw6dKgcOHCgbNu2bfTsznnmjDzm6f7+lWweAfKVa3HvnwAtyLZ+CF577bWyZcuWcvTo0XL+/PkFTfK0lxOo8V9bWxv9RHLL7cyZM6M/9fzpp59ansZjNxAQIKtBgEBMQIBi9AYTICBAdoAAgZiAAMXoDSZAQIDsAAECMQEBitEbTICAANkBAgRiAgIUozeYAAEBsgMECMQEBChGbzABAgJkBwgQiAkIUIzeYAIEBMgOECAQExCgGL3BBAgIkB0gQCAmIEAxeoMJEBAgO0CAQExAgGL0BhMgIEB2gACBmIAAxegNJkBAgOwAAQIxAQGK0RtMgIAA2QECBGICAhSjN5gAAQGyAwQIxAQEKEZvMAECAmQHCBCICQhQjN5gAgQEyA4QIBATEKAYvcEECAiQHSBAICYgQDF6gwkQECA7QIBATECAYvQGEyAgQHaAAIGYgADF6A0mQECA7AABAjEBAYrRG0yAgADZAQIEYgICFKM3mAABAbIDBAjEBAQoRm8wAQICZAcIEIgJCFCM3mACBATIDhAgEBMQoBi9wQQICJAdIEAgJiBAMXqDCRAQIDtAgEBMQIBi9AYTICBAdoAAgZiAAMXoDSZAQIDsAAECMQEBitEbTICAANkBAgRiAgIUozeYAAEBsgMECMQEBChGbzABAgJkBwgQiAkIUIzeYAIEBMgOECAQExCgGL3BBAgIkB0gQCAmIEAxeoMJEBAgO0CAQExAgGL0BhMgIEB2gACBmIAAxegNJkBAgOwAAQIxAQGK0RtMgIAA2QECBGICAhSjN5gAAQGyAwQIxAQEKEZvMAECAmQHCBCICQhQjN5gAgQEyA4QIBATEKAYvcEECAiQHSBAICYgQDF6gwkQECA7QIBATECAYvQGEyAgQHaAAIGYgADF6A0mQECA7AABAjEBAYrRG0yAgADZAQIEYgICFKM3mAABAbIDBAjEBAQoRm8wAQICZAcIEIgJCFCM3mACBATIDhAgEBMQoBi9wQQICJAdIEAgJiBAMXqDCRAQIDtAgEBMQIBi9AYTICBAdoAAgZiAAMXoDSZA4N9AlZxbrbmabAAAAABJRU5ErkJggg=="
}

@main
class NowPlayingPlugin: PluginDelegate
{
    typealias Settings = NoSettings
    
    static var name: String  = "Now Playing"
    
    static var description: String = "This plugin displays the album art of the currently playing media. Press the key for play/pause"
    
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
    
    typealias MRMediaRemoteSendCommandFunction = @convention(c) (CInt, NSDictionary) -> Bool
    private var MRMediaRemoteSendCommand: MRMediaRemoteSendCommandFunction
    
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
        
        guard let MRMediaRemoteSendCommandPointer = CFBundleGetFunctionPointerForName(bundle, "MRMediaRemoteSendCommand" as CFString) else {abort()}
        self.MRMediaRemoteSendCommand = unsafeBitCast(MRMediaRemoteSendCommandPointer, to: MRMediaRemoteSendCommandFunction.self)
        
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
                artwork = NSImage(base64EncodedString: Constants.DEFAULT_IMG)
            }
            self.setImage(to: artwork)
            
            //let title: String? = self.getItemFromNowPlayingInfo(info: information, key: Self.kMRMediaRemoteNowPlayingInfoTitle)
            //self.setTitle(to: title)
        })
    }
    
    func keyDown(device: String, payload: KeyEvent<NoSettings>)
    {
        //2 is the enum code for play/pause
        let _ = MRMediaRemoteSendCommand(2, NSDictionary());
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

extension NSImage {

    convenience init?(base64EncodedString: String) {
        guard
            let url = URL(string: base64EncodedString),
            let data = try? Data(contentsOf: url)
        else {
            return nil
        }

        self.init(data: data)
    }
}
