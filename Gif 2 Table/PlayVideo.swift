//
//  PlayVideo.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 4/30/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class PlayVideo: NSObject, AVPlayerViewControllerDelegate {
    
    var mainViewController: MainVC?
    
    func playVideo(videoURL: String) {
        guard let mainVC = mainViewController else { return }
        
        let url = URL(string: videoURL)
        
        let videoController = AVPlayerViewController()
        let videoPlayer = AVPlayer(url: url!)
        
        videoController.player = videoPlayer
        
        mainVC.present(videoController, animated: true) { 
            mainVC.view.layoutIfNeeded()
            
            videoPlayer.play()
        }
    }

}
