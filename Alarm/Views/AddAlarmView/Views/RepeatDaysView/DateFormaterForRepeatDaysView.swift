//
//  DateFormaterForRepeatDaysView.swift
//  Alarm
//
//  Created by Lewis on 25.03.2023.
//

import Foundation

struct WeekDay: Identifiable, Equatable {
    let id = UUID()
    let stringName: String
    let weekDayOrderNumber: Int
    let shortName: String
    var isSelected = false
    
    mutating func toggleSelection() {
        isSelected.toggle()
    }
}

struct RepeatDaysViewDataStore {
    
    private let weekDays = ["Каждый понедельник", "Каждый вторник", "Каждую среду", "Каждый четверг", "Каждую пятницу", "Каждую субботу", "Каждое воскресенье"]
    
    var weekDaysModels: [WeekDay] = []
    
    init() {
        self.weekDaysModels = getWeekDays()
    }
    
    mutating func updateIsSelectedStateFor(index: UUID) {
        if let index = weekDaysModels.firstIndex(where: { $0.id == index }) {
            weekDaysModels[index].isSelected.toggle()
        }
    }
    
    private func getWeekDays() -> [WeekDay] {
        var weekDaysToReturn: [WeekDay] = []
        var index = 1
        weekDays.forEach({
            weekDaysToReturn.append(WeekDay(stringName: $0, weekDayOrderNumber: index, shortName: getShortWeekDay(weekDayOrderNumber: index)))
            index += 1
        })
        return weekDaysToReturn
    }
    
    private func getShortWeekDay(weekDayOrderNumber: Int) -> String {
        switch weekDayOrderNumber {
        case 1:
            return "ПН"
        case 2:
            return "ВТ"
        case 3:
            return "СР"
        case 4:
            return "ЧТ"
        case 5:
            return "ПТ"
        case 6:
            return "СБ"
        case 7:
            return "ВС"
        default:
            return ""
        }
    }
}
