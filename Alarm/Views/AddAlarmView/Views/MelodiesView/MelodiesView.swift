//
//  MelodiesView.swift
//  Alarm
//
//  Created by Lewis on 26.03.2023.
//

import SwiftUI
import AVKit

struct MelodiesView: View {
    
    @State var audioPlayer: AVAudioPlayer?
    
    // MARK: - Environment Properties
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Private Properies
    
    private let insets = EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 10)
    
    // MARK: - Binding Properies

    @Binding var selectedRingtone: Ringtone?
    
    // MARK: - State Object Properies
    
    @StateObject var dataStore: MelodiesDataStore
    
    // MARK: - Body
    
    var body: some View {
        List(dataStore.filesList, id: \.id) { ringtone in
            HStack {
                Button {
                    if audioPlayer != nil {
                        audioPlayer?.stop()
                    }
                    selectedRingtone = ringtone
                    dataStore.updateSelectedMelody(index: selectedRingtone?.id ?? 0)
                    let fileURL = URL(fileURLWithPath: "/Library/Ringtones/\(ringtone.name)")
                    audioPlayer = try? AVAudioPlayer(contentsOf: fileURL)
                    audioPlayer?.play()
                } label: {
                    HStack {
                        if ringtone.isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(colorScheme == .dark ? .orange : .blue)
                                .frame(width: 30)
                                .padding(insets)
                        } else {
                            Spacer()
                                .frame(width: 30)
                                .padding(insets)
                        }
                        Text(ringtone.name.dropLast(4))
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
            .navigationBarTitle("Мелодия", displayMode: .inline)
        }
    }
}

struct MelodiesView_Previews: PreviewProvider {
    static var previews: some View {
        MelodiesView(selectedRingtone: .constant(.none), dataStore: MelodiesDataStore())
    }
}
