//
//  AddIncomeView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import SwiftUI

struct CategoryType:Identifiable,Hashable {
    var color: Color
    var title: String
    var icon: String
    var isSelected: Bool
    var id: String { title }
}

struct AddIncomeView: View {
    @State var income: String = ""
    @State var date: String = ""
    @State var showDatePicker: Bool = false
    @State var savedDate: Date? = nil
    @State var category: CategoryType? = nil
    @State var categories:[CategoryType] = [
        CategoryType(color: .red, title: "車", icon: "car.fill",isSelected: false),
        CategoryType(color: .orange, title: "暮らし", icon: "figure.and.child.holdinghands",isSelected: false),
        CategoryType(color: .green, title: "自然", icon: "tree.fill",isSelected: false)
    ]
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 60/255, green: 80/255, blue: 140/255))
                .ignoresSafeArea(edges: .all)
            VStack {
                AddIncomeTitleView()
                
                RoundedRectangle(cornerRadius: 3)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 1)
                    .foregroundColor(.white)
                    .padding(.bottom,10)
                
                VStack(alignment:.leading){
                    Text("収入")
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .fill()
                            .border(.gray.opacity(0.5))
                            .frame(height: 50)
                        HStack {
                            TextField("金額を入力してください", text: $income)
                                .padding(.leading,10)
                                .foregroundColor(.black)
                            Text("円")
                                .foregroundColor(.black)
                                .padding(.trailing,10)
                        }
                    }
                    
                    Text("日付")
                    ZStack {
                        RoundedRectangle(cornerRadius: 6)
                            .border(.gray.opacity(0.5))
                            .frame(height: 50)
                        HStack {
                            VStack(alignment:.leading){
                                if(savedDate == nil){
                                    HStack {
                                        Text("カレンダーから日付を選択してください")
                                            .foregroundColor(.gray.opacity(0.6))
                                        Spacer()
                                    }
                                }else{
                                    HStack {
                                        Text(formatDateToJapaneseString(savedDate))
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                            }
                            .padding(.leading, 10)
                            Button(action: {
                                showDatePicker.toggle()
                            }){
                                Image(systemName: "calendar")
                                    .font(.system(size: 20))
                                    .foregroundColor(.orange)
                            }
                        }
                    }
                    Text("カテゴリ")
                    Text("以下からカテゴリを選択する")
                        .font(.system(size: 15))
                    HStack{
                        ForEach(categories) { category in
                            CategoryButtonView(isSelected: false, title: category.title, icon: category.icon)
                        }
                    }
                    
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal,20)
            
            if showDatePicker {
                            CustomDatePicker(
                                showDatePicker: $showDatePicker,
                                savedDate: $savedDate,
                                selectedDate: savedDate ?? Date()
                            )
                            .animation(.linear, value: savedDate)
                            .transition(.opacity)
                        }
        }
        .navigationBarHidden(true)
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
    AddIncomeView()
}

struct AddIncomeTitleView: View {
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("収入を追加する")
                .titleLabel()
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.bottom,10)
    }
}


struct CustomDatePicker: View {
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date?
    @State var selectedDate: Date = Date()
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    showDatePicker = false
                }
            VStack {
                DatePicker(
                    "",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical)
                Divider()
                HStack {
                    Button("キャンセル") {
                        showDatePicker = false
                    }
                    Spacer()
                    Button("保存") {
                        savedDate = selectedDate
                        showDatePicker = false
                    }
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 10)
            }
            .padding(.horizontal, 20)
            .background(
                Color.white
                    .cornerRadius(30)
            )
            .padding(.horizontal, 20)
        }
    }
}

struct CategoryButtonView: View {
    @State var isSelected: Bool = false
    var title: String = "暮らし"
    var icon: String = "tortoise.fill"
    
    var body: some View {
        VStack{
            Button(action:{
                isSelected.toggle()
            }){
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(isSelected ? .orange : .gray)
                        .frame(width: 100, height: 100)
                    
                    Image(systemName: icon)
                        .foregroundColor(.white)
                        .font(.system(size: 18))
                }
            }
            Text(title)
        }
    }
}
