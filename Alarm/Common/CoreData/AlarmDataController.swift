//
//  AlarmDataController.swift
//  Alarm
//
//  Created by Lewis on 25.03.2023.
//

import Foundation
import CoreData

final class AlarmDataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "Alarm")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
