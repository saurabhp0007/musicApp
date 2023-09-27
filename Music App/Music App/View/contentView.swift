//
//  contentView.swift
//  Music App
//
//  Created by Saurabh  on 10/09/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var dataLoader = DataLoader()
    @StateObject var musicPlayer = MusicPlayerViewModel() // Add music player view model
    @State private var isForYouActive = false
    @State private var isTopTracksActive = false
    @State private var isMusicPlayerVisible = false
    @StateObject var audioManager = AudioManager()// Add this state variable

    var body: some View {
        ScrollView {
            VStack {
                ForEach(dataLoader.data) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                                .foregroundColor(Color.white)
                            Text(item.artist)
                                .foregroundColor(Color.white)
                            Divider()
                        }
                        .padding(10)
                    }
                    .padding(.horizontal, 20)
                    .onTapGesture {
                        // Show the music player when a cell is tapped
                        musicPlayer.currentTrack = item
                        isMusicPlayerVisible = true
                        if let item = musicPlayer.currentTrack {
                                       audioManager.playAudioFromURL(url: item.url)
                                       musicPlayer.isPlaying.toggle()
                                   }
                        
                       
                    }
                }
            }
            .onAppear(perform: dataLoader.loadData)
            Spacer()
            HStack {
                Button(action: {
                    // Action for "For You" button
                    isForYouActive.toggle()
                    isTopTracksActive = false
                }) {
                    VStack {
                        Text("For You")
                            .padding()
                            .background(Color.black)
                            .foregroundColor(Color.white)
                            .cornerRadius(10)
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(isForYouActive ? Color.white : Color.clear)
                    }
                }
                Spacer()
                Button(action: {
                    // Action for "Top Tracks" button
                    isTopTracksActive.toggle()
                    isForYouActive = false
                }) {
                    VStack {
                        Text("Top Tracks")
                            .padding()
                            .background(Color.black)
                            .foregroundColor(Color.white)
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(isTopTracksActive ? Color.white : Color.clear)
                    }
                }
            }
            .padding(.horizontal, 70)
            .padding(.bottom, 20)
        }
        .background(Color.black)
        .sheet(isPresented: $isMusicPlayerVisible) {
            MusicPlayerView(musicPlayer: musicPlayer)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





