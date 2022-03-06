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
import AVFoundation
import MediaPlayer
import AVKit

class ViewModel: ObservableObject {
    @Published var isServicePlayer = false
    @Published var tmpServicePlayer = false
    @Published var isNetPosition = false
    //選手1,2,3,4
    var Player1 = " "
    var Player2 = " "
    var Player3 = " "
    var Player4 = " "
    //選手1,2,3,4
    var PlayerArray = [" "," "," "," "]
    //今のサーバ選手
    var NowServerPlayer = 0
    //サービスの順番
    var ServicePlayer = [0,2,1,3]
    //プレー回数のカウント(サーバーの特定に使う)
    @Published var PlayCount: Int = 0
    //選手1の得点
    var GetPointCount1: Int = 0
    //選手2の得点
    var GetPointCount2: Int = 0
    //firestoreのMatchより前の参照
    var ReferenceGame: DocumentReference? = nil
    //firestoreのMatchまでの参照
    var ReferenceMatch: DocumentReference? = nil
    //firestoreのTrunまでの参照
    var ReferenceTrun: DocumentReference? = nil
    //SubViewの状態
    @Published var isActiveSubView = 0
    //サービスの打法(一時保存)
    var S_selectBattingMethod = 0
    //サービスのコース(一時保存)
    var S_selectCourse = 0
    //入力試合URL
    var SetURL = ""
    //シングルス(true)かダブルス(false)か
    @Published var singlesOrDoubles = true
    
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
                    NavigationLink(destination: DougaKaisekiView()) {
                        Text("動画解析").font(.title).frame(width: 200, height: 80).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                    }
                
                    NavigationLink(destination: PlayerListView()) {
                    Text("選手分析").font(.title).frame(width: 200, height: 80).overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1))
                    }
                }
                
//                HStack(spacing: 30){
//                    NavigationLink(destination: SecondView()) {
//                        Text("WEBKyotaku").font(.title).frame(width: 200, height: 80).overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.blue, lineWidth: 1))
//                    }
//
//                    NavigationLink(destination: AuthTestSignInView()) {
//                        Text("ログイン").font(.title).frame(width: 200, height: 80).overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.blue, lineWidth: 1))
//                    }
//
//                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        
    }
}

struct DougaKaisekiView: View {
    @EnvironmentObject var vm : ViewModel
    @State var urlText: String = "https://www.youtube.com/"
    @State var SelectMedia = 1
    
    @State var MediaArray = ["YouTube","LaboLive"]
    
    var UrlArray = ["https://www.youtube.com/","https://labolive.com/"]
    
    var body: some View {
            VStack{
                ForEach((1...2), id: \.self) { index in
                    HStack{
                        Spacer()
                        Button(action: {
                            SelectMedia = index
                            urlText = UrlArray[SelectMedia - 1]
                        }){
                            if(SelectMedia == index) {
                                Image(systemName: "checkmark.square.fill").resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .foregroundColor(.green)
                            }else{
                                Image(systemName: "square").resizable()
                                    .frame(width: 50, height: 50, alignment: .center)
                                    .foregroundColor(.green)
                            }
                        }
                        Text(MediaArray[index - 1]).font(.title).foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 1)).frame(width: 180, height: 70)
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                }
                TextField("動画URL入力", text: $urlText).font(.title).frame(width: 600, height: 100, alignment: .center).textFieldStyle(RoundedBorderTextFieldStyle())
                
                NavigationLink(destination: SetURLView()){
                    Text("次へ").font(.title).frame(width: 180, height: 60).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }.simultaneousGesture(TapGesture().onEnded{
                    vm.SetURL = urlText
                })
                .disabled(!urlText.localizedCaseInsensitiveContains(UrlArray[SelectMedia - 1]))
                Spacer()
            }.onAppear(){
                vm.SetURL = ""
                print("a")
            }
    }
}
struct SetURLView: View {
    //データモデル(サービス交代)
    @EnvironmentObject var vm : ViewModel
    let player = AVPlayer()
    var body: some View{
        GeometryReader { geometry in
            if(vm.SetURL != ""){
                WebView(req: URLRequest(url: URL(string: vm.SetURL)!)).frame(width:geometry.size.width, height: 380, alignment: .center).onTapGesture {
                }
            }
        }
//        HStack{
//            Spacer()
//            Button(action: {
//
//            }){
//                Text("-15秒")
//            }
//            Button(action: {
//                //AVFoundetion動画が再生されたことを検知＞タイマースタート
//            }){
//                Text("再生")
//            }
//            Button(action: {
//
//            }){
//                Text("+15秒")
//            }
//            Spacer()
//        }
//        Button(action: {
//
//            if AVAudioSession.sharedInstance().isOtherAudioPlaying {
//
//                let player = MPNowPlayingInfoCenter.default().nowPlayingInfo
//
//                // バックグラウンド再生中
//                print(player)
//                print("流れてる")
//            }
//        }) {
//            Text("再生時間出力").font(.largeTitle)
//        }
        Spacer()
        ScrollView {
            if(vm.isActiveSubView == 0){
                SiaiTourokuView()
            }
            if(vm.isActiveSubView == 1){
                MatchView1()
            }
            if(vm.isActiveSubView == 2){
                MatchReceiveView(S_selectBattingMethod: vm.S_selectBattingMethod, S_selectCourse: vm.S_selectCourse)
            }
            if(vm.isActiveSubView == 3){
                ScoreView()
            }
        }
        
    }
    
}


struct PlayerListView: View {
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()

    var body: some View {
        Text("選手一覧").font(.largeTitle)
        List(kyotakuVM.users) { user in

            NavigationLink(destination: PlayerResultView(player: user.player_name, handedness: user.handedness == 1 ? "左利き" : "右利き", rubber: user.rubber == 0 ? "表表" : user.rubber == 1 ? "表裏" : user.rubber == 2 ? "裏表" : user.rubber == 3 ? "表表" : "")) {
                    Text("\(user.player_name)").font(.largeTitle).lineLimit(2)
            }
        }.onAppear(){
            print("実行されました")
            self.kyotakuVM.fetchData()
            
        }
    }
}
struct PlayerResultView: View {
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    let player: String
    let handedness: String
    let rubber: String
//    let Date: String
//    let DocumentID: String
    
    @State var DocumentIDListS = [String]()
    @State var DocumentIDListD = [String]()
    
    @State var PlayerNumberArrayS = [Int]()
    @State var PlayerNumberArrayD = [Int]()
    @State var CountArrayS = 0
    @State var CountArrayD = 0
    
    @State var SelectPlayer = 0
    
    //[[サービスコース,サービス打法,レシーブコース,レシーブ打法,得点(0 = サーバー,1 = レシーバー)]]
    @State var TestDataS1 = [[0,0,0,0],[1,1,0,0],[0,0,0,0]]
    @State var TestDataST1 = [0,1,1]
    @State var TestDataR1 = [[1,1,1,1],[1,1,1,1],[1,2,1,1]]
    @State var TestDataRT1 = [1,0,0]
    
    //次の選手へが押されたタイミングで配列を更新
    @State var count = 0
    @State var mostNumberS = [0,0,0]
    @State var mostNumberR = [0,0,0]
    
    @State var rankValueS = [Int]()
    @State var rankKeyS = [[Int]]()
    @State var rankValueR = [Int]()
    @State var rankKeyR = [[Int]]()
    
    @State var pushOn = 0
    
    var body: some View {
        HStack{
            Text(pushOn == 0 ? "選手名:　\(player)\n\n利き手:　\(handedness)\n\n戦型:　　\(rubber)\n\n" : "" )
                .font(.largeTitle)
        }
        
        HStack{

            if(pushOn == 0){
                Button(action: {
                    
                    SetDocumentID()
                    
                    self.pushOn = 3

                }) {

                Text("分析開始")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                }
            }else{
                Spacer()
                Spacer()
                Button(action: {
                    if(pushOn != 1){
                        self.pushOn = 1
                        SetArray()
                    }

                }) {

                Text("シングルス分析")
                .font(.largeTitle)
                .foregroundColor(.blue)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(pushOn == 1 ? Color.red : Color.blue, lineWidth: 1))
                
                }
    //            Spacer()
                
                Button(action: {
                    
                    if(pushOn != 2){
                        self.pushOn = 2
                        SetArray()
                    }
                    
                }) {
                Text("ダブルス分析")
                .font(.largeTitle)
                .foregroundColor(.blue)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(pushOn == 2 ? Color.red : Color.blue, lineWidth: 1))
                }
                
                Spacer()
                Spacer()
            }
            
        }.onAppear(){
            self.kyotakuVM.fetchSinglesMatchData()
            self.kyotakuVM.fetchDoublesMatchData()
        }
        
        if(pushOn == 1 || pushOn == 3){
            HStack{
                Text("\(player)サービス時の攻撃パターン").font(.largeTitle)
                    .padding()

                Spacer()
            }
            ZStack{
                HStack{
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 1){
                            DrowServiceLine(service: rankKeyS[0][0], receive: rankKeyS[0][2])
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 2){
                            DrowServiceLine(service: rankKeyS[1][0], receive: rankKeyS[1][2])
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 3){
                            DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                        }
                    }
                    Spacer()
                    
                }
                Spacer()

            }
            
            HStack{
                Spacer()
                Text(rankValueS.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyS[0][1], BattleTypeR: rankKeyS[0][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyS[1][1], BattleTypeR: rankKeyS[1][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyS[2][1], BattleTypeR: rankKeyS[2][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                Text(rankValueS.count >= 1 ? "(\(mostNumberS[0])/\(rankValueS[0]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 2 ? "(\(mostNumberS[1])/\(rankValueS[1]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 3 ? "(\(mostNumberS[2])/\(rankValueS[2]))" : "　　　").font(.title3)
                Spacer()
            }
            
            HStack{
                Text("\(player)レシーブ時の攻撃パターン").font(.largeTitle)
                .padding()
                
                Spacer()
            }
            
            HStack{
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 1){
                        DrowServiceLine(service: rankKeyR[0][0], receive: rankKeyR[0][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 2){
                        DrowServiceLine(service: rankKeyR[1][0], receive: rankKeyR[1][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 3){
                        DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
            }
            
            HStack{
                Spacer()
                Text(rankValueR.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyR[0][1], BattleTypeR: rankKeyR[0][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyR[1][1], BattleTypeR: rankKeyR[1][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyR[2][1], BattleTypeR: rankKeyR[2][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                Text(rankValueR.count >= 1 ? "(\(mostNumberR[0])/\(rankValueR[0]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 2 ? "(\(mostNumberR[1])/\(rankValueR[1]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 3 ? "(\(mostNumberR[2])/\(rankValueR[2]))" : "　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                
                Text("     サービス:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.red)
                Text("レシーブ:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.yellow)
                
                Spacer()
            }
            Spacer()
        }else if(pushOn == 2){
            HStack{
                Text("\(player)サービス時の攻撃パターン").font(.largeTitle)
                    .padding()

                Spacer()
            }
            ZStack{
                HStack{
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 1){
                            DrowServiceLine(service: rankKeyS[0][0], receive: rankKeyS[0][2])
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 2){
                            DrowServiceLine(service: rankKeyS[1][0], receive: rankKeyS[1][2])
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 3){
                            DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                        }
                    }
                    Spacer()
                    
                }
    //            PathView()
                Spacer()

            }
            
            HStack{
                Spacer()
                Text(rankValueS.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyS[0][1], BattleTypeR: rankKeyS[0][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyS[1][1], BattleTypeR: rankKeyS[1][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyS[2][1], BattleTypeR: rankKeyS[2][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                Text(rankValueS.count >= 1 ? "(\(mostNumberS[0])/\(rankValueS[0]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 2 ? "(\(mostNumberS[1])/\(rankValueS[1]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 3 ? "(\(mostNumberS[2])/\(rankValueS[2]))" : "　　　").font(.title3)
                Spacer()
            }
            
            HStack{
                Text("\(player)レシーブ時の攻撃パターン").font(.largeTitle)
                .padding()
                
                Spacer()
            }
            
            HStack{
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 1){
                        DrowServiceLine(service: rankKeyR[0][0], receive: rankKeyR[0][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 2){
                        DrowServiceLine(service: rankKeyR[1][0], receive: rankKeyR[1][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 3){
                        DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
            }
            
            HStack{
                Spacer()
                Text(rankValueR.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyR[0][1], BattleTypeR: rankKeyR[0][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyR[1][1], BattleTypeR: rankKeyR[1][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyR[2][1], BattleTypeR: rankKeyR[2][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                Text(rankValueR.count >= 1 ? "(\(mostNumberR[0])/\(rankValueR[0]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 2 ? "(\(mostNumberR[1])/\(rankValueR[1]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 3 ? "(\(mostNumberR[2])/\(rankValueR[2]))" : "　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                
                Text("     サービス:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.red)
                Text("レシーブ:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.yellow)
                
                Spacer()
            }
            Spacer()
        }
    }
    func GetBattleTypeS(BattleTypeS: Int, BattleTypeR: Int ) -> String {
        var TextData = ""
        
        if(pushOn == 1){
            switch BattleTypeS{
            case 0:
                TextData = "横回転"
            case 1:
                TextData = "縦回転"
            case 2:
                TextData = "YG"
            case 3:
                TextData = "バックハンド"
            case 4:
                TextData = "巻き込み"
            case 5:
                TextData = "しゃがみ込み"

            default:
                TextData = "しゃがみ込み"
                
            }
            TextData += "->"
            
            switch BattleTypeR{
            case 0:
                TextData += "チキータ"
            case 1:
                TextData += "フリック"
            case 2:
                TextData += "ストップ"
            case 3:
                TextData += "ツッツキ"
            case 4:
                TextData += "流し"
            case 5:
                TextData += "ドライブ(強)"
            case 6:
                TextData += "ドライブ(弱)"
            case 7:
                TextData += "カット"
            case 8:
                TextData += "逆チキータ"
            case 9:
                TextData += "ミス"

            default:
                TextData += "ミス"
                
            }
        }else{
            switch BattleTypeS{
            case 0:
                TextData = "横回転"
            case 1:
                TextData = "下回転"
            case 2:
                TextData = "YG"
            case 3:
                TextData = "バックハンド"
            case 4:
                TextData = "巻き込み"
            case 5:
                TextData = "ロングサーブ"

            default:
                TextData = "ロングサーブ"
                
            }
            TextData += "->"
            
            switch BattleTypeR{
            case 0:
                TextData += "チキータ"
            case 1:
                TextData += "逆チキータ"
            case 2:
                TextData += "流し"
            case 3:
                TextData += "ドライブ"
            case 4:
                TextData += "ツッツキ"
            case 5:
                TextData += "ストップ"
            case 6:
                TextData += "バックハンド"
            case 7:
                TextData += "フリック"
            case 8:
                TextData += "ミス"

            default:
                TextData += "ミス"
                
            }
        }
        return TextData
    }
    func SetDocumentID(){
        for i in kyotakuVM.singles{
            if(i.player1 == player){
                DocumentIDListS.append(i.DocumentId)
                PlayerNumberArrayS.append(0)
            }else if(i.player2 == player){
                DocumentIDListS.append(i.DocumentId)
                PlayerNumberArrayS.append(1)
            }
        }
        for j in DocumentIDListS{

            self.kyotakuVM.fetchDateData(SelectId: j)
            
        }
        
        for k in kyotakuVM.doubles{
            if(k.player1 == player){
                DocumentIDListD.append(k.DocumentId)
                PlayerNumberArrayD.append(0)
            }else if(k.player2 == player){
                DocumentIDListD.append(k.DocumentId)
                PlayerNumberArrayD.append(1)
            }else if(k.player3 == player){
                DocumentIDListD.append(k.DocumentId)
                PlayerNumberArrayD.append(2)
            }else if(k.player4 == player){
                DocumentIDListD.append(k.DocumentId)
                PlayerNumberArrayD.append(3)
            }
        }
        for l in DocumentIDListD{
            self.kyotakuVM.fetchDateDataD(SelectId: l)
        }
        print(PlayerNumberArrayS.count)
        print(DocumentIDListS.count)
        print(PlayerNumberArrayD.count)
        print(DocumentIDListD.count)
    }
    
    
    func SetArray() {
        
        TestDataS1.removeAll()
        TestDataST1.removeAll()
        
        TestDataR1.removeAll()
        TestDataRT1.removeAll()
        
        rankValueS.removeAll()
        rankKeyS.removeAll()
        rankValueR.removeAll()
        rankKeyR.removeAll()
        mostNumberS = [0,0,0]
        mostNumberR = [0,0,0]
        
        CountArrayD = 0
        CountArrayS = 0
        
        var Count = 0
        
//        print(kyotakuVM.turn)
        
        for a in kyotakuVM.turn{
            
            if(a.service == 2 || a.service == 3 || a.receive == 2 || a.receive == 3){
                if(pushOn == 2){
                    print(a)
                    //サービスの配列データ追加
                    if(a.service == PlayerNumberArrayD[CountArrayD]){
                        TestDataS1 += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                        switch a.winner {
                        case 0:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataST1 += [1]
                            }else{
                                TestDataST1 += [0]
                            }
                        case 1:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataST1 += [0]
                            }else{
                                TestDataST1 += [1]
                            }
                        default:
                            break
                        }
                    }
                    //レシーブの配列データ追加
                    if(a.receive == PlayerNumberArrayD[CountArrayD]){
                        TestDataR1 += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                        switch a.winner {
                        case 0:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataRT1 += [1]
                            }else{
                                TestDataRT1 += [0]
                            }
                        case 1:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataRT1 += [0]
                            }else{
                                TestDataRT1 += [1]
                            }
                        default:
                            break
                        }
                    }
                    if(Count == 0){
                        Count = a.date[0]
                        Count -= 1
                        if(Count == 0){
                            CountArrayD += 1
                        }
                    }else{
                        Count -= 1
                    }

                    print(CountArrayD)
                    
                }
            }else{
                if(pushOn == 1){
                    print(a.date)
                    //サービスの配列データ追加
                    if(a.service == PlayerNumberArrayS[CountArrayS]){
                        
                        TestDataS1 += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                        switch a.winner {
                        case 0:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataST1 += [1]
                            }else{
                                TestDataST1 += [0]
                            }
                        case 1:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataST1 += [0]
                            }else{
                                TestDataST1 += [1]
                            }
                        default:
                            break
                        }
                    }
                    //レシーブの配列データ追加
                    if(a.receive == PlayerNumberArrayS[CountArrayS]){
                        TestDataR1 += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                        switch a.winner {
                        case 0:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataRT1 += [1]
                            }else{
                                TestDataRT1 += [0]
                            }
                        case 1:
                            if(SelectPlayer == 0 || SelectPlayer == 1){
                                TestDataRT1 += [0]
                            }else{
                                TestDataRT1 += [1]
                            }
                        default:
                            break
                        }
                    }
                    if(Count == 0){
                        Count = a.date[0]
                        Count -= 1
                        if(Count == 0){
                            CountArrayS += 1
                        }
                    }else{
                        Count -= 1
                    }

                    print(CountArrayS)
                }
            }

        }
        //配列内の重複を取得
        var numToCountS: [[Int]: Int] = [:]
        var numToCountR: [[Int]: Int] = [:]
        for elt in TestDataS1 {
            numToCountS[elt, default: 0] += 1
        }
        for elt in TestDataR1 {
            numToCountR[elt, default: 0] += 1
        }
        //重複した回数が多い順に並び替え
        //key コース value 出現回数
        rankKeyS = numToCountS.sorted { (-$0.value) < (-$1.value) }.map{$0.key}
        rankValueS = numToCountS.sorted { (-$0.value) < (-$1.value) }.map{$0.value}
        print(rankKeyS)
        
        rankKeyR = numToCountR.sorted { (-$0.value) < (-$1.value) }.map{$0.key}
        rankValueR = numToCountR.sorted { (-$0.value) < (-$1.value) }.map{$0.value}
        print(rankKeyR)
        //上位３つの得点数を出力
        var count = 0
        
        TestDataS1.forEach(){data in
            
            if(rankKeyS.count >= 1 && rankKeyS[0] == data){
                if(TestDataST1[count] == 1){
                    
                    mostNumberS[0] += 1
                }
            }else if(rankKeyS.count >= 2 && rankKeyS[1] == data){
                if(TestDataST1[count] == 1){
                    mostNumberS[1] += 1
                }
            }else if(rankKeyS.count >= 3 && rankKeyS[2] == data){
                if(TestDataST1[count] == 1){
                    mostNumberS[2] += 1
                }
            }
            count += 1
        }
        count = 0

        TestDataR1.forEach(){data in
            
            if(rankKeyR.count >= 1 && rankKeyR[0] == data){
                if(TestDataRT1[count] == 1){
                    mostNumberR[0] += 1
                }
            }else if(rankKeyR.count >= 2 && rankKeyR[1] == data){
                if(TestDataRT1[count] == 1){
                    mostNumberR[1] += 1
                }
            }else if(rankKeyR.count >= 3 && rankKeyR[2] == data){
                if(TestDataRT1[count] == 1){
                    mostNumberR[2] += 1
                }
            }
            count += 1
        }
    }
}

struct SiaiItiranView: View {
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    //true(シングルス表示)false(ダブルス表示)
    @State private var selectButton = true
    @State var searchTextEntered: String = ""
    @State var Count = 0
    @State var ArrayDate = [String]()
    @State var ArrayPlayer = [[String]]()
    @State private var selectionValue: Int? = nil
    
    var body: some View {
        VStack{
        HStack{
            Spacer()
            Button(action: {
                selectButton = true

            }) {
                Text("シングルス").font(.largeTitle)
            }
            Spacer()
            Button(action: {
                selectButton = false
            }) {
                Text("ダブルス").font(.largeTitle)
            }
            Spacer()
        }
        if(selectButton){
            
            List(kyotakuVM.singles) { single in
                if (single.date.count <=  single.Count){
                    
                }else{
                    NavigationLink(destination: SinglesResultView(player1: single.player1, player2: single.player2, Date: single.array[single.date[single.Count] - 1],DocumentID: single.DocumentId)) {
                            Text("\(single.player1)     対     \(single.player2)\n\(single.array[single.date[single.Count] - 1])").font(.largeTitle).lineLimit(3)

                    }
                }
            }
        }else{
            List(kyotakuVM.doubles) { double in
                VStack(alignment: .leading) {
                    if (double.date.count <=  double.Count){
                        
                    }else{
                        NavigationLink(destination: DoublesResultView(player1: double.player1, player2: double.player2, player3: double.player3, player4: double.player4, Date: double.array[double.date[double.Count] - 1],DocumentID: double.DocumentId)) {
                            Text("\(double.player1) & \(double.player2)    対     \(double.player3) & \(double.player4)\n\(double.array[double.date[double.Count] - 1])").font(.largeTitle).lineLimit(3)
                        }
                    }
                }
            }
        }
        }.onAppear(){
            print("実行されました")
            if(Count == 0){
                self.kyotakuVM.fetchSinglesMatchData()
                self.kyotakuVM.fetchDoublesMatchData()
            }
            print(Count)
            Count += 1
            
        }
    }
}

struct SinglesResultView: View {
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    @State var SelectPlayer = true
    
    let player1: String
    let player2: String
    let Date: String
    let DocumentID: String
    
    @State var TestDataS = [[0,0,0,0],[1,1,0,0],[0,0,0,0]]
    @State var TestDataST = [0,1,1]
    @State var TestDataR = [[1,1,1,1],[1,1,1,1],[1,2,1,1]]
    @State var TestDataRT = [1,0,0]
    //[[サービスコース,サービス打法,レシーブコース,レシーブ打法,得点(0 = サーバー,1 = レシーバー)]]

    @State var count = 0
    @State var mostNumberS = [0,0,0]
    @State var mostNumberR = [0,0,0]
    
    @State var rankValueS = [Int]()
    @State var rankKeyS = [[Int]]()
    @State var rankValueR = [Int]()
    @State var rankKeyR = [[Int]]()
    
    @State var pushOn = 0
    
    var body: some View {
        HStack{
            Text(pushOn == 0 ? "\(player1)　対　\(player2) \n \(Date)" : "" ).multilineTextAlignment(.center)
                .font(.largeTitle)
        }
        HStack{
            Spacer()
            Spacer()
            if(pushOn != 1){
                Button(action: {
                    if(TestDataR[0][0] == 1){
                        SetArray()
                    }
                    self.pushOn = 1
                }) {

                Text("分析結果表示")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                }
            }
            
            if(pushOn == 1){
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()

                Button(action: {
                    print(TestDataR)
                    SelectPlayer.toggle()
                        
                }) {
                    Text("次の選手へ")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }

            }
            Spacer()
            Spacer()
            
        }.onAppear(){
            self.kyotakuVM.fetchDateData(SelectId: DocumentID)
        }
        
        if(pushOn == 1){
            HStack{
                let _ = print(TestDataR)
                let _ = print(DocumentID)
                Text(SelectPlayer ? "\(player1)サービス時の攻撃パターン" : "\(player2)サービス時の攻撃パターン" ).font(.largeTitle)
                    .padding()
                Spacer()
            }
            
            ZStack{
                HStack{
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        
                        if(SelectPlayer == true){
                            if (rankValueS.count >= 1){
                                DrowServiceLine(service: rankKeyS[0][0], receive: rankKeyS[0][2])
                            }
                        }else{
                            if (rankValueR.count >= 1){
                                DrowServiceLine(service: rankKeyR[0][0], receive: rankKeyR[0][2])
                            }
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        
                        if(SelectPlayer == true){
                            if (rankValueS.count >= 2){
                                DrowServiceLine(service: rankKeyS[1][0], receive: rankKeyS[1][2])
                            }
                        }else{
                            if (rankValueR.count >= 2){
                                DrowServiceLine(service: rankKeyR[1][0], receive: rankKeyR[1][2])
                            }
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        
                        if(SelectPlayer == true){
                            if (rankValueS.count >= 3){
                                DrowServiceLine(service: rankKeyS[2][0], receive: rankKeyS[2][2])
                            }
                        }else{
                            if (rankValueR.count >= 3){
                                DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                            }
                        }
                    }
                    Spacer()
                    
                }
                Spacer()
            }.onAppear(){
                
            }

            HStack{
                Spacer()
                if(SelectPlayer == true){
                    Text(rankValueS.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyS[0][1], BattleTypeR: rankKeyS[0][3]) : "　　　　　　　　　").font(.title3)
                }else{
                    Text(rankValueR.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyR[0][1], BattleTypeR: rankKeyR[0][3]) : "　　　　　　　　　").font(.title3)
                }
                Spacer()
                if(SelectPlayer == true){
                    Text(rankValueS.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyS[1][1], BattleTypeR: rankKeyS[1][3]) : "　　　　　　　　　").font(.title3)
                }else{
                    Text(rankValueR.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyR[1][1], BattleTypeR: rankKeyR[1][3]) : "　　　　　　　　　").font(.title3)
                }
                Spacer()
                if(SelectPlayer == true){
                    Text(rankValueS.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyS[2][1], BattleTypeR: rankKeyS[2][3]) : "　　　　　　　　　").font(.title3)
                }else{
                    Text(rankValueR.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyR[2][1], BattleTypeR: rankKeyR[2][3]) : "　　　　　　　　　").font(.title3)
                }
                Spacer()
            }
            
            HStack{
                Spacer()
                if(SelectPlayer == true){
                    Text(rankValueS.count >= 1 ? "(\(mostNumberS[0])/\(rankValueS[0]))" : "　　　").font(.title3)
                }else{
                    Text(rankValueR.count >= 1 ? "(\(rankValueR[0] - mostNumberR[0])/\(rankValueR[0]))" : "　　　").font(.title3)
                }
                Spacer()
                Spacer()
                if(SelectPlayer == true){
                    Text(rankValueS.count >= 2 ? "(\(mostNumberS[1])/\(rankValueS[1]))" : "　　　").font(.title3)
                }else{
                    Text(rankValueR.count >= 2 ? "(\(rankValueR[1] - mostNumberR[1])/\(rankValueR[1]))" : "　　　").font(.title3)
                }
                Spacer()
                Spacer()
                if(SelectPlayer == true){
                    Text(rankValueS.count >= 3 ? "(\(mostNumberS[2])/\(rankValueS[2]))" : "　　　").font(.title3)
                }else{
                    Text(rankValueR.count >= 3 ? "(\(rankValueR[2] - mostNumberR[2])/\(rankValueR[2]))" : "　　　").font(.title3)
                }
                Spacer()
            }

            HStack{
                Text(SelectPlayer ? "\(player1)レシーブ時の攻撃パターン" : "\(player2)レシーブ時の攻撃パターン").font(.largeTitle)
                    .padding()
                Spacer()
            }

            ZStack{
                HStack{
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueR.count >= 1){
                            if(SelectPlayer == true){
                                DrowServiceLine(service: rankKeyR[0][0], receive: rankKeyR[0][2])
                            }else{
                                if(rankKeyS.count >= 1){
                                    DrowServiceLine(service: rankKeyS[0][0], receive: rankKeyS[0][2])
                                }
                            }
                        }
                    }.rotationEffect(Angle(degrees: 180.0))
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueR.count >= 2){
                            if(SelectPlayer == true){
                                DrowServiceLine(service: rankKeyR[1][0], receive: rankKeyR[1][2])
                            }else{
                                if(rankKeyS.count >= 2){
                                    DrowServiceLine(service: rankKeyS[1][0], receive: rankKeyS[1][2])
                                }
                            }
                        }
                    }.rotationEffect(Angle(degrees: 180.0))
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueR.count >= 3){
                            if(SelectPlayer == true){
                                DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                            }else{
                                if(rankKeyS.count >= 3){
                                    DrowServiceLine(service: rankKeyS[2][0], receive: rankKeyS[2][2])
                                }
                            }
                        }
                    }.rotationEffect(Angle(degrees: 180.0))
                    Spacer()

                }
                Spacer()

            }
            
            HStack{
                Spacer()
                if(SelectPlayer){
                    Text(rankValueR.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyR[0][1], BattleTypeR: rankKeyR[0][3]) : "　　　　　　　　　").font(.title3)
                }else{
                    Text(rankValueS.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyS[0][1], BattleTypeR: rankKeyS[0][3]) : "　　　　　　　　　").font(.title3)
                }
                
                Spacer()
                if(SelectPlayer){
                    Text(rankValueR.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyR[1][1], BattleTypeR: rankKeyR[1][3]) : "　　　　　　　　　").font(.title3)
                }else{
                    Text(rankValueS.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyS[1][1], BattleTypeR: rankKeyS[1][3]) : "　　　　　　　　　").font(.title3)
                }
                Spacer()
                if(SelectPlayer){
                    Text(rankValueR.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyR[2][1], BattleTypeR: rankKeyR[2][3]) : "　　　　　　　　　").font(.title3)
                }else{
                    Text(rankValueS.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyS[2][1], BattleTypeR: rankKeyS[2][3]) : "　　　　　　　　　").font(.title3)
                }
                Spacer()
            }
            HStack{
                Spacer()
                if(SelectPlayer){
                    Text(rankValueR.count >= 1 ? "(\(mostNumberR[0])/\(rankValueR[0]))" : "　　　").font(.title3)
                }else{
                    Text(rankValueS.count >= 1 ? "(\(rankValueS[0] - mostNumberS[0])/\(rankValueS[0]))" : "　　　").font(.title3)
                }
                Spacer()
                Spacer()
                if(SelectPlayer){
                    Text(rankValueR.count >= 2 ? "(\(mostNumberR[1])/\(rankValueR[1]))" : "　　　").font(.title3)
                }else{
                    Text(rankValueS.count >= 2 ? "(\(rankValueS[1] - mostNumberS[1])/\(rankValueS[1]))" : "　　　").font(.title3)
                }
                Spacer()
                Spacer()
                if(SelectPlayer){
                    Text(rankValueR.count >= 3 ? "(\(mostNumberR[2])/\(rankValueR[2]))" : "　　　").font(.title3)
                }else{
                    Text(rankValueS.count >= 3 ? "(\(rankValueS[2] - mostNumberS[2])/\(rankValueS[2]))" : "　　　").font(.title3)
                }
                Spacer()
            }
            HStack{
                Spacer()
                
                Text("     サービス:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.red)
                Text("レシーブ:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.yellow)
                
                Spacer()
            }
            Spacer()
        }
        
    }
    func GetBattleTypeS(BattleTypeS: Int, BattleTypeR: Int ) -> String {
        var TextData = ""
        switch BattleTypeS{
        case 0:
            TextData = "横回転"
        case 1:
            TextData = "縦回転"
        case 2:
            TextData = "YG"
        case 3:
            TextData = "バックハンド"
        case 4:
            TextData = "巻き込み"
        case 5:
            TextData = "しゃがみ込み"

        default: break
            
        }
        TextData += "->"
        
        switch BattleTypeR{
        case 0:
            TextData += "チキータ"
        case 1:
            TextData += "フリック"
        case 2:
            TextData += "ストップ"
        case 3:
            TextData += "ツッツキ"
        case 4:
            TextData += "流し"
        case 5:
            TextData += "ドライブ(強)"
        case 6:
            TextData += "ドライブ(弱)"
        case 7:
            TextData += "カット"
        case 8:
            TextData += "逆チキータ"
        case 9:
            TextData += "ミス"

        default: break
            
        }
        return TextData
    }
    func SetArray() {
        TestDataS.removeAll()
        TestDataST.removeAll()
        TestDataR.removeAll()
        TestDataRT.removeAll()
        
        rankValueS.removeAll()
        rankKeyS.removeAll()
        rankValueR.removeAll()
        rankKeyR.removeAll()
        
        mostNumberS = [0,0,0]
        mostNumberR = [0,0,0]
        
        for a in kyotakuVM.turn{
            switch a.service {
            case 0:
                TestDataS += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                switch a.winner {
                case 0:
                    if(a.service == 0){
                        TestDataST += [1]
                    }else{
                        TestDataST += [0]
                    }
                case 1:
                    if(a.service == 0){
                        TestDataST += [0]
                    }else{
                        TestDataST += [1]
                    }
                default:
                    break
                }

            case 1:
                TestDataR += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                switch a.winner {
                case 0:
                    if(a.service == 0){
                        TestDataRT += [1]
                    }else{
                        TestDataRT += [0]
                    }
                case 1:
                    if(a.service == 0){
                        TestDataRT += [0]
                    }else{
                        TestDataRT += [1]
                    }
                default:
                    break
                }
            default:
                break
            }
        }
        //配列内の重複を取得
        var numToCountS: [[Int]: Int] = [:]
        var numToCountR: [[Int]: Int] = [:]
        for elt in TestDataS {
            numToCountS[elt, default: 0] += 1
        }
        for elt in TestDataR {
            numToCountR[elt, default: 0] += 1
        }
        //重複した回数が多い順に並び替え
        //key コース value 出現回数
        rankKeyS = numToCountS.sorted { (-$0.value) < (-$1.value) }.map{$0.key}
        rankValueS = numToCountS.sorted { (-$0.value) < (-$1.value) }.map{$0.value}
        
        rankKeyR = numToCountR.sorted { (-$0.value) < (-$1.value) }.map{$0.key}
        rankValueR = numToCountR.sorted { (-$0.value) < (-$1.value) }.map{$0.value}
        //上位３つの得点数を出力
        var count = 0
        TestDataS.forEach(){data in
            
            if(rankKeyS.count >= 1 && rankKeyS[0] == data){
                if(TestDataST[count] == 1){
                    
                    mostNumberS[0] += 1
                }
            }else if(rankKeyS.count >= 2 && rankKeyS[1] == data){
                if(TestDataST[count] == 1){
                    mostNumberS[1] += 1
                }
            }else if(rankKeyS.count >= 3 && rankKeyS[2] == data){
                if(TestDataST[count] == 1){
                    mostNumberS[2] += 1
                }
            }
            count += 1
        }
        count = 0
        
        TestDataR.forEach(){data in
            
            if(rankKeyR.count >= 1 && rankKeyR[0] == data){
                if(TestDataRT[count] == 1){
                    mostNumberR[0] += 1
                }
            }else if(rankKeyR.count >= 2 && rankKeyR[1] == data){
                if(TestDataRT[count] == 1){
                    mostNumberR[1] += 1
                }
            }else if(rankKeyR.count >= 3 && rankKeyR[2] == data){
                if(TestDataRT[count] == 1){
                    mostNumberR[2] += 1
                }
            }
            count += 1
        }
    }
}
struct DrowServiceLine: View  {
    let service: Int
    let receive: Int
    @State var x1 = 0
    @State var y1 = 0
    @State var x2 = 0
    @State var y2 = 0
    @State var x3 = 0
    @State var y3 = 0
    var body: some View {

        Path { path in
            if(service == 0 || service == 3 || service == 6){
                path.move(to: CGPoint(x: x1 + 115, y: y1))
                path.addLine(to: CGPoint(x: x2, y: y2))
            }else{
                path.move(to: CGPoint(x: x1, y: y1))
                path.addLine(to: CGPoint(x: x2, y: y2))
            }
            
        }.stroke(lineWidth: 14)
        .fill(Color.red)
        .frame(width: 204, height: 240)
        .onAppear(){

            switch service{
            case 0:
                x1 = 45
                y1 = 230
                x2 = 45
                y2 = 20
            case 1:
                x1 = 45
                y1 = 230
                x2 = 110
                y2 = 20
            case 2:
                x1 = 45
                y1 = 230
                x2 = 160
                y2 = 20
            case 3:
                x1 = 45
                y1 = 230
                x2 = 45
                y2 = 50
            case 4:
                x1 = 45
                y1 = 230
                x2 = 110
                y2 = 50
            case 5:
                x1 = 45
                y1 = 230
                x2 = 160
                y2 = 50
            case 6:
                x1 = 45
                y1 = 230
                x2 = 45
                y2 = 85
            case 7:
                x1 = 45
                y1 = 230
                x2 = 110
                y2 = 85
            case 8:
                x1 = 45
                y1 = 230
                x2 = 160
                y2 = 85
                
            default:
                x1 = 45
                y1 = 230
                x2 = 160
                y2 = 85
                
            }
            switch receive{
            case 0:
                x3 = 45
                y3 = 140
            case 1:
                x3 = 110
                y3 = 140
            case 2:
                x3 = 160
                y3 = 140
            case 3:
                x3 = 45
                y3 = 180
            case 4:
                x3 = 110
                y3 = 180
            case 5:
                x3 = 160
                y3 = 180
            case 6:
                x3 = 45
                y3 = 230
            case 7:
                x3 = 110
                y3 = 230
            case 8:
                x3 = 160
                y3 = 230
                
            default:
                x3 = 160
                y3 = 230
            }
        }
        
        Path { path in
                path.move(to: CGPoint(x: x2 + 5, y: y2))
                path.addLine(to: CGPoint(x: x3 + 5, y: y3))
        }.stroke(lineWidth: 14)
        .fill(Color.yellow)
        .frame(width: 204, height: 240)

    }

}


struct DoublesResultView: View {
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    
    let player1: String
    let player2: String
    let player3: String
    let player4: String
    let Date: String
    let DocumentID: String
    
    @State var SelectPlayer = 0
    
    //[[サービスコース,サービス打法,レシーブコース,レシーブ打法,得点(0 = サーバー,1 = レシーバー)]]
    @State var TestDataS1 = [[0,0,0,0],[1,1,0,0],[0,0,0,0]]
    @State var TestDataST1 = [0,1,1]
    @State var TestDataR1 = [[1,1,1,1],[1,1,1,1],[1,2,1,1]]
    @State var TestDataRT1 = [1,0,0]
    
    //次の選手へが押されたタイミングで配列を更新
    @State var count = 0
    @State var mostNumberS = [0,0,0]
    @State var mostNumberR = [0,0,0]
    
    @State var rankValueS = [Int]()
    @State var rankKeyS = [[Int]]()
    @State var rankValueR = [Int]()
    @State var rankKeyR = [[Int]]()
    
    @State var pushOn = 0
    
    var body: some View {
        HStack{
            Text(pushOn == 0 ? "\(player1)　&　\(player2) \n 対 \n \(player3)　&　\(player4) \n\(Date)" : "" ).multilineTextAlignment(.center)
                .font(.largeTitle)
        }
        HStack{
            Spacer()
            Spacer()
            if(pushOn != 1){
                Button(action: {
                    if(TestDataR1[0][0] == 1){
                        SetArray()
                    }
                    self.pushOn = 1
                }) {

                Text("分析結果表示")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                }
            }
            
            if(pushOn == 1){
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Button(action: {
                    if(SelectPlayer != 3){
                        SelectPlayer += 1
                    }else{
                        SelectPlayer = 0
                    }
                    SetArray()
                }) {
                    Text("次の選手へ")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                }
            }
            Spacer()
            Spacer()
            
        }.onAppear(){
            self.kyotakuVM.fetchDateDataD(SelectId: DocumentID)
        }
        
        if(pushOn == 1){
            HStack{
                switch SelectPlayer {
                    case 0:
                        Text("\(player1)サービス時の攻撃パターン").font(.largeTitle)
                            .padding()
                    case 1:
                        Text("\(player2)サービス時の攻撃パターン").font(.largeTitle)
                            .padding()
                    case 2:
                        Text("\(player3)サービス時の攻撃パターン").font(.largeTitle)
                            .padding()
                    case 3:
                        Text("\(player4)サービス時の攻撃パターン").font(.largeTitle)
                            .padding()
                        
                    default:
                        Text("エラー:データが間違っています").font(.largeTitle)
                        .padding()
                }

                Spacer()
            }
            ZStack{
                HStack{
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 1){
                            DrowServiceLine(service: rankKeyS[0][0], receive: rankKeyS[0][2])
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 2){
                            DrowServiceLine(service: rankKeyS[1][0], receive: rankKeyS[1][2])
                        }
                    }
                    Spacer()
                    ZStack{
                        Image("coat").resizable()
                            .frame(width: 204, height: 240)
                        if (rankValueS.count >= 3){
                            DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                        }
                    }
                    Spacer()
                    
                }
                Spacer()

            }
            
            HStack{
                Spacer()
                Text(rankValueS.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyS[0][1], BattleTypeR: rankKeyS[0][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyS[1][1], BattleTypeR: rankKeyS[1][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyS[2][1], BattleTypeR: rankKeyS[2][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                Text(rankValueS.count >= 1 ? "(\(mostNumberS[0])/\(rankValueS[0]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 2 ? "(\(mostNumberS[1])/\(rankValueS[1]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueS.count >= 3 ? "(\(mostNumberS[2])/\(rankValueS[2]))" : "　　　").font(.title3)
                Spacer()
            }
            
            HStack{
                switch SelectPlayer {
                    case 0:
                        Text("\(player1)レシーブ時の攻撃パターン").font(.largeTitle)
                        .padding()
                    case 1:
                        Text("\(player2)レシーブ時の攻撃パターン").font(.largeTitle)
                        .padding()
                    case 2:
                        Text("\(player3)レシーブ時の攻撃パターン").font(.largeTitle)
                        .padding()
                    case 3:
                        Text("\(player4)レシーブ時の攻撃パターン").font(.largeTitle)
                        .padding()
                    
                    default:
                        Text("エラー:データが間違っています").font(.largeTitle)
                        .padding()
                }
                Spacer()
            }
            
            HStack{
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 1){
                        DrowServiceLine(service: rankKeyR[0][0], receive: rankKeyR[0][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 2){
                        DrowServiceLine(service: rankKeyR[1][0], receive: rankKeyR[1][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
                ZStack{
                    Image("coat").resizable()
                        .frame(width: 204, height: 240)
                    if (rankValueR.count >= 3){
                        DrowServiceLine(service: rankKeyR[2][0], receive: rankKeyR[2][2])
                    }
                }.rotationEffect(Angle(degrees: 180.0))
                Spacer()
            }
            
            HStack{
                Spacer()
                Text(rankValueR.count >= 1 ? GetBattleTypeS(BattleTypeS: rankKeyR[0][1], BattleTypeR: rankKeyR[0][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 2 ? GetBattleTypeS(BattleTypeS: rankKeyR[1][1], BattleTypeR: rankKeyR[1][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 3 ? GetBattleTypeS(BattleTypeS: rankKeyR[2][1], BattleTypeR: rankKeyR[2][3]) : "　　　　　　　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                Text(rankValueR.count >= 1 ? "(\(mostNumberR[0])/\(rankValueR[0]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 2 ? "(\(mostNumberR[1])/\(rankValueR[1]))" : "　　　").font(.title3)
                Spacer()
                Spacer()
                Text(rankValueR.count >= 3 ? "(\(mostNumberR[2])/\(rankValueR[2]))" : "　　　").font(.title3)
                Spacer()
            }
            HStack{
                Spacer()
                
                Text("     サービス:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.red)
                Text("レシーブ:").font(.title)
                Path { path in
                        path.move(to: CGPoint(x: 0, y: 30))        // 始点移動
                        path.addLine(to: CGPoint(x: 150, y: 30))   // 直線描画
                }
                .stroke(lineWidth: 20)    // 塗りつぶし色指定
                .fill(Color.yellow)
                
                Spacer()
            }
            Spacer()
        }
    }
    func GetBattleTypeS(BattleTypeS: Int, BattleTypeR: Int ) -> String {
        var TextData = ""
        switch BattleTypeS{
        case 0:
            TextData = "横回転"
        case 1:
            TextData = "下回転"
        case 2:
            TextData = "YG"
        case 3:
            TextData = "バックハンド"
        case 4:
            TextData = "巻き込み"
        case 5:
            TextData = "ロングサーブ"

        default: break
            
        }
        TextData += "->"
        
        switch BattleTypeR{
        case 0:
            TextData += "チキータ"
        case 1:
            TextData += "逆チキータ"
        case 2:
            TextData += "流し"
        case 3:
            TextData += "ドライブ"
        case 4:
            TextData += "ツッツキ"
        case 5:
            TextData += "ストップ"
        case 6:
            TextData += "バックハンド"
        case 7:
            TextData += "フリック"
        case 8:
            TextData += "ミス"

        default: break
            
        }
        return TextData
    }
    
    func SetArray() {
        TestDataS1.removeAll()
        TestDataST1.removeAll()
        
        TestDataR1.removeAll()
        TestDataRT1.removeAll()
        
        rankValueS.removeAll()
        rankKeyS.removeAll()
        rankValueR.removeAll()
        rankKeyR.removeAll()
        mostNumberS = [0,0,0]
        mostNumberR = [0,0,0]
        
        print(kyotakuVM.turn)
        
        for a in kyotakuVM.turn{
            //サービスの配列データ追加
            if(a.service == SelectPlayer){
                TestDataS1 += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                switch a.winner {
                case 0:
                    if(SelectPlayer == 0 || SelectPlayer == 1){
                        TestDataST1 += [1]
                    }else{
                        TestDataST1 += [0]
                    }
                case 1:
                    if(SelectPlayer == 0 || SelectPlayer == 1){
                        TestDataST1 += [0]
                    }else{
                        TestDataST1 += [1]
                    }
                default:
                    break
                }
            }
            //レシーブの配列データ追加
            if(a.receive == SelectPlayer){
                TestDataR1 += [[a.s_pos,a.s_style,a.r_pos,a.r_style]]
                switch a.winner {
                case 0:
                    if(SelectPlayer == 0 || SelectPlayer == 1){
                        TestDataRT1 += [1]
                    }else{
                        TestDataRT1 += [0]
                    }
                case 1:
                    if(SelectPlayer == 0 || SelectPlayer == 1){
                        TestDataRT1 += [0]
                    }else{
                        TestDataRT1 += [1]
                    }
                default:
                    break
                }
            }
        }
        //配列内の重複を取得
        var numToCountS: [[Int]: Int] = [:]
        var numToCountR: [[Int]: Int] = [:]
        for elt in TestDataS1 {
            numToCountS[elt, default: 0] += 1
        }
        for elt in TestDataR1 {
            numToCountR[elt, default: 0] += 1
        }
        //重複した回数が多い順に並び替え
        //key コース value 出現回数
        rankKeyS = numToCountS.sorted { (-$0.value) < (-$1.value) }.map{$0.key}
        rankValueS = numToCountS.sorted { (-$0.value) < (-$1.value) }.map{$0.value}
        
        rankKeyR = numToCountR.sorted { (-$0.value) < (-$1.value) }.map{$0.key}
        rankValueR = numToCountR.sorted { (-$0.value) < (-$1.value) }.map{$0.value}
        //上位３つの得点数を出力
        var count = 0
        
        TestDataS1.forEach(){data in
            
            if(rankKeyS.count >= 1 && rankKeyS[0] == data){
                if(TestDataST1[count] == 1){
                    
                    mostNumberS[0] += 1
                }
            }else if(rankKeyS.count >= 2 && rankKeyS[1] == data){
                if(TestDataST1[count] == 1){
                    mostNumberS[1] += 1
                }
            }else if(rankKeyS.count >= 3 && rankKeyS[2] == data){
                if(TestDataST1[count] == 1){
                    mostNumberS[2] += 1
                }
            }
            count += 1
        }
        count = 0
        
        TestDataR1.forEach(){data in
            
            if(rankKeyR.count >= 1 && rankKeyR[0] == data){
                if(TestDataRT1[count] == 1){
                    mostNumberR[0] += 1
                }
            }else if(rankKeyR.count >= 2 && rankKeyR[1] == data){
                if(TestDataRT1[count] == 1){
                    mostNumberR[1] += 1
                }
            }else if(rankKeyR.count >= 3 && rankKeyR[2] == data){
                if(TestDataRT1[count] == 1){
                    mostNumberR[2] += 1
                }
            }
            count += 1
        }
    }
}



struct SiaiTourokuView: View {
    //最初のサービス権
    @State private var isCheckedS = false
    //ダブルスのレシーブ権
    @State private var isCheckedR = false
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

    var body: some View {
        
        VStack(){
            Button(action: {
                    vm.singlesOrDoubles.toggle()
            }) {
                if(vm.singlesOrDoubles){
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
                    kyotakuVM.users.forEach() { user in
                        if(!ArrayPlayer.contains(user.player_name)){
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
                    kyotakuVM.users.forEach() { user in
                        if(!ArrayPlayer.contains(user.player_name)){
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
            
            if(!vm.singlesOrDoubles){
                HStack{
                    Spacer()
                    Text("レシーブ　")
                        .font(.headline)
                }
                HStack{

                    Text("選手3:").font(.largeTitle).padding(20)
                    
                    Button(action: {
                        kyotakuVM.users.forEach() { user in
                            if(!ArrayPlayer.contains(user.player_name)){
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
                        kyotakuVM.users.forEach() { user in
                            if(!ArrayPlayer.contains(user.player_name)){
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
            NavigationLink(destination: SyozokuTourokuView()) {
                Text("").font(.title)
                                            .underline()
            }
            
            if(SelectionPlayer1 != -1 && SelectionPlayer2 != -1){
                NavigationLink(destination: MatchView1()) {
                    Text("登録").font(.title).frame(width: 200, height: 80).overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1))

                }.simultaneousGesture(TapGesture().onEnded{
                    
                    vm.PlayerArray[0] = ArrayPlayer[self.SelectionPlayer1]
                    vm.PlayerArray[1] = ArrayPlayer[self.SelectionPlayer2]
                    vm.PlayerArray[2] = SelectionPlayer3 != -1 ? ArrayPlayer[self.SelectionPlayer3] : " "
                    vm.PlayerArray[3] = SelectionPlayer4 != -1 ? ArrayPlayer[self.SelectionPlayer4] : " "
                    
                    vm.Player1 = ArrayPlayer[self.SelectionPlayer1]
                    vm.Player3 = ArrayPlayer[self.SelectionPlayer2]
                    vm.Player2 = SelectionPlayer3 != -1 ? ArrayPlayer[self.SelectionPlayer3] : " "
                    vm.Player4 = SelectionPlayer4 != -1 ? ArrayPlayer[self.SelectionPlayer4] : " "
                    
                    vm.isActiveSubView = 1
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
        if(isCheckedS){
            vm.ServicePlayer[0] = 0
            vm.ServicePlayer[2] = 1
        }else{
            vm.ServicePlayer[0] = 1
            vm.ServicePlayer[2] = 0
        }
        isCheckedS = !isCheckedS
        vm.isServicePlayer.toggle()
        vm.isNetPosition.toggle()
        UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
    }
    // タップ時の状態の切り替え
    func toggleR() -> Void {
        if(isCheckedR){
            vm.ServicePlayer[1] = 2
            vm.ServicePlayer[3] = 3
        }else{
            vm.ServicePlayer[1] = 3
            vm.ServicePlayer[3] = 2
        }
        isCheckedR = !isCheckedR
        UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
    }
}

//サービス画面
struct MatchView1: View {
    @State var array = ["横回転","縦回転","YG","バックハンド","巻き込み","しゃがみ込み"]
    @State var doubles_BattingMethod = ["横回転","下回転","YG","バックハンド","巻き込み","ロングサーブ"]
    
    @State var S_selectBattingMethod = 0
    @State var S_selectCourse = 0
    
    @EnvironmentObject var vm : ViewModel
    
    var body: some View {
            
            VStack(spacing: 5){
                
                HStack{
                    let _ = print(vm.ServicePlayer)
                    Spacer()
                    Button(action: {
                        vm.isServicePlayer.toggle()
                        vm.isNetPosition.toggle()
                        
                        if(vm.NowServerPlayer != 3){
                            vm.NowServerPlayer += 1
                        }else{
                            vm.NowServerPlayer = 0
                        }

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
                    Spacer()
                    Spacer()
                    Spacer()
                }
                
                //打法
                LazyVGrid(columns: Array(repeating: .init(.fixed(200)), count: 3), alignment: .center, spacing:10) { // カラム数の指定
                    ForEach((0...5), id: \.self) { index in
                        
                        Button(action: {
                            S_selectBattingMethod = index
                        }) {
                            Text(vm.singlesOrDoubles ? array[index] : doubles_BattingMethod[index]).font(.title)
                                .foregroundColor(S_selectBattingMethod == index ?  Color(red: 1, green: 1, blue: 1, opacity:0.4) : Color(red: 1, green: 1, blue: 1, opacity:1))
                                
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
                    Text("プレイ数:\(vm.PlayCount)")
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
                    if(vm.singlesOrDoubles){
                        if(!vm.isServicePlayer){
                            Text("\(vm.GetPointCount2) \(vm.PlayerArray[1]): 　　　　").font(.title)
                                .padding()
                        }else{
                            Text("\(vm.GetPointCount2) \(vm.PlayerArray[1]): サービス").font(.title)
                                    .padding()
                            
                        }
                    }else{
                        
                        if(vm.ServicePlayer[vm.NowServerPlayer] == 2){
                            Text("\(vm.GetPointCount2) \(vm.PlayerArray[2]): サービス \(vm.PlayerArray[3])").font(.title)
                                .padding()
                        }else if(vm.ServicePlayer[vm.NowServerPlayer] == 3){
                            Text("\(vm.GetPointCount2) \(vm.PlayerArray[2]) \(vm.PlayerArray[3]): サービス").font(.title)
                                .padding()
                        }else{
                            Text("\(vm.GetPointCount2) \(vm.PlayerArray[2])  　　　　 \(vm.PlayerArray[3])").font(.title)
                                .padding()
                        }
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
                        ForEach((0...8), id: \.self) { index in
                            
                            Button(action: {
                                S_selectCourse = index
                                
                            }) {
                                Text("").frame(width: 170, height: 105, alignment: .center)
                                    .border(Color.black , width: 1)
                            }
                            .background(S_selectCourse == index ?  Color(red: 0.3125, green: 0.664, blue: 0.613) : Color(red: 0.191, green: 0.468, blue: 0.453))
                            
                        }

                    }
                    
                    if(!vm.singlesOrDoubles){
                        if(!vm.isNetPosition){
                            Image("syasen").offset(x: 137, y: 0)
                        }else{
                            Image("syasen").offset(x: -137, y: 0)
                        }
                        
                    }
                    
                    if(vm.isNetPosition){
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
                    if(vm.singlesOrDoubles){
                        if(!vm.isServicePlayer){
                            Text("\(vm.GetPointCount1) \(vm.PlayerArray[0]): サービス").font(.title)
                                    .padding()

                        }else{
                            Text("\(vm.GetPointCount1) \(vm.PlayerArray[0]): 　　　　").font(.title)
                                .padding()
                            
                        }
                    }else{
                        if(vm.ServicePlayer[vm.NowServerPlayer] == 0){
                            Text("\(vm.GetPointCount1) \(vm.PlayerArray[0]): サービス \(vm.PlayerArray[1])").font(.title)
                                .padding()
                        }else if(vm.ServicePlayer[vm.NowServerPlayer] == 1){
                            Text("\(vm.GetPointCount1) \(vm.PlayerArray[0]) \(vm.PlayerArray[1]): サービス").font(.title)
                                .padding()
                        }else{
                            Text("\(vm.GetPointCount1) \(vm.PlayerArray[0])  　　　　\(vm.PlayerArray[1])").font(.title)
                                .padding()
                        }
                    }
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    
                    Button(action: {
                        if(vm.singlesOrDoubles){
                            S_selectCourse = 9
                        }else{
                            S_selectCourse = 8
                        }
                    }) {
                        Text("ミス").font(.title)
                            .foregroundColor(.white)
                            .frame(width: 160, height: 70, alignment: .center)
                    }
                    .background(S_selectCourse == 10 ?  Color(red: 0.3125, green: 0.664, blue: 0.613) : Color(red: 0.191, green: 0.468, blue: 0.453))
                    
                    
                    Spacer()
                }
                HStack{//サービスの場所を引数に
                    NavigationLink(destination: MatchReceiveView(S_selectBattingMethod: S_selectBattingMethod, S_selectCourse: S_selectCourse)) {
                            
                        Text("確定").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))
                        .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                        .cornerRadius(10)
                        .padding()
                        
                    }.simultaneousGesture(TapGesture().onEnded{
                        vm.isActiveSubView = 2
                    })

                }
            }
            
            .navigationBarTitle(vm.singlesOrDoubles ? vm.isServicePlayer ? "\(vm.PlayerArray[1])サービス" : "\(vm.PlayerArray[0])サービス" : "\(vm.PlayerArray[vm.ServicePlayer[vm.NowServerPlayer]])サービス" , displayMode: .inline)
            .navigationBarItems(trailing:
                    Button(action: {
                        if(vm.isActiveSubView == 2 || vm.isActiveSubView == 1){
                            vm.isActiveSubView = 3
                        }
                    }) {
                        if(vm.isActiveSubView == 2 || vm.isActiveSubView == 1){
                            Text("スコアシート")
                        }else{
                            NavigationLink(destination: ScoreView()) {
                                Text("スコアシート")
                            }
                        }
                    }
            )
            .navigationViewStyle(StackNavigationViewStyle())
        
    
    }

}
//レシーブ画面
struct MatchReceiveView: View {
    @State var array = ["チキータ","フリック","ストップ","ツッツキ","流し","ドライブ(強)","ドライブ(弱)","カット","逆チキータ"]
    
    @State var doubles_BattingMethod = ["チキータ","逆チキータ","流し","ドライブ","ツッツキ","ストップ","バックハンド","フリック"]
    
    @State var R_selectBattingMethod = 0
    @State var R_selectCourse = 0
    
    @State private var rallyCount = 0
    
    @EnvironmentObject var vm : ViewModel
    
    @State var S_selectBattingMethod: Int
    @State var S_selectCourse: Int

    
    //データモデル(Firestore)
    @ObservedObject private var kyotakuVM = KyotakuViewModel()
    
    var body: some View {
        
            VStack(spacing: 5){
                
                //打法
                LazyVGrid(columns: Array(repeating: .init(.fixed(200)), count: 3), alignment: .center, spacing:10) { // カラム数の指定
                    ForEach((vm.singlesOrDoubles ? 0...8 : 0...7), id: \.self) { index in
                        
                        Button(action: {
                            R_selectBattingMethod = index
                        }) {
                            Text(vm.singlesOrDoubles ? array[index] : doubles_BattingMethod[index]).font(.title)
                                .foregroundColor(R_selectBattingMethod == index ?  Color(red: 1, green: 1, blue: 1, opacity:0.4) : Color(red: 1, green: 1, blue: 1, opacity:1))
                                
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
                        ForEach((0...8), id: \.self) { index in
                            
                            Button(action: {
                                R_selectCourse = index
                            }) {
                                Text("").frame(width: 170, height: 105, alignment: .center)
                                    .border(Color.black , width: 1)
                            }
                            .background(R_selectCourse == index ?  Color(red: 0.3125, green: 0.664, blue: 0.613) : Color(red: 0.191, green: 0.468, blue: 0.453))
                            
                        }

                    }
                    if(!vm.isNetPosition){
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

                    NavigationLink(destination: MatchView1()) {
                        
                        Text(vm.singlesOrDoubles ? "\(vm.PlayerArray[0])Point" : "\(vm.PlayerArray[0]) & \n\(vm.PlayerArray[1]) Point").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                            .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                        .cornerRadius(10)
                        .padding()
                        
                    }.simultaneousGesture(TapGesture().onEnded{
                        //データ保存
                        if(vm.ReferenceTrun == nil && vm.ReferenceMatch == nil){
                            if(vm.singlesOrDoubles){
                                let Get_Reference = self.kyotakuVM.addMatchData(player1: vm.PlayerArray[0], player2: vm.PlayerArray[1], date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.isServicePlayer ? 0 : 1, receive: vm.isServicePlayer ? 1 : 0, winner: 0)
                                
                                vm.ReferenceGame = Get_Reference.GameReference
                                vm.ReferenceMatch = Get_Reference.MatchReference
                                vm.ReferenceTrun = Get_Reference.TurnReference
                            }else{
                                let Get_Reference = self.kyotakuVM.addDoublesMatchData(player1: vm.PlayerArray[0], player2: vm.PlayerArray[1], player3: vm.PlayerArray[2], player4: vm.PlayerArray[3], date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.ServicePlayer[vm.NowServerPlayer], receive: vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0], winner: 0)
                                
                                vm.ReferenceGame = Get_Reference.GameReference
                                vm.ReferenceMatch = Get_Reference.MatchReference
                                vm.ReferenceTrun = Get_Reference.TurnReference
                            }
                            
                        }else if(vm.ReferenceTrun == nil){
                            let Get_Reference = self.kyotakuVM.addNextGameData(date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.singlesOrDoubles ? vm.isServicePlayer ? 0 : 1 : vm.ServicePlayer[vm.NowServerPlayer], receive: vm.singlesOrDoubles ? vm.isServicePlayer ? 1 : 0 : vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0],  winner: 0, Ref: vm.ReferenceGame!)
                            
                            vm.ReferenceMatch = Get_Reference.MatchReference
                            vm.ReferenceTrun = Get_Reference.TurnReference
                            
                        }else{
                            self.kyotakuVM.addtestData(date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.singlesOrDoubles ? vm.isServicePlayer ? 0 : 1 : vm.ServicePlayer[vm.NowServerPlayer], receive: vm.singlesOrDoubles ? vm.isServicePlayer ? 1 : 0 : vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0],  winner: 0, Ref: vm.ReferenceMatch!)
                        }
                        //入力回数
                        vm.PlayCount += 1
                        //サーバー入れ替え処理
                        if(vm.PlayCount != 0 && vm.PlayCount % 2 == 0){
                            //シングルス用
                            vm.isServicePlayer.toggle()
                            //ダブルス用
                            if(vm.NowServerPlayer != 3){
                                vm.NowServerPlayer += 1
                            }else{
                                vm.NowServerPlayer = 0
                            }
                            //共通
                            vm.isNetPosition.toggle()
                           
                        }
                        //得点加算
                        vm.GetPointCount1 += 1
                        
                        vm.isActiveSubView = 1
                    })

                    
                    
                    NavigationLink(destination: MatchView1()) {
                        
                        Text(vm.singlesOrDoubles ? "\(vm.PlayerArray[1])Point" : "\(vm.PlayerArray[2]) & \n\(vm.PlayerArray[3]) Point").font(.title)
                        .foregroundColor(.white)
                        .frame(width: 180, height: 70).overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2))
                            .background(Color(red: 0.246, green: 0.5, blue: 0.992))
                        .cornerRadius(10)
                        .padding()
                    }.simultaneousGesture(TapGesture().onEnded{
                        
                        if(vm.ReferenceTrun == nil && vm.ReferenceMatch == nil){
                            
                            if(vm.singlesOrDoubles){
                                let Get_Reference = self.kyotakuVM.addMatchData(player1: vm.PlayerArray[0], player2: vm.PlayerArray[1], date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.isServicePlayer ? 0 : 1, receive: vm.isServicePlayer ? 1 : 0, winner: 1)
                                
                                vm.ReferenceMatch = Get_Reference.MatchReference
                                vm.ReferenceTrun = Get_Reference.TurnReference
                            }else{
                                let Get_Reference = self.kyotakuVM.addDoublesMatchData(player1: vm.PlayerArray[0], player2: vm.PlayerArray[1], player3: vm.PlayerArray[2], player4: vm.PlayerArray[3], date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.ServicePlayer[vm.NowServerPlayer], receive: vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0], winner: 1)
                                
                                vm.ReferenceMatch = Get_Reference.MatchReference
                                vm.ReferenceTrun = Get_Reference.TurnReference
                            }
                            
                        }else if(vm.ReferenceTrun == nil){
                            let Get_Reference = self.kyotakuVM.addNextGameData(date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.singlesOrDoubles ? vm.isServicePlayer ? 0 : 1 : vm.ServicePlayer[vm.NowServerPlayer], receive: vm.singlesOrDoubles ? vm.isServicePlayer ? 1 : 0 : vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0],  winner: 1, Ref: vm.ReferenceGame!)
                            
                            vm.ReferenceMatch = Get_Reference.MatchReference
                            vm.ReferenceTrun = Get_Reference.TurnReference
                            
                        }else{
                            self.kyotakuVM.addtestData(date: Date(), r_pos: R_selectCourse, r_style: R_selectBattingMethod, s_pos: S_selectCourse, s_style: S_selectBattingMethod, rallyCount: rallyCount, service: vm.singlesOrDoubles ? vm.isServicePlayer ? 0 : 1 : vm.ServicePlayer[vm.NowServerPlayer], receive: vm.singlesOrDoubles ? vm.isServicePlayer ? 1 : 0 : vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0], winner: 1, Ref: vm.ReferenceMatch!)
                        }
                        //入力回数
                        vm.PlayCount += 1
                        //サーバー入れ替え処理
                        if(vm.PlayCount != 0 && vm.PlayCount % 2 == 0){
                            //シングルス用
                            vm.isServicePlayer.toggle()
                            //ダブルス用
                            if(vm.NowServerPlayer != 3){
                                vm.NowServerPlayer += 1
                            }else{
                                vm.NowServerPlayer = 0
                            }
                            //共通
                            vm.isNetPosition.toggle()
                           
                        }
                        //得点加算
                        vm.GetPointCount2 += 1

                        //表示View変更
                        vm.isActiveSubView = 1
                    })

                }
                
                
                }
            
            .navigationBarTitle(vm.singlesOrDoubles ? vm.isServicePlayer ? "\(vm.PlayerArray[0])レシーブ" : "\(vm.PlayerArray[1])レシーブ" : "\(vm.PlayerArray[vm.ServicePlayer[vm.NowServerPlayer != 3 ? vm.NowServerPlayer + 1 : 0]])レシーブ", displayMode: .inline)
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
    
    var body: some View {
        
        HStack{
            if(vm.SetURL == ""){
                NavigationLink(destination: MatchView1()) {
                    Text("NEXT GAME").font(.title)
                    .foregroundColor(.white)
                    .frame(width: 180, height: 70).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))
                        .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                    .cornerRadius(10)
                    .padding()
                }.simultaneousGesture(TapGesture().onEnded{
                    vm.isActiveSubView = 1
                    //得点・サーバー・参照を更新する
                    vm.GetPointCount1 = 0
                    vm.GetPointCount2 = 0
                    vm.PlayCount = 0
                    vm.tmpServicePlayer.toggle()
                    vm.isServicePlayer = vm.tmpServicePlayer
                    //サーバーの入れ替え
                    vm.ServicePlayer.swapAt(0, 1)
                    vm.ServicePlayer.swapAt(2, 3)
                    //参照位置を初期化
                    vm.NowServerPlayer = 0
                    //firestoreのTrunまでの参照の初期化
                    vm.ReferenceTrun = nil
                })
            }else{

                NavigationLink(destination: SetURLView()) {
                    Text("NEXT GAME").font(.title)
                    .foregroundColor(.white)
                    .frame(width: 180, height: 70).overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 2))
                        .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                    .cornerRadius(10)
                    .padding()
                }.simultaneousGesture(TapGesture().onEnded{
                    vm.isActiveSubView = 1
                    //得点・サーバー・参照を更新する
                    vm.GetPointCount1 = 0
                    vm.GetPointCount2 = 0
                    vm.PlayCount = 0
                    vm.tmpServicePlayer.toggle()
                    vm.isServicePlayer = vm.tmpServicePlayer
                    //サーバーの入れ替え
                    vm.ServicePlayer.swapAt(0, 1)
                    vm.ServicePlayer.swapAt(2, 3)
                    //参照位置を初期化
                    vm.NowServerPlayer = 0
                    //firestoreのTrunまでの参照の初期化
                    vm.ReferenceTrun = nil
                })
            }
            
            
            NavigationLink(destination: ContentView()) {
                Text("GAME SET").font(.title)
                .foregroundColor(.white)
                .frame(width: 180, height: 70).overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black, lineWidth: 2))
                    .background(Color(red: 0.917, green: 0.25, blue: 0.468))
                .cornerRadius(10)
                .padding()
            }.simultaneousGesture(TapGesture().onEnded{
                vm.isActiveSubView = 0
                //得点の更新
                vm.GetPointCount1 = 0
                vm.GetPointCount2 = 0
                //プレー数の更新
                vm.PlayCount = 0
                //サーバーの更新
                vm.ServicePlayer = [0,2,1,3]
                vm.NowServerPlayer = 0
                //firestoreのMatchまでの参照の初期化
                vm.ReferenceMatch = nil
                //firestoreのTrunまでの参照の初期化
                vm.ReferenceTrun = nil
                //サーバー・ネット位置の更新
                vm.isServicePlayer = false
                vm.isNetPosition = false
                //動画URLの初期化
                vm.SetURL = ""
            })
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
            
            path.addLine(to: CGPoint(x: 17, y: 35))
            path.addLine(to: CGPoint(x: 13, y: 35))

            
        }.fill(Color(red: 0.917, green: 0.25, blue: 0.468))// 塗りつぶし色指定
        .frame(width: 30, height: 230)
        
        Path { path in
            path.move(to: CGPoint(x: 45, y: 0))        // 始点移動
            path.addLine(to: CGPoint(x: 60, y: 35))     // 直線描画
            path.addLine(to: CGPoint(x: 30, y: 35))
            path.addLine(to: CGPoint(x: 45, y: 0))
            
            path.addLine(to: CGPoint(x: 47, y: 35))
            path.addLine(to: CGPoint(x: 43, y: 35))

            
        }.fill(Color(red: 0.5, green: 0.25, blue: 0.468))// 塗りつぶし色指定
        .frame(width: 30, height: 230)
        
        VStack{
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
                        //重複していないものを追加
                        kyotakuVM.groups.forEach() { groups in
                            if(!ArrayGroup.contains(groups.group)){
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

















//以下ログイン機能(現状保留・機能的には動作)
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
