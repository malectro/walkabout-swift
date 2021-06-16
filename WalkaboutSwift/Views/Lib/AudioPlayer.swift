//
//  AudioPlayer.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/16/21.
//

import SwiftUI
import AVFoundation

struct AudioPlayer: View {
  @State var isPlaying: Bool = false
  
  /*
  var loadPlayer: AVPlayer {
    guard let url = URL(string: name) else {
      return nil
    }
    return AVPlayer(url: url)
  }
  lazy var audioPlayer: AVPlayer = loadPlayer
   */
  
  var player: AVPlayer?
  
  init(name: String) {
    print("hello")
    
    /*
    if let asset = NSDataAsset(name: name) {
      self.player = AVPlayer(url: asset.)
    }
     */
    
    if let path = Bundle.main.url(forResource: name, withExtension: "m4a") {
      print("path \(path)")
      self.player = AVPlayer(url: path)
    }
    
    /*
    if let url = URL(string: name) {
      self.player = AVPlayer(url: url)
    }
     */
  }
  
  
  var body: some View {
    HStack {
      Button(action: playPause) {
        Image(systemName: "speaker.2")
      }
      if isPlaying {
        Button(action: stop) {
          Image(systemName: "stop")
        }
      }
    }
  }

  func playPause() {
    print("playpause")
    if isPlaying {
      player?.pause()
      isPlaying = false
    } else {
      player?.play()
      isPlaying = true
    }
  }
  
  func stop() {
    player?.pause()
    player?.seek(to: CMTime.zero)
    isPlaying = false
  }
}

struct AudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AudioPlayer(name: "voice-log-test")
      }
    }
}
