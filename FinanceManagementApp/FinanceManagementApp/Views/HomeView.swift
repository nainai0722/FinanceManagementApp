//
//  ContentView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/21.
//

import SwiftUI

struct HomeView: View {
    @State var isAnimating:Bool = false
    @State var isAnimating2:Bool = false
    var body: some View {
        NavigationView{
            ZStack(alignment:.bottomTrailing){
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color(red: 60/255, green: 80/255, blue: 140/255))
                    .ignoresSafeArea(edges: .all)

                VStack{
                    TitleView()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0), value: isAnimating)
        
                    DepositAmountView()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0.2), value: isAnimating)
                    
                    ScrollCards()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0.4), value: isAnimating)
                    
                    TransactionHistoryView()
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0.6), value: isAnimating)
                
                }
                FloatPointView()
                    .offset(x: 0, y:isAnimating2 ? 0 : 160)
                    .animation(.easeOut(duration: 0.3 ).delay(1), value: isAnimating2)
            }
        }
        .onAppear(){
            isAnimating.toggle( )
            isAnimating2.toggle( )
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
}

private struct TitleView: View {
    @State var isAnimating:Bool = false
    var body: some View {
        HStack{
            NavigationLink(destination: CategoriesGridView()){
                Image(systemName: "list.bullet.indent")
                    .font(.system(size: 20))
            }
            Spacer()
            Text("Finance")
                .bold()
                .font(.system(size: 24))
            Spacer()
            Image(systemName: "bell")
                .font(.system(size: 20))
        }
        .padding(.horizontal,20)
        .foregroundColor(.white)
    }
}

struct DepositAmountView: View {
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text("預金額")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                Text("120,000,000円")
                    .bold()
                    .font(.system(size: 18))
            }
            Spacer()
            
            NavigationLink(destination: MyProfileView()){
                Image(systemName: "person.circle")
                    .font(.system(size: 30))
            }
        }
        .foregroundColor(.white)
        .padding(.top, 10)
        .padding(.horizontal, 20)
    }
}

enum CardType:String{
    case VISA = "VISA"
    case MASTERCARD = "MASTERCARD"
}

struct HorizontalCardView: View {
    var bgColor: Color = .orange
    var cardType:CardType = .VISA
    var cardNo:String = "1234   2345   3456   3456"
    var name:String = "人の名前"
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(bgColor)
                .frame(width:UIScreen.main.bounds.width - 80, height: UIScreen.main.bounds.height * 0.25)
            
            VStack(alignment:.leading) {
                VStack(alignment:.leading) {
                    Text(cardType.rawValue)
                        .padding(.top, 15)
                        .font(.system(size: 20))
                        .bold()
                        .italic()
                    Text(cardNo)
                        .padding(.top, 20)
                }
                .padding(.horizontal, 40)
                
                Spacer()
                
                HStack{
                    VStack(alignment:.leading){
                        Text("Name")
                        Text(name)
                    }
                    .padding(.vertical, 15)
                    
                    Spacer()
                    VStack(alignment:.leading){
                        Text("有効期限")
                        Text("25/2/10")
                    }
                    .padding(.vertical, 15)
                }
                .font(.system(size: 14))
                .padding(.horizontal, 40)
                .padding(.bottom, 15)
            }
            .frame(width:UIScreen.main.bounds.width - 50, height: UIScreen.main.bounds.height * 0.25)
            .foregroundColor(.white)
        }
    }
}

struct ScrollCards: View {
    @State var pageNumber = 2
    @State var previousOffset: CGSize = CGSize(width: 0, height: 0)
    @State var offset:CGSize = CGSize(width: 0, height: 0)
    @State private var isAnimating = false
    var body: some View {
        let dragGesture = DragGesture()
            .onChanged{(value) in
                self.offset.width = self.previousOffset.width + value.translation.width
            }
            .onEnded { value in
                if (abs(value.translation.width) < 50) {
                    self.offset.width = self.previousOffset.width
                }
                else{
                    if value.translation.width > 0 && self.pageNumber > 1{
                        self.previousOffset.width += UIScreen.main.bounds.width - 80
                        self.pageNumber -= 1
                        
                        self.offset.width = self.previousOffset.width
                    } else if value.translation.width < 0 && self.pageNumber < 3 {
                        self.previousOffset.width -= UIScreen.main.bounds.width - 80
                        self.pageNumber += 1
                        
                        self.offset.width = self.previousOffset.width
                    }else{
                        self.offset.width = self.previousOffset.width
                    }
                }
            }
        return VStack {
            HStack(spacing: 0){
                
                HorizontalCardView(bgColor: .purple)
                    .scaleEffect(self.pageNumber == 1 ? 1 : 0.90)
                HorizontalCardView()
                    .scaleEffect(self.pageNumber == 2 ? 1 : 0.90)
                HorizontalCardView(bgColor: .green)
                    .scaleEffect(self.pageNumber == 3 ? 1 : 0.90)
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.bottom,10)
            .offset(x: offset.width, y:0)
            .gesture(dragGesture)
            .animation(.interpolatingSpring(stiffness: 100, damping: 10), value: isAnimating)
            
            HStack{
                Circle()
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .opacity(self.pageNumber == 1 ? 0.8 : 0.2)
                Circle()
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .opacity(self.pageNumber == 2 ? 0.8 : 0.2)
                Circle()
                    .fill(.white)
                    .frame(width: 10, height: 10)
                    .opacity(self.pageNumber == 3 ? 0.8 : 0.2)
            }
        }
    }
}

struct TransactionRow: View {
    var title = "Home Loan"
    var subTitle = "2025/10/01"
    var price = "1244円"
    var body: some View {
        NavigationLink(destination: ReportsView()){
            HStack{
                VStack(alignment: .leading, spacing: 10){
                    Text(title)
                        .font(.system(size: 20))
                    Text(subTitle)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(price)
                    .bold(true)
                    .font(.system(size: 16))
                    .padding(.trailing,20)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white.opacity(0.04))
            .cornerRadius(5)
        }
    }
}

struct TransactionHistoryView: View {
    var body: some View {
        VStack(alignment:.leading) {
            Text("過去の取引履歴")
                .font(.system(size: 18))
                .padding(.leading,20)
            ScrollView{
                VStack(alignment: .leading){
                    ForEach(0..<10){ _ in
                        TransactionRow()
                    }
                }
            }
        }
    }
}

struct FloatPointView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack(){
                    Circle()
                        .fill(Color(red: 81/255, green: 91/255, blue: 251/255))
                        .frame(width: 60, height: 60)
                    NavigationLink(destination: AddIncomeView()){
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing,20)
                .padding(.bottom,20)
                .shadow(radius: 10)
            }
        }
    }
}
