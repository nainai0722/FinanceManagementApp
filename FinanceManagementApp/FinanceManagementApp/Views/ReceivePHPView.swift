//
//  ReceivePHPView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import SwiftUI
import Foundation

struct ReceivePHPView: View {
    @State private var taskName: String = ""
    @State var originalTasks:[Task] = []
    @State var filteredTasks: [Task] = []
    @State var isAlertPresented: Bool = false
    @State var showDatePicker: Bool = false
    @State var savedDate: Date? = nil
    var body: some View {
        ZStack {
            VStack {
                SortSelectView(originalTasks: $originalTasks, filteredTasks: $filteredTasks)
                if !originalTasks.isEmpty {
                    VStack(alignment:.leading) {
                        ForEach(filteredTasks){ task in
                            
                            HStack {
                                Button(action:{
                                    let updateTask = Task(id: task.id, taskName: task.taskName, dueDate: task.dueDate, status: task.status == "Incomplete" ? "Complete" : "Incomplete")
                                    
                                    updateDataToPHP(from: updateTask){ result in
                                        switch result {
                                        case .success(let tasks):
                                            setTasks(from: tasks)
                                        case .failure(let error):
                                            print("error : \(error)")
                                        }
                                        
                                    }
                                }){
                                    Image(systemName: task.status == "Incomplete" ? "square" : "checkmark.square")
                                        .font(.system(size: 30))
                                        .padding(.vertical,10)
                                }
                                Button(action:{
                                    isAlertPresented.toggle()
                                }){
                                    Text("\(task.taskName) 期日: \(task.dueDate)")
                                        .font(.system(size: 18))
                                        .frame(width: 270, height: 30,alignment:.leading)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .padding([.leading, .trailing], 16)
                                        .background(Color(.systemGray6))
                                }
                                Spacer()
                            }
                            .padding(.leading, 20)
                            .alert("タスクを削除しますか？", isPresented: $isAlertPresented) {
                                Button("はい", role: .destructive) {
                                    print("タスクを削除しました")
                                    // ここで削除処理を実行
                                    deleteDataToPHP(from: task){ result in
                                        switch result {
                                        case .success(let tasks):
                                            setTasks(from: tasks)
                                        case .failure(let error):
                                            print("error:\(error)")
                                        }
                                    }
                                }
                                Button("いいえ", role: .cancel) {
                                    print("削除をキャンセルしました")
                                }
                            } message: {
                                Text("この操作は取り消せません。")
                            }
                        }
                    }
                }
                
                TextField("タスクを入力", text: $taskName)
                    .frame(width: 300, height: 50)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading, 10)
                Button(action: {
                    showDatePicker.toggle()
                }){
                    Image(systemName: "calendar")
                        .font(.system(size: 20))
                        .foregroundColor(.orange)
                }
                Button(action:{
                    if let data = savedDate {
                        
                        sendDataToPHP(taskName:taskName , dueDate: formatDateToJapaneseString(data), status:"Incomplete"){ result in
                            switch result {
                            case .success(let tasks):
                                setTasks(from: tasks)
                                self.taskName = ""
                            case .failure(let error):
                                print("Error: \(error)")
                            }
                        }
                    }
                    
                }){
                    Text("データ送信")
                }
                
                
            }
            .onAppear(){
                fetchTasks { result in
                    switch result {
                    case .success(let tasks):
                        print("タスク一覧を取得しました:")
                        self.originalTasks = tasks
                        for task in tasks {
                            print("ID: \(task.id), 名前: \(task.taskName), 締切: \(task.dueDate), 状態: \(task.status)")
                        }
                    case .failure(let error):
                        print("エラーが発生しました: \(error.localizedDescription)")
                    }
                }
            }
            
            if showDatePicker {
                CalendarView(showDatePicker: $showDatePicker, savedDate: $savedDate, date: savedDate ?? Date())
                            .animation(.linear, value: savedDate)
                            .transition(.opacity)
                        }
        }

    }
    func setTasks(from tasks:[Task]){
        originalTasks = tasks
        filteredTasks = tasks
    }
    
    func formatDateToJapaneseString(_ date: Date?) -> String {
        guard let date = date else { return  ""}
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        return formatter.string(from: date)
    }
}

#Preview {
    ReceivePHPView()
}

struct SortSelectView: View {
    @Binding var originalTasks:[Task]
    @Binding var filteredTasks: [Task]
    var body: some View {
        HStack{
            Button(action:{
                filteredTasks.sort { $0.taskName < $1.taskName }
            }){
                Text("名前順に表示")
            }
            Button(action:{
                filteredTasks.sort { $0.id < $1.id }
            }){
                Text("id順に表示")
            }
            Button(action:{
                filteredTasks = originalTasks.filter { $0.status == "Incomplete" }
            }){
                Text("未完了のみ表示")
            }
            Button(action:{
                filteredTasks = originalTasks
            }){
                Text("すべて表示")
            }
        }
    }
}
