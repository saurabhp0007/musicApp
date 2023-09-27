//
//  MusicPlayerView.swift
//  Music App
//
//  Created by Saurabh  on 12/09/23.
//

import SwiftUI
import AVFoundation

struct MusicPlayerView: View {
    @ObservedObject var musicPlayer: MusicPlayerViewModel
    @StateObject private var audioManager = AudioManager() // Capture audioManager as a @StateObject

    var body: some View {
        VStack {
            Text("Now Playing:")
                .font(.title)
                .padding()

            Text("\(musicPlayer.currentTrack?.name ?? "") - \(musicPlayer.currentTrack?.artist ?? "")")
                .font(.headline)
                .padding()

            Button(action: {
                // Implement play/pause action
                musicPlayer.isPlaying.toggle()
                if musicPlayer.isPlaying {
                    audioManager.playAudioFromURL(url: musicPlayer.currentTrack?.url ?? "")
                } else {
                    audioManager.pause()
                }
            }) {
                Image(systemName: musicPlayer.isPlaying ? "pause.circle" : "play.circle")
                    .font(.largeTitle)
            }
            .padding()

            // Add other player controls and track progress slider here
        }
    }
}
