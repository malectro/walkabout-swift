//
//  AudioPlayer.swift
//  WalkaboutSwift
//
//  Created by Kyle Warren on 6/16/21.
//

import AVFoundation
import SwiftUI

struct AudioPlayer: View {
  @State private var isOpen: Bool = false
  @State private var isPlaying: Bool = false
  @State private var currentTime = CMTime.zero

  @ObservedObject var progressObserver: ProgressObserver

  var player: AVPlayer?
  var playerObserver: Any?

  init(name: String) {
    if let path = Bundle.main.url(forResource: name, withExtension: "m4a") {
      player = AVPlayer(url: path)
    }

    progressObserver = ProgressObserver(player: player)
  }

  var body: some View {
    HStack {
      if isOpen {
        Button(action: stop) {
          Image(systemName: "stop")
        }
        Button(action: playPause) {
          Image(systemName: isPlaying ? "pause" : "play")
        }
        ProgressBar(progress: progressObserver.currentProgress)
      } else {
        Button(action: open) {
          Image(systemName: "speaker.2")
        }
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

  func open() {
    player?.play()
    isPlaying = true
    isOpen = true
  }

  func stop() {
    player?.pause()
    player?.seek(to: CMTime.zero)
    isPlaying = false
    isOpen = false
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

  init(player: AVPlayer?) {
    // TODO: (kyle): memory leak?
    if let player = player {
      observation = player.addPeriodicTimeObserver(
        forInterval: CMTime(value: 1, timescale: 5),
        queue: nil
      ) { _ in
        let duration = CMTimeGetSeconds(player.currentItem?
          .duration ?? CMTimeMakeWithSeconds(
            1,
            preferredTimescale: 1
          ))
        self
          .currentProgress = duration > 0 ?
          CMTimeGetSeconds(player.currentTime()) / duration : 0
      }
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
