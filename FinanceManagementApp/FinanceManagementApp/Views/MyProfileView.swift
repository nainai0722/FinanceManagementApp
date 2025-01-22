//
//  MyProfileView.swift
//  FinanceManagementApp
//
//  Created by 指原奈々 on 2025/01/22.
//

import SwiftUI

struct MyProfileView: View {
    private let padding:CGFloat = 20
    @Environment(\.presentationMode) var presentationMode:Binding<PresentationMode>
    @State private var isAnimating = false

    var body: some View {
        ZStack(){
            RoundedRectangle(cornerRadius: 0)
                .fill(Color(red: 60/255, green: 80/255, blue: 140/255))
                .ignoresSafeArea(edges: .all)
            VStack{
                HStack {
                    Image(systemName: "arrow.left")
                        .onTapGesture {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    Spacer()
                    Text("私の情報")
                        .titleLabel()
                    Spacer()
                }
                .padding([.leading,.trailing,.bottom], padding)
                .foregroundColor(.white)
                .opacity(isAnimating ? 1 : 0)
                .animation(.spring().delay(0), value: isAnimating)
                
                VStack(spacing:10){
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .font(.system(size: 40))
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0.1), value: isAnimating)
                    
                    Text("山田　太郎")
                        .bold(true)
                        .font(.system(size: 20))
                        .padding(.top,15)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0.2), value: isAnimating)
                    
                    Text("taroyamada@email.com")
                        .foregroundColor(.gray)
                        .font(.system(size: 13))
                        .padding(.bottom, 20)
                        .opacity(isAnimating ? 1 : 0)
                        .animation(.spring().delay(0.3), value: isAnimating)
                }
                .foregroundColor(.white)
                
                ScrollView{
                    VStack(spacing:0){
                        ProfileRow()
                        ProfileRow(title: "私の財布", icon: "alarm")
                        ProfileRow(title: "レポート", icon: "doc.text")
                        ProfileRow(title: "アカウント設定", icon: "gear")
                        ProfileRow(title: "サインアウト", icon: "figure.walk")
                    }
                    .opacity(isAnimating ? 1 : 0)
                    .animation(.spring().delay(0.5), value: isAnimating)
                }
            }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .onAppear(){
            isAnimating.toggle()
        }
    }
}

#Preview {
    MyProfileView()
}

struct ProfileRow: View {
    var title = "Go Premium"
    var icon = "Person.crop.circle"
    var body: some View {
        VStack(spacing:0){
            HStack(spacing:20){
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .font(.system(size: 20))
                Text(title)
                Spacer()
                if(title == "Go Premium"){
                    Button(action:{
                        
                    }){
                        ZStack{
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 1)
                                .fill(.orange)
                                .frame(width: 100, height: 40)
                            
                            Text("UPGRADE")
                                .foregroundColor(.orange)
                        }
                    }
                }else{
                    Image(systemName: "chevron.right")
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(.horizontal,20)
            .frame(width: UIScreen.main.bounds.width * 0.85, height: 80)
            .background(Color.white.opacity(0.05))
            
            Rectangle()
                .foregroundColor(.white.opacity(0.15))
                .frame(width: UIScreen.main.bounds.width * 0.85, height: 1)
        }
    }
}
