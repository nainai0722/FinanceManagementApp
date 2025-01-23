//
//  ReportsView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import SwiftUI

struct ReportsView: View {
    @State var isAnimating = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 60/255, green: 80/255, blue: 140/255))
                .ignoresSafeArea(edges: .all)
            VStack {
                Text("Expenses").font(.system(size: 18))
                    .foregroundColor(.white)
                PieChart()
                    .padding(.vertical, 20)
                ScrollView{
                    VStack{
                        ExpensesRow(color: .green, title: "光熱費", price: "$2000")
                        ExpensesRow(color: .blue, title: "食費", price: "$5000")
                        ExpensesRow()
                        ExpensesRow(color: .yellow, title: "教育費", price: "$4000")
                    }
                }
            }
        }
    }
}

#Preview {
    ReportsView()
}

struct PieChart: View {
    @State var isAnimating = false
    var chartColors:[Color] = [.green, .blue,.red,.yellow]
    var endPercent :[[CGFloat]] = [[0,0.125],[0.125,0.25],[0.25,0.75],[0.75,1]]
    var body: some View {
        ZStack {
            ForEach(0..<4){ i in
                Circle()
                    .trim(from: self.isAnimating ? self.endPercent[i][0] : 0, to: self.isAnimating ? self.endPercent[i][1] : 0)
                    .rotation(.degrees(-90))
                    .stroke(lineWidth: 14)
                    .fill(self.chartColors[i])
                    .animation(.interpolatingSpring(stiffness: 300, damping: 20).speed(0.5), value: isAnimating)
                    .frame(width: UIScreen.main.bounds.width / 2.5, height: UIScreen.main.bounds.height / 2.5)
                
            }
            VStack{
                Text("Spend")
                    .font(.system(size: 16))
                Text("$2000")
                    .bold()
                    .font(.system(size: 20))
            }
            .foregroundColor(.white)
        }
        .onAppear{
            isAnimating.toggle()
        }
    }
}

struct ExpensesRow: View {
    var color:Color = .red
    var title:String = "お買い物"
    var price:String = "$1000"
    var body: some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 20, height: 20)
            Text(title)
                .padding(.leading, 8)
            Spacer()
            Text(price)
        }
        .foregroundColor(.white.opacity(0.75))
        .padding(.horizontal,20)
    }
}
