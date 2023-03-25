//
//  AlarmNameView.swift
//  Alarm
//
//  Created by Lewis on 11.03.2023.
//

import SwiftUI

struct AlarmNameView: View {

    @Binding var name: String
    
    var body: some View {
        HStack {
            AlarmNameLeftView()
                .frame(alignment: .leading)
            AlarmNameRightView(name: $name)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct AlarmNameLeftView: View {
        
    var body: some View {
        Text("Название")
    }
}

struct AlarmNameRightView: View {
    
    @Binding var name: String
    
    var body: some View {
        TextField("Будильник", text: $name)
            .multilineTextAlignment(.trailing)
    }
}

struct AlarmNameView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmNameView(name: .constant("Alarm_test"))
    }
}
