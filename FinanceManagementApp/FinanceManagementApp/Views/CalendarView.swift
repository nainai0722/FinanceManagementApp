//
//  CalendarView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import SwiftUI

struct CalendarView: View {
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var date: Date = Date()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.black.opacity(0.5))
                .ignoresSafeArea(.all)
                .onTapGesture {
                    showDatePicker = false
                }
            
            VStack{
                DatePicker(selection: $date) {
                        Text("Start Date")
                        Text("Select the starting date for the event")
                }
                .datePickerStyle(.graphical)
                Divider()
                HStack{
                    Button("キャンセル"){
                        showDatePicker = false
                    }
                    Spacer()
                    Button("保存"){
                        savedDate = date
                        showDatePicker = false
                    }
                }
                .padding(.vertical,15)
                .padding(.horizontal,20)
            }
            .padding(.horizontal, 20)
            .background(
                Color.white.cornerRadius(30)
            )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    CalendarView(showDatePicker:.constant(false), savedDate: .constant(Date()))
}
