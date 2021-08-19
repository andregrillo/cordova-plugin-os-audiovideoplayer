//
//  OSAudioVideoPlayer.swift
//  OSAudioVideoPlayer
//
//  Created by Andre Grillo on 17/08/2021.
//

import Foundation

@objc(OSAudioVideoPlayer) class OSAudioVideoPlayer: CDVPlugin {

    @objc(initialize:)
    func initialize(command: CDVInvokedUrlCommand) {
        var pluginResult = CDVPluginResult()

        if let audioURL = command.arguments[0] as? String, let videoURL = command.arguments[1] as? String {
            let playerViewController = OSPlayerViewController()
            playerViewController.videoAudios = [audioURL]
            playerViewController.videos = [videoURL]
            
            playerViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            self.viewController.present(playerViewController, animated: true, completion: nil)

            pluginResult = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
                        
        } else {
            pluginResult = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAs: "Missing input parameters")
            self.commandDelegate!.send(pluginResult, callbackId: command.callbackId)
        }
    }
}
