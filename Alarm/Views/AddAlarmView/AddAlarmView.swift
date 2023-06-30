//
//  AddAlarmView.swift
//  Alarm
//
//  Created by Lewis on 19.02.2023.
//

import SwiftUI

struct AddAlarmView: View {
    
    // MARK: - Environment Properties
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - State Object Properties
    
    @StateObject private var melodiesDataStore = MelodiesDataStore()
    
    // MARK: - State Properties
    
    @State private var repeatDaysDataStore = RepeatDaysViewDataStore()
    @State private var currentDate = Date()
    @State private var alarmName = String()
    @State private var isAlarmRepeat = true
    @State private var isRepeatDaysSelected = false
    @State private var selectedRepeatDays = [WeekDay(stringName: "Никогда", weekDayOrderNumber: 0, shortName: "Никогда")]
    
    // MARK: - Binding Properties
    
    @Binding var newAlarm: Alarm
    @Binding var ringtone: Ringtone?
    
    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                DatePicker("ru", selection: $currentDate, displayedComponents: .hourAndMinute)
                    .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                List {
                    NavigationLink {
                        RepeatDaysView(dataStore: $repeatDaysDataStore,
                                       selectedDates: $selectedRepeatDays,
                                       isDaySelected: $isRepeatDaysSelected)
                    } label: {
                        HStack {
                            Text("Повтор")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(selectedRepeatDays.map{$0.shortName}.joined(separator: ", "))
                        }
                    }

                    AlarmNameView(name: $alarmName)
                    
                    NavigationLink {
                        MelodiesView(selectedRingtone: $ringtone, dataStore: melodiesDataStore)
                    } label: {
                        HStack {
                            Text("Мелодия")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(ringtone?.name.dropLast(4) ?? "")
                        }
                    }
                    
                    AlarmRepeatSignalView(isSelected: $isAlarmRepeat)
                }
                .gesture(DragGesture().onChanged { _ in
                    hideKeyboard()
                })
            }
            .navigationBarTitle("Добавление", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                }
                ToolbarItem(placement: ToolbarItemPlacement.confirmationAction) {
                    Button("Сохранить") {
                        let newAlarm = Alarm(context: viewContext)
                        newAlarm.id = UUID()
                        if alarmName.isEmpty {
                            newAlarm.name = "Будильник"
                        } else {
                            newAlarm.name = alarmName
                        }
                        newAlarm.isRepeat = isAlarmRepeat
                        newAlarm.repeatDays = selectedRepeatDays.map({ String($0.weekDayOrderNumber) }).joined(separator: ", ")
                        newAlarm.melodyId = Int16(ringtone?.id ?? 1)
                        newAlarm.time = currentDate
                        newAlarm.isOn = true
                        self.newAlarm = newAlarm
                    }
                    .foregroundColor(colorScheme == .dark ? .orange : .blue)
                }
            }
        }
    }
}

struct AddAlarmView_Previews: PreviewProvider {
    
    static var previews: some View {
        AddAlarmView(newAlarm: .constant(Alarm()), ringtone: .constant(.none))
    }
}
