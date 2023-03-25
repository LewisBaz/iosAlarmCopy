//
//  AlarmRepeatSignalView.swift
//  Alarm
//
//  Created by Lewis on 25.03.2023.
//

import SwiftUI

struct AlarmRepeatSignalView: View {

    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            Toggle("Повторение сигнала", isOn: $isSelected)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct AlarmRepeatSignalView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmRepeatSignalView(isSelected: .constant(true))
    }
}
