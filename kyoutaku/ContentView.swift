//
//  ContentView.swift
//  kyoutaku
//
//  Created by k18004kk on 2021/03/17.
//  Copyright © 2021 AIT. All rights reserved.
//

import SwiftUI
import FirebaseAuth

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
    @State private var name1 = ""
    @State private var name2 = ""
    
    @State private var isChecked = false
//    @State private var selectedIndex = 0
    var body: some View {
        VStack(spacing: 15){
            HStack{
                Spacer()
                Text("サービス　　 ").font(.headline)
                    .colorMultiply(.blue)
            }
            HStack{
                Text("選手1:").font(.largeTitle)
                TextField("選手名", text: $name1)
                    .frame(width: 500, height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
                    .font(.largeTitle)
                    .padding()
                
                
                Button(action: toggle) {
                            if(!isChecked) {
                                Image(systemName: "checkmark.square.fill")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .leading)
                            .foregroundColor(.green)
                            } else {
                                Image(systemName: "square")
                                    .resizable()
                                    .frame(width: 50, height: 50, alignment: .leading)
                            }
                }
                
            }
            HStack{
                Text("選手2:").font(.largeTitle)
                TextField("選手名", text: $name2)
                    .frame(width: 500, height: 50, alignment: .center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
                    .font(.largeTitle)
                    .padding()
                
                Button(action: toggle) {
                            if(isChecked) {
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
                
            }
            HStack {
                NavigationLink(destination: TourokuView()) {
                    Text("　　＊新たな選手を登録する").font(.title)
                                                .underline()
                }
                Spacer()
            }
            
            NavigationLink(destination: MatchView1()) {
                Text("登録").font(.title).frame(width: 200, height: 80).overlay(
                RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 1))
            }
            Spacer()
        }
    }
    
    // タップ時の状態の切り替え
    func toggle() -> Void {
        isChecked = !isChecked
        UIImpactFeedbackGenerator(style: .medium)
        .impactOccurred()
    }
}

struct MatchView1: View {
    var body: some View {
                VStack(spacing: 10){
                    HStack{

                        NavigationLink(destination: MatchView2()) {
                            Text("サービス交代").font(.title).frame(width: 200, height: 80).overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 1))
                            .padding(40)
                        }
                        Spacer()
                        NavigationLink(destination: Timeout()) {
                            Text("タイムアウト").font(.title).frame(width: 200, height: 80).overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.red, lineWidth: 1))
                            .padding(40)
                        }
                            
                    }
                    HStack{
                        Button(action: {

                        }) {
                            Text("横回転").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                    .padding()
                        }
                        Button(action: {

                        }) {
                            Text("縦回転").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                    .padding()
                        }
                        Button(action: {

                        }) {
                            Text("YG").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                    .padding()
                        }
                            
                    }
                    HStack{
                        Button(action: {

                        }) {
                            Text("バックハンド").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                    .padding()
                        }
                        Button(action: {

                        }) {
                            Text("巻き込み").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                    .padding()
                        }
                        Button(action: {

                        }) {
                            Text("しゃがみ込み").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 1))
                                    .padding()
                        }
                            
                    }
                    HStack{
                        Button(action: {

                        }) {
                            Text("コート反転").font(.title).frame(width: 200, height: 80).overlay(
                                RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.green, lineWidth: 1))
                                    .padding()
                        }
                        Spacer()
                            
                    }
                    Spacer()
                }.navigationBarTitle("選手1サービス", displayMode: .inline)
            .navigationBarItems(trailing:
                    Button(action: {

                    }) {
                        Text("スコアシート")
                    }
            )
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(true)
    
    }
}

struct MatchView2: View {
    var body: some View {
            VStack(spacing: 10){
                HStack{
                    NavigationLink(destination: MatchView1()) {
                        Text("サービス交代").font(.title).frame(width: 200, height: 80).overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 1))
                            .padding()
                    }
                        Spacer()
                        NavigationLink(destination: Timeout()) {
                            Text("タイムアウト").font(.title).frame(width: 200, height: 80).overlay(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1))
                                .padding()
                        }
                        
                    }
                    Spacer()
                }.navigationBarTitle("選手2サービス", displayMode: .inline)
        .navigationBarItems(trailing:
                Button(action: {

                }) {
                    Text("スコアシート")
                }
        )
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
        
    }
}

struct Timeout: View {
    var body: some View {
        VStack(spacing: 15){
            Text("タイムアウトView")
        }
    }
}



struct TourokuView: View {
    @State private var name = ""
    @State private var group = ""
    @State private var kikite = ""
    
    var body: some View {
        Text("選手名:").font(.largeTitle)
        TextField("選手名", text: $name)
            .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
        .font(.largeTitle)
        
        Text("所属:").font(.largeTitle)
        TextField("所属", text: $group)
            .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
        .font(.largeTitle)
        
        Text("利き手:").font(.largeTitle)
        TextField("利き手", text: $kikite)
            .textFieldStyle(RoundedBorderTextFieldStyle())  // 入力域のまわりを枠で囲む
        .font(.largeTitle)
        
        NavigationLink(destination: SecondView()) {
            Text("登録").font(.title).frame(width: 200, height: 80).overlay(
            RoundedRectangle(cornerRadius: 10)
            .stroke(Color.blue, lineWidth: 1))
        }
        Spacer()
    }
}



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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

