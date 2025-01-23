//
//  CategoriesGridView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import SwiftUI

struct CategoryItem:Identifiable,Hashable {
    var color: Color
    var title: String
    var icon: String
    var id: String { title }
}

struct CategoriesGridView: View {

    let categories:[CategoryItem] = [
        CategoryItem(color: .red, title: "車", icon: "car.fill"),
        CategoryItem(color: .orange, title: "暮らし", icon: "figure.and.child.holdinghands"),
        CategoryItem(color: .green, title: "自然", icon: "tree.fill"),
        CategoryItem(color: .orange, title: "暮らし", icon: "figure.and.child.holdinghands"),
        CategoryItem(color: .green, title: "自然", icon: "tree.fill"),
        CategoryItem(color: .orange, title: "暮らし", icon: "figure.and.child.holdinghands"),
        CategoryItem(color: .green, title: "自然", icon: "tree.fill")
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 60/255, green: 80/255, blue: 140/255))
                .ignoresSafeArea(edges: .all)
            VStack {
                CategoriesTitleView()
                
                VStack(spacing:40){
                    Grid(horizontalSpacing: 40, verticalSpacing: 40) {
                        ForEach(0..<categories.count / 3, id: \.self) { rowIndex in
                            GridRow {
                                ForEach(0..<3) { index in
                                    let ball = categories[rowIndex * 3 + index]
                                    ballView(color: ball.color, title: ball.title, icon: ball.icon)
                                }
                            }
                        }
                        // 余りの要素があれば最後の行に追加
                        if categories.count % 3 != 0 {
                            GridRow {
                                ForEach((categories.count / 3) * 3..<categories.count, id: \.self) { index in
                                    let ball = categories[index]
                                    ballView(color: ball.color, title: ball.title, icon: ball.icon)
                                }
                            }
                        }
                    }
                }
                .padding(.top,50)
                
                Spacer()
            }
            .foregroundColor(.white)
        }
        .navigationTitle("")
        .navigationBarHidden(true)
    }
}

#Preview {
    CategoriesGridView()
}

struct CategoriesTitleView: View {
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    var body: some View {
        HStack {
            Image(systemName: "arrow.left")
                .onTapGesture {
                    self.presentationMode.wrappedValue.dismiss()
                }
            Spacer()
            Text("カテゴリーを選んでください")
                .titleLabel()
            Spacer()
        }
        .padding(.horizontal,20)
    }
}

struct ballView: View {
    var color:Color = .blue
    var title:String = "test"
    var icon:String = "hare"
    private let diameter = UIScreen.main.bounds.width / 6
    var body: some View {
        Button(action:{})
        {
            VStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.4))
                        .frame(width: diameter, height: diameter)
                    Image(systemName: icon)
                        .foregroundColor(color)
                    
                }
                Text(title)
                    .font(.system(size: 14))
                    .padding(.top, 10)
            }
        }
    }
}
