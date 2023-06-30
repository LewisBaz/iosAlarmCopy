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
    
    @State var showAddAlarmSheet = false
    @State var showEditAlarmSheet = false
    
    @State var newAlarm = Alarm()
    @State var ringtone: Ringtone?
    
    @State var editMode: EditMode = .inactive
    @State var isEditing = false
    
    private let datesManager = DatesManager()
    
    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                ForEach(Array(alarms.enumerated().sorted(by: { $0.element.time! < $1.element.time! })), id: \.element) { i, item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.time ?? Date(), format: .dateTime.hour().minute())
                                .font(.system(size: 40))
                            if item.repeatDays != "0" {
                                Text("\(item.name ?? "Будильник"), \(datesManager.getShortWeekDay(weekDaysNumbersString: item.repeatDays))")
                            } else {
                                Text(item.name ?? "Будильник")
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        if !isEditing {
                            Toggle("", isOn: Binding<Bool>(
                                get: { item.isOn },
                                set: {
                                    item.isOn = $0
                                    try? viewContext.save()
                                }
                            ))
                            .frame(width: 50, alignment: .trailing)
                        } else {
                            Image(systemName: "chevron.right")
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .environment(\.editMode, $editMode)
            .animation(.default, value: isEditing)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(!isEditing ? "Править" : "Готово", action: {
                        isEditing.toggle()
                        editMode = isEditing ? .active : .inactive
                    })
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                }
                ToolbarItem {
                    Button {
                        showAddAlarmSheet = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                    .sheet(isPresented: $showAddAlarmSheet) {
                        AddAlarmView(newAlarm: $newAlarm, ringtone: $ringtone)
                    }
                    .onChange(of: newAlarm, perform: { newValue in 
                        print(newAlarm)
                        showAddAlarmSheet = false
                        addItem(item: newAlarm)
                    })
                    .onChange(of: showAddAlarmSheet) { newValue in
                        if newValue == false {
                            ringtone = nil
                        }
                    }
                }
            }
            .navigationBarTitle("Будильник", displayMode: .automatic)
        }
    }

    private func addItem(item: Alarm) {
        withAnimation {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            isEditing = false
            editMode = .inactive
            
            for index in offsets {
                let alarm = alarms[index]
                viewContext.delete(alarm)
            }

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
