//
//  TestView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/23.
//

import SwiftUI

struct TestView: View {
    // falseにして、カレンダーを表示しないようにしておく
    @State var showDatePicker: Bool = false
    // カレンダー画面で選択した値を格納する変数
    @State var savedDate: Date?
    var body: some View {
        // ZStackで囲うことで、重ねて表示ができる。
        ZStack {
            VStack {
                Button("カレンダーを表示"){
                    // ボタンを押した際にshowDatePickerの値を切り替える
                    showDatePicker.toggle()
                }
                if let date = savedDate {
                    // カレンダーから日時を選択した際に文字列変換して表示する
                    Text(DateFormat(from: date))
                }
            }
            
            if showDatePicker {
                // showDatePickerがtrueのときだけ、カレンダー画面を表示する
                CalendarView(showDatePicker: $showDatePicker, savedDate: $savedDate)
            }
        }
    }
    
    func DateFormat(from date:Date?) -> String {
        // Date?型をフォーマットを整え、文字列に変換する
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let formattedDate = formatter.string(from: date)
        return formattedDate
    }
    
}

#Preview {
    TestView()
}
