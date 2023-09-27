//
//  contentView.swift
//  Music App
//
//  Created by Saurabh  on 10/09/23.
//

import SwiftUI
import Foundation
import AVFoundation



struct Response: Decodable {
    var data: [MusicTrack]
}
struct MusicTrack: Decodable,Identifiable {
    var id: Int
    var status: String
    var sort: Int? // This field can be nil, so we use an optional Int
    var userCreated: String?
    var dateCreated: String
    var userUpdated: String
    var dateUpdated: String
    var name: String
    var artist: String
    var accent: String
    var cover: String
    var topTrack: Bool
    var url: String
}
class MusicPlayerViewModel: ObservableObject {
    @Published var isPlaying = false
    @Published var currentTrack: MusicTrack? = nil
    // Add more properties as needed
}
class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var audioPlayer: AVAudioPlayer?
     
  
    func playAudioFromURL(url: String) {
        guard let audioURL = URL(string: url) else {
            print("Invalid URL: \(url)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.play()
        } catch let error as NSError {
            print("Error initializing audio player: \(error.localizedDescription)")
        }
    }



    func pause() {
        audioPlayer?.pause()
    }
}



class DataLoader: ObservableObject {
    @Published var data = [MusicTrack]()
    
    func loadData() {
        guard let url = URL(string: "https://cms.samespace.com/items/songs") else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Handle the error
                print("Fetch failed: \(error.localizedDescription)")
                return
            }
            
            do {
                guard let data = data else {
                    // Handle the case where data is nil
                    print("Data is nil")
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                
                let decodedResponse = try decoder.decode(Response.self, from: data)
                
                DispatchQueue.main.async {
                    self.data = decodedResponse.data
                }
            } catch {
                // Handle decoding errors
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}

        
        

