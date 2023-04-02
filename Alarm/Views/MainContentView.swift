//
//  MainContentView.swift
//  Alarm
//
//  Created by Lewis on 19.02.2023.
//

import SwiftUI
import CoreData

struct MainContentView: View {
    
    // MARK: - FetchRequest
    
    @FetchRequest(sortDescriptors: []) var alarms: FetchedResults<Alarm>
    
    // MARK: - Environment Properties
    
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - State Properties
    
    @State var showSheet = false
    
    @State var newAlarm = Alarm()
    @State var ringtone: Ringtone?
    
    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                ForEach(alarms) { item in
                    Button(action: {
                        self.showSheet = true
                    }){
                        Text(item.name ?? "ddd")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Править") {
                        
                    }
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                }
                ToolbarItem {
                    Button {
                        showSheet = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                    .sheet(isPresented: $showSheet) {
                        AddAlarmView(newAlarm: $newAlarm, ringtone: $ringtone)
                    }
                    .onChange(of: newAlarm, perform: { newValue in 
                        print(newAlarm)
                        showSheet = false
                        // additem
                    })
                    .onChange(of: showSheet) { newValue in
                        if newValue == false {
                            ringtone = nil
                        }
                    }
                }
            }
            .navigationBarTitle("Будильник", displayMode: .automatic)
        }
    }

    private func addItem(name: String?) {
        withAnimation {
            let newAlarm = Alarm(context: viewContext)
            newAlarm.name = name
            newAlarm.id = UUID()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { alarms[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
