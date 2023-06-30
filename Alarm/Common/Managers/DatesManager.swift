//
//  DatesManager.swift
//  Alarm
//
//  Created by Lewis on 11.06.2023.
//

import Foundation

struct DatesManager {
    
    func getShortWeekDay(weekDayOrderNumber: Int) -> String {
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
    
    func getShortWeekDay(weekDaysNumbersString: String?) -> String {
        guard let days = weekDaysNumbersString else { return "" }
        let array = days.components(separatedBy: ", ")
        var stringToReturn = ""
        for (index, day) in array.enumerated() {
            let string = getShortWeekDay(weekDayOrderNumber: Int(day) ?? 0)
            stringToReturn.append(string)
            if index != array.count - 1 {
                stringToReturn.append(" ")
            }
        }
        return stringToReturn
    }
}
