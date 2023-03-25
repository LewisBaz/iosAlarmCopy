//
//  AlarmApp.swift
//  Alarm
//
//  Created by Lewis on 19.02.2023.
//

import SwiftUI

@main
struct AlarmApp: App {
    
    @StateObject private var dataController = AlarmDataController()

    var body: some Scene {
        WindowGroup {
            MainContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
