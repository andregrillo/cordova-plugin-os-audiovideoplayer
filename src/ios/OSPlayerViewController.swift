//
//  ViewController.swift
//  OutsysVideoPOC
//
//  Created by WorldIT on 12/08/2021.
//

import UIKit
import AVKit
class OSPlayerViewController: UIViewController {

    var video = AVPlayer()
    var playerLayer:AVPlayerLayer?
    var audio = AVPlayer()
   
    var videos = [String]()
    var videoAudios = [String]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.playerLayer?.frame = self.view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        video = AVPlayer(url: URL(string: videos.first!)!)
        audio = AVPlayer(url: URL(string:videoAudios.first!)!)

        
        video.automaticallyWaitsToMinimizeStalling = false
        video.volume = 0
        audio.automaticallyWaitsToMinimizeStalling = false
      
        
        //video player
        playerLayer = AVPlayerLayer(player: video)
        playerLayer?.videoGravity = .resizeAspectFill;
        self.view.layer.addSublayer(playerLayer!)
        
        video.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
        audio.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions(), context: nil)
        
        setCloseButton()
     
    }

    private func setCloseButton() {
        var closeButton: UIButton = {
            let btn = UIButton()
            if #available(iOS 13.0, *) {
                btn.setImage(UIImage(systemName: "x.circle"), for: .normal)
                btn.tintColor = UIColor.black
            } else {
                btn.setTitle("Close", for: .normal)
                btn.setTitleColor(.black, for: .normal)
            }
            btn.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        
        self.view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32),
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32)
        ])
    }
    
    @objc func dismissVC(){
        dismiss(animated: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard (object as? AVPlayer) == self.video || (object as? AVPlayer) == self.audio else {
              super.observeValue(forKeyPath: keyPath,
                                 of: object,
                                 change: change,
                                 context: context)
              return
          }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let player = (object as? AVPlayer)
           
              // Switch over status value
            switch player?.status {
              case .readyToPlay:
                if player == video {
                    print("v")
                    if audio.status == .readyToPlay {
                        print("va")
                        self.video.preroll(atRate: 1) { (videoFinished) in
                            print("v1 preroll \(videoFinished)")
                            if videoFinished {
                                self.audio.preroll(atRate: 1) { (audioFinished) in
                                    print("a1 preroll \(audioFinished)")
                                    if audioFinished {
                                        self.play()
                                    }
                                }
                            }
                        }
                    }
                }
                else if player == audio {
                    print("a")
                    if video.status == .readyToPlay {
                        print("av")
                        self.video.preroll(atRate: 1) { (videoFinished) in
                            print("v2 preroll \(videoFinished)")
                            if videoFinished {
                                self.audio.preroll(atRate: 1) { (audioFinished) in
                                    print("a2 preroll \(videoFinished)")
                                    if audioFinished {
                                        self.play()
                                    }
                                }
                            }
                        }
                    }
                }
              case .failed:
                break
              case .unknown:
                break
            case .none:
                break
            @unknown default:
                break
              }
          }
    }
    
    func play() {
        print("play")
        let syncTime = CMClockGetHostTimeClock();
        let hostTime = CMClockGetTime(syncTime);
        self.video.setRate(1, time: .invalid, atHostTime: hostTime)
        self.audio.setRate(1, time: .invalid, atHostTime: hostTime)
     
    }
    func pause(){
        print("pause)")
        self.video.pause()
        self.audio.pause()
    }


}

