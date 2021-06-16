//
//  AudioPlayer.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/16/21.
//

import SwiftUI
import AVFoundation

struct AudioPlayer: View {
  @State private var isPlaying: Bool = true
  @State private var currentTime: CMTime = CMTime.zero
 
  var player: AVPlayer?
  var playerObserver: Any?
    
  init(name: String) {
    print("hello")
    
    if let path = Bundle.main.url(forResource: name, withExtension: "m4a") {
      print("path \(path)")
      self.player = AVPlayer(url: path)
      
      self.playerObserver = self.player?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 10), queue: nil, using: handleTimeChange)
    }
  }
  
  var body: some View {
    var currentProgress: CGFloat
    if let player_ = player {
      let duration = CMTimeGetSeconds(player_.currentItem?.duration ?? CMTimeMakeWithSeconds(1, preferredTimescale: 1))
      currentProgress = duration > 0 ? CMTimeGetSeconds(self.currentTime) / duration : 0
    } else {
      currentProgress = 0.0
    }
    
    print("progress \(currentProgress)")
    
    return HStack {
      Button(action: playPause) {
        Image(systemName: "speaker.2")
      }
      if isPlaying {
        Button(action: stop) {
          Image(systemName: "stop")
        }
        ProgressBar(progress: currentProgress).transition(.slide)
      }
    }
  }

  func playPause() {
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
  
  func handleTimeChange(newTime: CMTime) {
    print("udpating \(newTime)")
    currentTime = newTime
    isPlaying = true
  }
}

class ProgressObserver: ObservableObject {
  @Published var currentProgress: CGFloat = 0
  
  var observation: Any?
  
  init(player: AVPlayer) {
    // TODO (kyle): memory leak?
    observation = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 5), queue: nil) { newTime in
      let duration = CMTimeGetSeconds(player.currentItem?.duration ?? CMTimeMakeWithSeconds(1, preferredTimescale: 1))
      self.currentProgress = duration > 0 ? CMTimeGetSeconds(player.currentTime()) / duration : 0
    }
  }
}

struct ProgressBar: View {
  var progress: CGFloat
  
  var body: some View {
    GeometryReader { geo in
      let halfHeight = geo.size.height / 2
      Rectangle().frame(maxWidth: .infinity, maxHeight: 2).position(
        x: geo.size.width / 2,
        y: halfHeight
      ).overlay(
        Circle().frame(width: 10, height: 10)
          .position(x: progress * geo.size.width, y: halfHeight)
          .animation(.linear)
      )
    }
  }
}

struct AudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        AudioPlayer(name: "voice-log-test")
      }
    }
}
