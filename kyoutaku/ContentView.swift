//
//  ContentView.swift
//  kyoutaku
//
//  Created by k18004kk on 2021/03/17.
//  Copyright © 2021 AIT. All rights reserved.
//
import SwiftUI
import FirebaseAuth
import Firebase

class ViewModel: ObservableObject {
    @Published var isServicePlayer = false
    @Published var isNetPosition = false
    
    @Published var PlayCount: Int = 0
    
}



struct ContentView: View {
    var body: some View {

        NavigationView {
            VStack(alignment: .center, spacing: 90) {
                Text("競卓").font(.custom("HiraMinProN-W6", size: 100))

                HStack(spacing: 30) {
                    NavigationLink(destination: SiaiItiranView()) {
                        Text("試合一覧").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                    }
                    NavigationLink(destination: SiaiTourokuView()) {
                        Text("試合登録").font(.title).frame(width: 200, height: 80).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    }
                }
                
                HStack(spacing: 30) {
                    NavigationLink(destination: SecondView()) {
                        Text("動画解析").font(.title).frame(width: 200, height: 80).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    }
                
                    NavigationLink(destination: SecondView()) {
                    Text("チームに共有").font(.title).frame(width: 200, height: 80).overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1))
                    }
                }
                
                HStack(spacing: 30){
                    NavigationLink(destination: SecondView()) {
                        Text("WEBKyotaku").font(.title).frame(width: 200, height: 80).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    }
                    
                    NavigationLink(destination: AuthTestSignInView()) {
                        Text("ログイン").font(.title).frame(width: 200, height: 80).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    }
                
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SecondView: View {
    var body: some View {
        Text("画面遷移できました")
    }
}



struct SiaiItiranView: View {
    var body: some View {
        List {
            Text("試合1").font(.largeTitle)
            Text("試合2").font(.largeTitle)
            Text("試合3").font(.largeTitle)
        }
    }
}



struct SiaiTourokuView: View {
    //最初のサービス権
    @State private var isCheckedS = false
    //ダブルスのレシーブ権
    @State private var isCheckedR = false
    //シングルかダブルス
    @State private var SinglesOrDoubles = true
    //データモデル(サービス交代)
    @EnvironmentObject var vm : ViewModel
    //選手一覧
    @State private var ArrayPlayer = [String]()
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    
    //選手選択
    @State private var SelectionPlayer1 = -1
    @State private var SelectionPlayer2 = -1
    @State private var SelectionPlayer3 = -1
    @State private var SelectionPlayer4 = -1
    //pickerが表示されているか
    @State private var isShowingPicker1 = false
    @State private var isShowingPicker2 = false
    @State private var isShowingPicker3 = false
    @State private var isShowingPicker4 = false

//    @State private var selectedIndex = 0
    var body: some View {
        
        VStack(){
            Button(action: {
                SinglesOrDoubles.toggle()
            }) {
                if(SinglesOrDoubles){
                    Text("シングルス")
                        .font(.largeTitle)
                        
                }else{
                    Text("ダブルス")
                        .font(.largeTitle)
                        
                }

            }
            
            HStack{
                Spacer()
                Text("サービス　")
                    .font(.headline)
            }
            
            HStack{
                Text("選手1:").font(.largeTitle).padding(20)
                Button(action: {
                    if ArrayPlayer.isEmpty{
                        kyotakuVM.users.forEach() { user in
                            ArrayPlayer.append(user.player_name)
                        }
                    }
                
                    self.isShowingPicker1.toggle()
                    self.isShowingPicker2 = false
                    self.isShowingPicker3 = false
                    self.isShowingPicker4 = false
                }) {
                    if(SelectionPlayer1 == -1){
                        Text("選手を選択")
                            .padding()
                            .font(.largeTitle)
                    }else{
                        Text("\(ArrayPlayer[self.SelectionPlayer1])")
                                .padding()
                                .font(.largeTitle)
                    }
                }
                Spacer()
                Button(action: toggleS) {
                            if(!isCheckedS) {
                                Image(systemName: "checkmark.square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .leading)
                            .foregroundColor(.green)
                            } else {
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .leading)
                            }
                }.padding(20)
                
            }
            
            HStack{

                Text("選手2:").font(.largeTitle).padding(20)
                
                Button(action: {
                    if ArrayPlayer.isEmpty {
                        kyotakuVM.users.forEach() { user in
                            ArrayPlayer.append(user.player_name)
                        }
                    }
                    self.isShowingPicker1 = false
                    self.isShowingPicker2.toggle()
                    self.isShowingPicker3 = false
                    self.isShowingPicker4 = false
                }) {
                    if(SelectionPlayer2 == -1){
                        Text("選手を選択")
                            .padding()
                            .font(.largeTitle)
                    }else{
                        Text("\(ArrayPlayer[self.SelectionPlayer2])")
                                .padding()
                                .font(.largeTitle)
                    }

                        
                }
//                TextField("選手名", text: $name2)
//                    .frame(width: 500, height: 50, alignment: .center)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
//                    .font(.largeTitle)
//                    .padding()
                    
                Spacer()
                Button(action: toggleS) {
                            if(isCheckedS) {
                                Image(systemName: "checkmark.square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.green)
                            } else {
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            }
                }.padding(20)
                
                
            }.onAppear(){
                self.kyotakuVM.fetchData()
                
           }
            
            if(!SinglesOrDoubles){
                HStack{
                    Spacer()
                    Text("レシーブ　")
                        .font(.headline)
                }
                HStack{

                    Text("選手3:").font(.largeTitle).padding(20)
                    
                    Button(action: {
                        if ArrayPlayer.isEmpty {
                            kyotakuVM.users.forEach() { user in
                                ArrayPlayer.append(user.player_name)
                            }
                        }
                        self.isShowingPicker1 = false
                        self.isShowingPicker2 = false
                        self.isShowingPicker3.toggle()
                        self.isShowingPicker4 = false
                    }) {
                        if(SelectionPlayer3 == -1){
                            Text("選手を選択")
                                .padding()
                                .font(.largeTitle)
                        }else{
                            Text("\(ArrayPlayer[self.SelectionPlayer3])")
                                    .padding()
                                    .font(.largeTitle)
                        }

                            
                    }

                        
                    Spacer()
                    Button(action: toggleR) {
                                if(!isCheckedR) {
                                    Image(systemName: "checkmark.square.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(.green)
                                } else {
                                    Image(systemName: "square")
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                }
                    }.padding(20)
                }
                HStack{

                    Text("選手4:").font(.largeTitle).padding(20)
                    
                    Button(action: {
                        if ArrayPlayer.isEmpty{
                            kyotakuVM.users.forEach() { user in
                                ArrayPlayer.append(user.player_name)
                            }
                        }
                        self.isShowingPicker1 = false
                        self.isShowingPicker2 = false
                        self.isShowingPicker3 = false
                        self.isShowingPicker4.toggle()
                    }) {
                        if(SelectionPlayer4 == -1){
                            Text("選手を選択")
                                .padding()
                                .font(.largeTitle)
                        }else{
                            Text("\(ArrayPlayer[self.SelectionPlayer4])")
                                    .padding()
                                    .font(.largeTitle)
                        }

                            
                    }

                        
                    Spacer()
                    Button(action: toggleR) {
                                if(isCheckedR) {
                                    Image(systemName: "checkmark.square.fill")
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                .foregroundColor(.green)
                                } else {
                                    Image(systemName: "square")
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .center)
                                }
                    }.padding(20)
                    
                }
            }
////////////////////////////////////////////////////////////////////
//Xcode12.5にてバグ発生(NavigationLinkを二つ使うと画面遷移がうまくいかない)//
////////////////////////////////////////////////////////////////////
            
            HStack {
                NavigationLink(destination: TourokuView()) {
                    Text("　　＊新たな選手を登録する").font(.title)
                                                .underline()
                }
                Spacer()
            }
            //バグ回避用(消したい;;
            NavigationLink(destination: SyozokuTourokuView()) {
                Text("").font(.title)
                                            .underline()
            }
            if(SelectionPlayer1 != -1 && SelectionPlayer2 != -1){
                NavigationLink(destination: MatchView1(Count: 0, Player1: ArrayPlayer[self.SelectionPlayer1], Player2: ArrayPlayer[self.SelectionPlayer2])) {
                    Text("登録").font(.title).frame(width: 200, height: 80).overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1))

                }.simultaneousGesture(TapGesture().onEnded{
                    print("Hello world!")
                })
            }
            
            
            ZStack{
                PlayerNamePicker(selection: self.$SelectionPlayer1, isShowing: self.$isShowingPicker1, NameArray: self.$ArrayPlayer)
                    .offset(y: self.isShowingPicker1 ? CGFloat(0) : UIScreen.main.bounds.height)
                
                PlayerNamePicker(selection: self.$SelectionPlayer2, isShowing: self.$isShowingPicker2, NameArray: self.$ArrayPlayer)
                    .offset(y: self.isShowingPicker2 ? CGFloat(0) : UIScreen.main.bounds.height)
                
                PlayerNamePicker(selection: self.$SelectionPlayer3, isShowing: self.$isShowingPicker3, NameArray: self.$ArrayPlayer)
                    .offset(y: self.isShowingPicker3 ? CGFloat(0) : UIScreen.main.bounds.height)
                
                PlayerNamePicker(selection: self.$SelectionPlayer4, isShowing: self.$isShowingPicker4, NameArray: self.$ArrayPlayer)
                    .offset(y: self.isShowingPicker4 ? CGFloat(0) : UIScreen.main.bounds.height)
            }

        }
    }
    
    // タップ時の状態の切り替え
    func toggleS() -> Void {
        isCheckedS = !isCheckedS
        vm.isServicePlayer = isCheckedS
        UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
    }
    // タップ時の状態の切り替え
    func toggleR() -> Void {
        isCheckedR = !isCheckedR
//        vm.isServicePlayer = isCheckedS
        UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
    }
}

//サービス画面
struct MatchView1: View {
    
    @State var array = ["横回転","縦回転","YG","バックハンド","巻き込み","しゃがみ込み"]
    
    @State var selsectBattingMethod = 0
    @State var selsectCourse = 0
    
    @State private var isCheckSelect1 = false
    @State private var isCheckSelect2 = false
    
    @EnvironmentObject var vm : ViewModel
    
    @State var Count: Int
    
    @State var Player1: String
    @State var Player2: String
    
    
    var body: some View {
            
            VStack(spacing: 5){

                HStack{
                    Spacer()
                    Spacer()
                    Button(action: {
                        vm.isServicePlayer.toggle()
                        vm.isNetPosition.toggle()
                    }) {
                        Text("サービス交代").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                            .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                        .cornerRadius(10)
                        .padding(10)
                    }
                    
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    NavigationLink(destination: Timeout()) {
                        Text("タイムアウト").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                            .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                        .cornerRadius(10)
                        .padding(10)
                    }
                    Spacer()
                    Spacer()
                }
                
                //打法
                LazyVGrid(columns: Array(repeating: .init(.fixed(200)), count: 3), alignment: .center, spacing:10) { // カラム数の指定
                    ForEach((1...6), id: \.self) { index in
                        
                        Button(action: {
                            selsectBattingMethod = index
                            self.isCheckSelect1 = true
                        }) {
                            Text(array[index - 1]).font(.title)
                                .foregroundColor(selsectBattingMethod == index ?  Color(red: 1, green: 1, blue: 1, opacity:0.4) : Color(red: 1, green: 1, blue: 1, opacity:1))
                                
                                .frame(width: 180, height: 70).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                                .background(Color(red: 0.246, green: 0.5, blue: 0.992))
                                .cornerRadius(10)
                                .padding()
                        }
                        
                    }
                }
            
                HStack{
                    Spacer()
                    Button(action: {
                        vm.isNetPosition.toggle()
                    }) {
                        
                        Text("コート反転").font(.title)
                            .foregroundColor(.white)
                            .frame(width: 230, height: 50).overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                            .background(Color(red: 0.191, green: 0.468, blue: 0.453))
                            .cornerRadius(10)
                            
                    }
                    Text("プレイ数:\(Count)")
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                        
                }
            
                HStack{
                    Spacer()
                    if(vm.isServicePlayer){
                        Text("0 \(Player2): 　　　　").font(.title)
                            .padding()
                    }else{
                        Text("0 \(Player2): サービス").font(.title)
                            .padding()
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                ZStack{
                    //コース
                    LazyVGrid(columns: Array(repeating: .init(.fixed(170)), count: 3), alignment: .center, spacing:5) {

                        // カラム数の指定
                        ForEach((1...9), id: \.self) { index in
                            
                            Button(action: {
                                selsectCourse = index
                                self.isCheckSelect2 = true
                                
                            }) {
                                Text("").frame(width: 170, height: 105, alignment: .center)
                                    .border(Color.black , width: 1)
                            }
                            .background(selsectCourse == index ?  Color(red: 0.3125, green: 0.664, blue: 0.613) : Color(red: 0.191, green: 0.468, blue: 0.453))
                            
                        }

                    }
                    
                    if(!vm.isNetPosition){
                        VStack{
                            Image("net").rotationEffect(Angle(degrees: 180))
                            Spacer()
                        }
                    }else{
                        VStack{
                            Spacer()
                            Image("net")
                        }
                    }
                }
               


                HStack{
                    Spacer()
                    if(vm.isServicePlayer){

                        Text("0 \(Player1): サービス").font(.title)
                            .padding()
                    }else{
                        Text("0 \(Player1): 　　　　").font(.title)
                            .padding()
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        selsectCourse = 10
                        self.isCheckSelect2 = true
                    }) {
                        Text("ミス").font(.title)
                            .foregroundColor(.white)
                            .frame(width: 160, height: 70, alignment: .center)
                    }
                    .background(selsectCourse == 10 ?  Color(red: 0.3125, green: 0.664, blue: 0.613) : Color(red: 0.191, green: 0.468, blue: 0.453))
                    
                    
                    Spacer()
                }
                HStack{
                    NavigationLink(destination: MatchReceiveView(count: Count, Player1: Player1, Player2: Player2)) {
                            
                        Text("確定").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))
                        .background(isCheckSelect1 && isCheckSelect2 ? Color(red: 0.917, green: 0.25, blue: 0.468) : Color(red: 0.87, green: 0.87, blue: 0.89))
                        .cornerRadius(10)
                        .padding()
                        
                    }.disabled(!isCheckSelect1 && !isCheckSelect2)

                }
            }
            .onWillAppear {
                vm.isServicePlayer.toggle()
                if(Count != 0 && Count % 2 == 0){
                    vm.isServicePlayer.toggle()
                }
            }
            
            .navigationBarTitle(vm.isServicePlayer ? "\(Player1)サービス" : "\(Player2)サービス", displayMode: .inline)
            .navigationBarItems(trailing:
                    Button(action: {

                    }) {
                        NavigationLink(destination: ScoreView(Player1: Player1, Player2: Player2)) {
                            Text("スコアシート")
                        }
                        
                    }
            )
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
        
    
    }

}
//レシーブ画面
struct MatchReceiveView: View {
    @State var array = ["チキータ","フリック","ストップ","ツッツキ","流し","ドライブ(強)","ドライブ(弱)","カット","逆チキータ"]
    
    @State var selsectBattingMethod = 0
    @State var selsectCourse = 0
    
    @State private var isCheckSelect1 = false
    @State private var isCheckSelect2 = false
    
    @State private var rallyCount = 1
    
    @EnvironmentObject var vm : ViewModel
    
    @State var count: Int
    @State var Player1: String
    @State var Player2: String
    
    var body: some View {
        
            VStack(spacing: 5){
                
                //打法
                LazyVGrid(columns: Array(repeating: .init(.fixed(200)), count: 3), alignment: .center, spacing:10) { // カラム数の指定
                    ForEach((1...9), id: \.self) { index in
                        
                        Button(action: {
                            selsectBattingMethod = index
                            self.isCheckSelect1 = true
                        }) {
                            Text(array[index - 1]).font(.title)
                                .foregroundColor(selsectBattingMethod == index ?  Color(red: 1, green: 1, blue: 1, opacity:0.4) : Color(red: 1, green: 1, blue: 1, opacity:1))
                                
                                .frame(width: 180, height: 70).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                                .background(Color(red: 0.246, green: 0.5, blue: 0.992))
                                .cornerRadius(10)
                                .padding()
                        }
                        
                    }
                }

                
                HStack{
                    Spacer()
                    Button(action: {

                    }) {
                        Text("コート反転").font(.title)
                            .foregroundColor(.white)
                            .frame(width: 230, height: 50).overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1))
                            .background(Color(red: 0.191, green: 0.468, blue: 0.453))
                            .cornerRadius(10)
                            
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                        
                }
                
                ZStack{
                    //コース
                    LazyVGrid(columns: Array(repeating: .init(.fixed(170)), count: 3), alignment: .center, spacing:5) {

                        // カラム数の指定
                        ForEach((1...9), id: \.self) { index in
                            
                            Button(action: {
                                selsectCourse = index
                                self.isCheckSelect2 = true
                            }) {
                                Text("").frame(width: 170, height: 105, alignment: .center)
                                    .border(Color.black , width: 1)
                            }
                            .background(selsectCourse == index ?  Color(red: 0.3125, green: 0.664, blue: 0.613) : Color(red: 0.191, green: 0.468, blue: 0.453))
                            
                        }

                    }
                    if(vm.isNetPosition){
                        VStack{
                            Image("net").rotationEffect(Angle(degrees: 180)).offset(x: 0, y: 30)
                            Spacer()
                        }
                    }else{
                        VStack{
                            Spacer()
                            Image("net").offset(x: 0, y: -30)
                        }
                    }
                }
                
                HStack{
                    Spacer()
                    Text("ラリー回数:").font(.largeTitle)
                        .foregroundColor(.blue)
                    TextField("", value: $rallyCount, formatter: NumberFormatter())
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 200, height: 50)
                    Spacer()
                    Spacer()

                }
                
                HStack{

                    NavigationLink(destination: MatchView1(Count: count + 1, Player1: Player1, Player2: Player2)) {
                        
                        Text("\(Player1)Point").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                            .background(isCheckSelect1 && isCheckSelect2 ? Color(red: 0.917, green: 0.25, blue: 0.468) : Color(red: 0.87, green: 0.87, blue: 0.89))
                        .cornerRadius(10)
                        .padding()
                    }.disabled(!isCheckSelect1 && !isCheckSelect2)

                    
                    
                    NavigationLink(destination: MatchView1(Count: count + 1, Player1: Player1, Player2: Player2)) {
                        Text("\(Player2)Point").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                            .background(isCheckSelect1 && isCheckSelect2 ? Color(red: 0.246, green: 0.5, blue: 0.992) : Color(red: 0.87, green: 0.87, blue: 0.89))
                        .cornerRadius(10)
                        .padding()
                    }.disabled(!isCheckSelect1 && !isCheckSelect2)

                }
                
                
                }
                .onDisappear{
                    vm.isServicePlayer.toggle()
                }
            
            .navigationBarTitle(vm.isServicePlayer ? "\(Player2)レシーブ" : "\(Player1)レシーブ", displayMode: .inline)
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
}

struct Timeout: View {
    var body: some View {
        VStack(spacing: 15){
            Text("タイムアウトView")
        }
    }
}


struct ScoreView: View {
    @EnvironmentObject var vm : ViewModel
    @State var Player1: String
    @State var Player2: String
    
    var body: some View {
        HStack{
            Text("\(Player1)サービス時の攻撃パターン").font(.largeTitle)
                .padding()
            Spacer()
        }.onDisappear{
            vm.isServicePlayer.toggle()
        }
        ZStack{
            HStack{
                Spacer()
                Image("coat").resizable()
                    .frame(width: 204, height: 240)
                Spacer()
                Image("coat").resizable()
                    .frame(width: 204, height: 240)
                Spacer()
                Image("coat").resizable()
                    .frame(width: 204, height: 240)
                Spacer()
                
            }
//            PathView()
            Spacer()

        }
        
        HStack{
            Spacer()
            Text("->").font(.title)
            Spacer()
            Spacer()
            Text("->").font(.title)
            Spacer()
            Spacer()
            Text("->").font(.title)
            Spacer()
        }
        HStack{
            Spacer()
            Text("(0/0)").font(.title)
            Spacer()
            Spacer()
            Text("(0/0)").font(.title)
            Spacer()
            Spacer()
            Text("(0/0)").font(.title)
            Spacer()
        }
        
        HStack{
            Text("\(Player1)レシーブ時の攻撃パターン").font(.largeTitle)
                .padding()
            Spacer()
        }
        
        HStack{
            Spacer()
            Image("coat").resizable()
                .frame(width: 204, height: 240)
            Spacer()
            Image("coat").resizable()
                .frame(width: 204, height: 240)
            Spacer()
            Image("coat").resizable()
                .frame(width: 204, height: 240)
            Spacer()
        }
        
        HStack{
            Spacer()
            Text("->").font(.title)
            Spacer()
            Spacer()
            Text("->").font(.title)
            Spacer()
            Spacer()
            Text("->").font(.title)
            Spacer()
        }
        HStack{
            Spacer()
            Text("(0/0)").font(.title)
            Spacer()
            Spacer()
            Text("(0/0)").font(.title)
            Spacer()
            Spacer()
            Text("(0/0)").font(.title)
            Spacer()
        }
        
        HStack{
            NavigationLink(destination: MatchView1(Count: vm.PlayCount, Player1: Player1, Player2: Player2)) {
                Text("NEXT GAME").font(.title)
                .foregroundColor(.white)
                .frame(width: 180, height: 70).overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2))
                    .background(Color(red: 0.87, green: 0.87, blue: 0.89))
                .cornerRadius(10)
                .padding()
            }
            NavigationLink(destination: MatchView1(Count: vm.PlayCount, Player1: Player1, Player2: Player2)) {
                Text("GAME SET").font(.title)
                .foregroundColor(.white)
                .frame(width: 180, height: 70).overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2))
                    .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                .cornerRadius(10)
                .padding()
            }
        }
        Spacer()
    }
}

struct coatView: View {
    @EnvironmentObject var vm : ViewModel
    
    var body: some View {
        VStack{
            Image("coat").resizable()
        }
    }
}

struct PathView: View {
    @EnvironmentObject var vm : ViewModel
    
    var body: some View {
        
        Path { path in
            path.move(to: CGPoint(x: 15, y: 0))        // 始点移動
            path.addLine(to: CGPoint(x: 30, y: 35))     // 直線描画
            path.addLine(to: CGPoint(x: 0, y: 35))
            path.addLine(to: CGPoint(x: 15, y: 0))
            
//            path.move(to: CGPoint(x: 13, y: 35))        // 始点移動
//            if(vm.CheckS[0][1] == 1 || vm.CheckS[0][1] == 2 || vm.CheckS[0][1] == 3){
//                path.addLine(to: CGPoint(x: 13, y: 230))
//                path.addLine(to: CGPoint(x: 17, y: 230))
//            }else if(vm.CheckS[0][1] == 4 || vm.CheckS[0][1] == 5 || vm.CheckS[0][1] == 6){
//                path.addLine(to: CGPoint(x: 13, y: 195))
//                path.addLine(to: CGPoint(x: 17, y: 195))
//            }
//            else if(vm.CheckS[0][1] == 7 || vm.CheckS[0][1] == 8 || vm.CheckS[0][1] == 9){
//                path.addLine(to: CGPoint(x: 13, y: 160))
//                path.addLine(to: CGPoint(x: 17, y: 160))
//            }
            
            path.addLine(to: CGPoint(x: 17, y: 35))
            path.addLine(to: CGPoint(x: 13, y: 35))

            
        }.fill(Color(red: 0.917, green: 0.25, blue: 0.468))// 塗りつぶし色指定
        .frame(width: 30, height: 230)
        
        Path { path in
            path.move(to: CGPoint(x: 45, y: 0))        // 始点移動
            path.addLine(to: CGPoint(x: 60, y: 35))     // 直線描画
            path.addLine(to: CGPoint(x: 30, y: 35))
            path.addLine(to: CGPoint(x: 45, y: 0))
            
//            path.move(to: CGPoint(x: 43, y: 35))        // 始点移動
//            if(vm.CheckR[0][1] == 1 || vm.CheckR[0][1] == 2 || vm.CheckR[0][1] == 3){
//                path.addLine(to: CGPoint(x: 43, y: 230))
//                path.addLine(to: CGPoint(x: 47, y: 230))
//            }else if(vm.CheckR[0][1] == 4 || vm.CheckR[0][1] == 5 || vm.CheckR[0][1] == 6){
//                path.addLine(to: CGPoint(x: 43, y: 195))
//                path.addLine(to: CGPoint(x: 47, y: 195))
//            }
//            else if(vm.CheckR[0][1] == 7 || vm.CheckR[0][1] == 8 || vm.CheckR[0][1] == 9){
//                path.addLine(to: CGPoint(x: 43, y: 160))
//                path.addLine(to: CGPoint(x: 47, y: 160))
//            }
            
            path.addLine(to: CGPoint(x: 47, y: 35))
            path.addLine(to: CGPoint(x: 43, y: 35))

            
        }.fill(Color(red: 0.5, green: 0.25, blue: 0.468))// 塗りつぶし色指定
        .frame(width: 30, height: 230)
        
        VStack{
//            Text("\(vm.CheckS[vm.PlayCount][0]):\(vm.CheckS[vm.PlayCount][1])")
//            Text("\(vm.CheckR[vm.PlayCount][0]):\(vm.CheckR[vm.PlayCount][1])")
            Text("\(vm.PlayCount)")
        }
        
    }
}

struct TourokuView: View {
    @State private var name = ""
    @State private var group = ""
    
    @State private var groupArray = ["","","",""]
    @State private var addgroupSum = 1
    
    @State var HandednessArray = ["左利き","右利き"]
    @State var SelectHandedness = 1

    @State var RubberArray = ["表表","表裏","裏表","裏裏"]
    @State private var SelectionRubber = 3
    @State private var isShowingPicker = false
    
    //所属一覧
    @State private var ArrayGroup = [String]()
    
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    
    //所属選択
    
    @State private var SelectionGroupArray = [-1,-2,-3,-4]
    
    //pickerが表示されているか
    @State private var isShowingPicker1 = false
    @State private var isShowingPicker2 = false
    @State private var isShowingPicker3 = false
    @State private var isShowingPicker4 = false
    
    //アラートフラグ
    @State private var showingAlert1 = false
    @State private var showingAlert2 = false
    
    var body: some View {
        HStack{
            Text("　　選手名:").font(.largeTitle).padding(20)
            TextField("選手名", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
            .font(.largeTitle)
            Spacer()
            
        }

        VStack{
        //カラム数の指定
            ForEach((0...addgroupSum - 1), id: \.self) { index in
                HStack{
                    if(index == 0){
                        Text("所属団体名:").font(.largeTitle).padding(20)
                    }else{
                        Text("　　　　　 ").font(.largeTitle).padding(20)
                    }
                    
                    Button(action: {
                        //まだ読み込まれてないなら
                        if ArrayGroup.isEmpty{
                            kyotakuVM.groups.forEach() { groups in
                                ArrayGroup.append(groups.group)
                            }
                        }
                        if(index == 0){
                            self.isShowingPicker1.toggle()
                            self.isShowingPicker2 = false
                            self.isShowingPicker3 = false
                            self.isShowingPicker4 = false
                        }else if(index == 1){
                            self.isShowingPicker1 = false
                            self.isShowingPicker2.toggle()
                            self.isShowingPicker3 = false
                            self.isShowingPicker4 = false
                        }else if(index == 2){
                            self.isShowingPicker1 = false
                            self.isShowingPicker2 = false
                            self.isShowingPicker3.toggle()
                            self.isShowingPicker4 = false
                        }else if(index == 3){
                            self.isShowingPicker1 = false
                            self.isShowingPicker2 = false
                            self.isShowingPicker3 = false
                            self.isShowingPicker4.toggle()
                        }
                        

                    }) {
                        if(SelectionGroupArray[index] < 0){
                            Text("所属を選択")
                                .padding()
                                .font(.largeTitle)
                        }else{
                            Text("\(ArrayGroup[SelectionGroupArray[index]])")
                                    .padding()
                                    .font(.largeTitle)
                        }
                    }
//                    TextField("所属団体名", text: $groupArray[index])
//                        .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
//                    .font(.largeTitle)
                    if(index == addgroupSum - 1){
                        if(addgroupSum != 4 && SelectionGroupArray[addgroupSum - 1] >= 0){
                            Button(action: {
                                addgroupSum += 1
                            }) {
                                Text("＋").font(.title)
                            }
                        }

                        if(index != 0){
                            Button(action: {
                                SelectionGroupArray[addgroupSum - 1] = -1 * addgroupSum
                                addgroupSum -= 1
                            }) {
                                Text("-").font(.title)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }.onAppear(){
            self.kyotakuVM.fetchData1()
            
        }.alert(isPresented: $showingAlert1) {
            Alert(title: Text("保存の失敗"),
                  message: Text("重複した所属が選択されています"),
                  dismissButton: .default(Text("了解")))  // ボタンの変更
        }
        HStack {
            NavigationLink(destination: SyozokuTourokuView()) {
                Text("　　　　＊新たな所属団体を登録する").font(.title)
                                            .underline()
            }
            Spacer()
        }.alert(isPresented: $showingAlert2) {
            Alert(title: Text("保存しました"),
                  dismissButton: .default(Text("了解")))  // ボタンの変更
        }
        //バグ回避用(消したい;;
        NavigationLink(destination: SyozokuTourokuView()) {
            Text("").font(.title)
                                        .underline()
        }
        HStack{
            Text("   　　利き手:").font(.largeTitle).padding(20)
            
            HStack{
                // カラム数の指定
                ForEach((1...2), id: \.self) { index in
                    
                        Spacer()
                        Button(action: {
                            SelectHandedness = index
                        }) {
                            if(SelectHandedness == index) {
                                Image(systemName: "checkmark.square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            .foregroundColor(.green)
                            } else {
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                            }
                        }
                        Text(HandednessArray[index - 1]).font(.title)
                                                .foregroundColor(Color(red: 0, green: 0, blue: 0, opacity:1))
                        .frame(width: 180, height: 70)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                
            }
        }
        HStack{
            Text("    　　戦型:").font(.largeTitle).padding(20)
            
            Button(action: {
                self.isShowingPicker.toggle()
            }) {
                Text("\(RubberArray[self.SelectionRubber])")
                        .font(.largeTitle)
                    
            }
            
            Spacer()
                        
        }
        Button(action: {
            for i in 0..<SelectionGroupArray.count{
                for j in i+1..<SelectionGroupArray.count{
                    if(SelectionGroupArray[i] == SelectionGroupArray[j]){
                        self.showingAlert1 = true
                    }
                }
            }
            if (showingAlert1 == false){
                self.showingAlert2 = true
                if(SelectionGroupArray[3] >= 0){
                    self.kyotakuVM.addUserData(handedness: SelectHandedness, player_name: name, rubber: self.SelectionRubber, group1: ArrayGroup[SelectionGroupArray[0]], group2: ArrayGroup[SelectionGroupArray[1]], group3: ArrayGroup[SelectionGroupArray[2]], group4: ArrayGroup[SelectionGroupArray[3]])
                }else if(SelectionGroupArray[2] >= 0){
                    self.kyotakuVM.addUserData(handedness: SelectHandedness, player_name: name, rubber: self.SelectionRubber, group1: ArrayGroup[SelectionGroupArray[0]], group2: ArrayGroup[SelectionGroupArray[1]], group3: ArrayGroup[SelectionGroupArray[2]], group4: "")
                }else if(SelectionGroupArray[1] >= 0){
                    self.kyotakuVM.addUserData(handedness: SelectHandedness, player_name: name, rubber: self.SelectionRubber, group1: ArrayGroup[SelectionGroupArray[0]], group2: ArrayGroup[SelectionGroupArray[1]], group3: "", group4: "")
                }else if(SelectionGroupArray[0] >= 0){
                    self.kyotakuVM.addUserData(handedness: SelectHandedness, player_name: name, rubber: self.SelectionRubber, group1: ArrayGroup[SelectionGroupArray[0]], group2: "", group3: "", group4: "")
                }
            }
        }) {
            Text("登録").font(.title).frame(width: 200, height: 80).overlay(
            RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
        }
        
        VStack{
            ZStack{
            BattleTypePicker(selection: self.$SelectionRubber, isShowing: self.$isShowingPicker)
                        .animation(.linear)
                        .offset(y: self.isShowingPicker ? 0 : UIScreen.main.bounds.height)
            
            GroupNamePicker(selection: self.$SelectionGroupArray[0], isShowing: self.$isShowingPicker1, GroupArray: self.$ArrayGroup)
                .offset(y: self.isShowingPicker1 ? CGFloat(0) : UIScreen.main.bounds.height)

            GroupNamePicker(selection: self.$SelectionGroupArray[1], isShowing: self.$isShowingPicker2, GroupArray: self.$ArrayGroup)
                .offset(y: self.isShowingPicker2 ? CGFloat(0) : UIScreen.main.bounds.height)

            GroupNamePicker(selection: self.$SelectionGroupArray[2], isShowing: self.$isShowingPicker3, GroupArray: self.$ArrayGroup)
                .offset(y: self.isShowingPicker3 ? CGFloat(0) : UIScreen.main.bounds.height)

            GroupNamePicker(selection: self.$SelectionGroupArray[3], isShowing: self.$isShowingPicker4, GroupArray: self.$ArrayGroup)
                .offset(y: self.isShowingPicker4 ? CGFloat(0) : UIScreen.main.bounds.height)
            }
        }

    }
}

struct SyozokuTourokuView: View {
    
    @State private var SetGroup = ""
    @ObservedObject var kyotakuVM = KyotakuViewModel()
    
    var body: some View {
        HStack{
            Text("所属団体名:").font(.largeTitle).padding(20)
            TextField("所属団体名", text: $SetGroup)
                .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
            .font(.largeTitle)
            Spacer()
        }
        NavigationLink(destination: TourokuView()) {
            Text("登録").font(.title).frame(width: 200, height: 80).overlay(
            RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
        }.simultaneousGesture(TapGesture().onEnded{
            self.kyotakuVM.addGroupData(group: SetGroup)
        })
        Spacer()
    }
}

struct BattleTypePicker: View {
    @Binding var selection: Int
    @Binding var isShowing: Bool
    @State var RubberArray = ["表表","表裏","裏表","裏裏"]
    
    var body: some View {
        VStack {
            Spacer()
            Button(action: {
                self.isShowing = false
            }) {
                HStack {
                    Spacer()
                    Text("Close")
                        .padding(.horizontal, 16)
                }
            }
            
            Picker(selection: $selection, label: Text("")) {
                ForEach(0 ..< RubberArray.count) { num in
                        Text(self.RubberArray[num])
                            .font(.title)
                }
            }
            .frame(width: 200)
            .labelsHidden()
        }
    }
}

struct PlayerNamePicker: View {
    @Binding var selection: Int
    @Binding var isShowing: Bool
    @Binding var NameArray: Array<String>
    
    var body: some View {
        VStack {
            
            Spacer()
            Button(action: {
                self.isShowing = false
            }) {
                HStack {
                    Spacer()
                    Text("Close")
                        .padding(.horizontal, 16)
                }
            }
            
            Picker(selection: $selection, label: Text("")) {
                
                ForEach(0 ..< NameArray.count, id: \.self) { num in
                    Text(verbatim: self.NameArray[num])
                        .font(.title)
                }
            }.frame(width: 200)
            .labelsHidden()
        }
    }
}

struct GroupNamePicker: View {
    @Binding var selection: Int
    @Binding var isShowing: Bool
    @Binding var GroupArray: Array<String>
    
    var body: some View {
        VStack {
            
            Spacer()
            Button(action: {
                self.isShowing = false
            }) {
                HStack {
                    Spacer()
                    Text("Close")
                        .padding(.horizontal, 16)
                }
            }
            
            Picker(selection: $selection, label: Text("")) {
                
                ForEach(0 ..< GroupArray.count, id: \.self) { num in
                    Text(verbatim: self.GroupArray[num])
                        .font(.title)
                }
            }.frame(width: 200)
            .labelsHidden()
        }
    }
}

















//以下ログイン機能(現状保留)
struct AuthTestSignInView: View {
    
    @State private var isSignedIn = false
    
    @State private var mailAddress = ""
    @State private var password = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    @State private var isShowSignedOut = false
    
    @State private var isCheckMail = false
    
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            VStack(spacing: 16) {
                if self.isSignedIn {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let email = user.email
                        Text(email! + "\nでログインしています").foregroundColor(.green)
                    }
                    
                    Button(action: {
                        self.signOut()
                        isSignedIn = false
                    }) {
                        Text("ログアウト")
                    }
                    
                    NavigationLink(destination: MemberListView().onDisappear(perform: {
                        self.getCurrentUser()
                    })
                    ) {
                        HStack{
                            Image("human")
                                .resizable()
                                .frame(width: 25, height: 20)
                            Text("メンバー一覧")
                        }
                    }
                    
                } else {
                    Text("ログインしていません").foregroundColor(.gray)
                    
                    TextField("メールアドレス", text: $mailAddress)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.username)
                        .keyboardType(.URL)
                        
                    SecureField("パスワード", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.password)
                    
                    Button(action: {
                        self.errorMessage = ""
                        if self.mailAddress.isEmpty {
                            self.errorMessage = "メールアドレスが入力されていません"
                            self.isError = true
                            self.isShowAlert = true
                        } else if self.password.isEmpty {
                            self.errorMessage = "パスワードが入力されていません"
                            self.isError = true
                            self.isShowAlert = true
                        } else {
                            self.signIn()
                        }
                    }) {
                        Text("Login").font(.title)
                            .frame(width: 300, height: 50)
                            .foregroundColor(.white)
                            .background(Color.blue)
                    }
                    .alert(isPresented: $isShowAlert) {
                        if self.isError {
                            return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK"))
                            )
                        } else {
                            if isCheckMail{
                                return Alert(title: Text(""), message: Text("ログアウトしました"), dismissButton: .default(Text("OK")))
                            }else{
                                return Alert(title: Text(""), message: Text("メールを確認してください"), dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                    NavigationLink(destination: AuthTestSignUpView().onDisappear(perform: {
                        self.getCurrentUser()
                    })
                    ) {
                            Text("＊アカウントを作成する").underline()
                    }
                    
                }
                
            }
            Spacer().frame(width: 50)
        }
        .onAppear() {
            self.getCurrentUser()
        }
    }
    
    private func getCurrentUser() {
        if let _ = Auth.auth().currentUser {
            self.isSignedIn = true
        } else {
            self.isSignedIn = false
        }
    }
    
    private func signIn() {
        Auth.auth().signIn(withEmail: self.mailAddress, password: self.password) { authResult, error in
            
            if authResult?.user != nil {
                self.isSignedIn = true
                self.isShowAlert = true
                self.isError = false
            } else {
                self.isSignedIn = false
                self.isShowAlert = true
                self.isError = true
                if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                    switch errorCode {
                    case .invalidEmail:
                        self.errorMessage = "メールアドレスの形式が正しくありません"
                    case .userNotFound, .wrongPassword:
                        self.errorMessage = "メールアドレス、またはパスワードが間違っています"
                    case .userDisabled:
                        self.errorMessage = "このユーザーアカウントは無効化されています"
                    default:
                        self.errorMessage = error.domain
                    }
                    
                    self.isError = true
                    self.isShowAlert = true
                }
            }
            
            //メールアドレスが確認済みかどうか
            if let user = authResult?.user {
                if user.isEmailVerified {
                    print("メールアドレス確認済み")
                    self.isCheckMail = true
                } else {
                    print("メールアドレス未確認")
                    signOut()
                    self.isCheckMail = false

                }
            }
        }
    }
    
    //ログアウトの処理
    private func signOut() {
        do {
            try Auth.auth().signOut()
            self.isShowSignedOut = true
            self.isSignedIn = false
        } catch let signOutError as NSError {
            print("SignOut Error: %@", signOutError)
        }
    }
    
}

struct AuthTestSignUpView: View {
    
    @State private var mailAddress = ""
    @State private var password = ""
    @State private var passwordConfirm = ""
    @State private var groupName = ""
    
    @State private var isShowAlert = false
    @State private var isError = false
    @State private var errorMessage = ""
    
    var body: some View {
        HStack {
            Spacer().frame(width: 50)
            VStack {
                
                TextField("メールアドレス", text: $mailAddress)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("パスワード", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("パスワード確認", text: $passwordConfirm)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("所属名", text: $groupName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    self.errorMessage = ""
                    if self.mailAddress.isEmpty {
                        self.errorMessage = "メールアドレスが入力されていません"
                        self.isError = true
                        self.isShowAlert = true
                    } else if self.password.isEmpty {
                        self.errorMessage = "パスワードが入力されていません"
                        self.isError = true
                        self.isShowAlert = true
                    } else if self.passwordConfirm.isEmpty {
                        self.errorMessage = "確認パスワードが入力されていません"
                        self.isError = true
                        self.isShowAlert = true
                    } else if self.password.compare(self.passwordConfirm) != .orderedSame {
                        self.errorMessage = "パスワードと確認パスワードが一致しません"
                        self.isError = true
                        self.isShowAlert = true
                    }else if self.groupName.isEmpty {
                        self.errorMessage = "所属が入力されていません"
                        self.isError = true
                        self.isShowAlert = true
                    }else {
                        
                        //ゲストユーザの昇格
                        if let user = Auth.auth().currentUser, user.isAnonymous {
                            let credential = EmailAuthProvider.credential(withEmail: mailAddress, password: password)
                            user.link(with: credential) { authResult, error in
                                if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                                    switch errorCode {
                                    case .invalidEmail:
                                        self.errorMessage = "メールアドレスの形式が正しくありません"
                                    case .emailAlreadyInUse:
                                        self.errorMessage = "このメールアドレスは既に登録されています"
                                    case .weakPassword:
                                        self.errorMessage = "パスワードは６文字以上で入力してください"
                                    default:
                                        self.errorMessage = error.domain
                                    }
                                    
                                    self.isError = true
                                    self.isShowAlert = true
                                }
                                //メール送信
                                Auth.auth().languageCode = "ja_JP"
                                if let user = authResult?.user {
                                    user.sendEmailVerification(completion: { error in
                                        if error == nil {
                                            print("send mail success.")
                                        }
                                    })
                                }
                                print(authResult?.user.uid as Any)
                            }
                            }else{
                            //新規ユーザの登録
                            self.signUp()
                            }
                        }
                }) {
                    Text("ユーザー登録")
                }
                .alert(isPresented: $isShowAlert) {
                    if self.isError {
                        return Alert(title: Text(""), message: Text(self.errorMessage), dismissButton: .destructive(Text("OK"))
                        )
                    } else {
                        
                        return Alert(title: Text(""), message: Text("入力されたメールアドレスに\n確認メールを送信しました\nメールを確認し\nアカウントを有効にしてください"), dismissButton: .default(Text("OK")))
                        

                    }
                }

            }
            Spacer().frame(width: 50)
        }
    }
    
    private func signUp() {
        Auth.auth().createUser(withEmail: self.mailAddress, password: self.password) { authResult, error in
            if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                switch errorCode {
                case .invalidEmail:
                    self.errorMessage = "メールアドレスの形式が正しくありません"
                case .emailAlreadyInUse:
                    self.errorMessage = "このメールアドレスは既に登録されています"
                case .weakPassword:
                    self.errorMessage = "パスワードは６文字以上で入力してください"
                default:
                    self.errorMessage = error.domain
                }
                
                self.isError = true
                self.isShowAlert = true
            }else{
                //メール送信
                Auth.auth().languageCode = "ja_JP"
                if let user = authResult?.user {
                    user.sendEmailVerification(completion: { error in
                        if error == nil {
                            print("send mail success.")
                        }
                    })
                }
            }
            
            if let _ = authResult?.user {
                self.isError = false
                self.isShowAlert = true
                
                
            }
        }
    }
}

struct MemberListView: View {
    var body: some View {
        Text("メンバー一覧画面")
    }
}

struct ViewWillAppearHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> ViewWillAppearHandler.Coordinator {
        Coordinator(onWillAppear: onWillAppear)
    }

    let onWillAppear: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewWillAppearHandler>) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewWillAppearHandler>) {
    }

    typealias UIViewControllerType = UIViewController

    class Coordinator: UIViewController {
        let onWillAppear: () -> Void

        init(onWillAppear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}

struct ViewWillAppearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .background(ViewWillAppearHandler(onWillAppear: callback))
    }
}

extension View {
    func onWillAppear(_ perform: @escaping (() -> Void)) -> some View {
        self.modifier(ViewWillAppearModifier(callback: perform))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
