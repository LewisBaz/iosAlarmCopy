//
//  MelodiesDataStore.swift
//  Alarm
//
//  Created by Lewis on 26.03.2023.
//

import Foundation

struct Ringtone: Identifiable {
    let id: Int
    let name: String
    var isSelected = false
}

final class MelodiesDataStore: ObservableObject {
    
    private let fileManager = FileManager()
    
    private var directory: NSMutableDictionary = [
        "path" : "/Library/Ringtones",
        "files" : []
    ]
    
    @Published var filesList: [Ringtone] = [Ringtone(id: 100, name: "kek")]
    
    // MARK: - Init
    
    init() {
        getRingtones()
        filesList = createRingtonesList()
    }
    
    // MARK: - Public Methods
    
    func updateSelectedMelody(index: Int) {
        deselectOldMelody()
        selectNewMelody(index: index)
    }
    
    // MARK: - Private Methods
    
    private func selectNewMelody(index: Int) {
        if let indexOfNew = filesList.firstIndex(where: { $0.id == index }) {
            filesList[indexOfNew].isSelected.toggle()
        }
    }
    
    private func deselectOldMelody() {
        if let indexOfSelected = filesList.firstIndex(where: { $0.isSelected }) {
            filesList[indexOfSelected].isSelected = false
        }
    }
    
    private func createRingtonesList() -> [Ringtone] {
        var ringtones = [Ringtone]()
        for (index, file) in (directory["files"] as! [String]).enumerated() {
            ringtones.append(Ringtone(id: index + 1, name: file))
        }
        return ringtones
    }
    
    private func getRingtones() {
        let directoryURL: URL = URL(fileURLWithPath: directory.value(forKey: "path") as! String, isDirectory: true)
        
        do {
            var URLs: [URL]?
            URLs = try fileManager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: [URLResourceKey.isDirectoryKey], options: FileManager.DirectoryEnumerationOptions())
            var urlIsaDirectory: ObjCBool = ObjCBool(false)
            var soundPaths: [String] = []
            for url in URLs! {
                fileManager.fileExists(atPath: url.path, isDirectory: &urlIsaDirectory)
                if !urlIsaDirectory.boolValue {
                    soundPaths.append("\(url.lastPathComponent)")
                }
            }
            directory["files"] = soundPaths
        } catch {
            debugPrint("\(error)")
        }
    }
}
