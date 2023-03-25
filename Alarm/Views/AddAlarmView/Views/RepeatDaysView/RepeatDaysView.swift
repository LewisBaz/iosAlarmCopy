//
//  RepeatDaysView.swift
//  Alarm
//
//  Created by Lewis on 25.03.2023.
//

import SwiftUI

struct RepeatDaysView: View {
    
    // MARK: - Environment Properties
    
    @Environment(\.colorScheme) var colorScheme
    
    // MARK: - Binding Properties
    
    @Binding var dataStore: RepeatDaysViewDataStore
    @Binding var selectedDates: [WeekDay]
    @Binding var isDaySelected: Bool
    
    // MARK: - Body
    
    var body: some View {
        List(dataStore.weekDaysModels, id: \.id) { weekDay in
            HStack {
                Button {
                    dataStore.updateIsSelectedStateFor(index: weekDay.id)
                    if !isDaySelected {
                        selectedDates = []
                        isDaySelected = true
                    }
                    if !selectedDates.contains(where: { $0.id == weekDay.id }) {
                        selectedDates.append(weekDay)
                        selectedDates = selectedDates.sorted(by: { $0.weekDayOrderNumber < $1.weekDayOrderNumber })
                    } else {
                        selectedDates.removeAll(where: { $0.id == weekDay.id })
                        selectedDates = selectedDates.sorted(by: { $0.weekDayOrderNumber < $1.weekDayOrderNumber })
                    }
                } label: {
                    HStack {
                        Text(weekDay.stringName.capitalized)
                            .foregroundColor(.black)
                        Spacer()
                        if weekDay.isSelected {
                            Image(systemName: "checkmark")
                                .foregroundColor(colorScheme == .dark ? .orange : .blue)
                        }
                    }
                }
            }
            .navigationBarTitle("Повтор", displayMode: .inline)
        }
    }
}

struct RepeatDaysView_Previews: PreviewProvider {
    static var previews: some View {
        RepeatDaysView(dataStore: .constant(RepeatDaysViewDataStore()),
                       selectedDates: .constant([WeekDay(stringName: "Никогда", weekDayOrderNumber: 0, shortName: "Никогда")]),
                       isDaySelected: .constant(false))
    }
}
