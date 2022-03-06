//
//  KyotakuViewModel.swift
//  kyoutaku
//
//  Created by k18004kk on 2021/05/20.
//  Copyright © 2021 AIT. All rights reserved.
//
import Foundation
import Firebase
//シングルス
struct singlesDataType: Identifiable {
    var id: String = UUID().uuidString
    var DocumentId = String()
    var player1: String
    var player2: String
    var array: [String]
    var date: [Int]
    var Count: Int
}
//ダブルス
struct doublesDataType: Identifiable {
    var id: String = UUID().uuidString
    var DocumentId = String()
    var player1: String
    var player2: String
    var player3: String
    var player4: String
    var array: [String]
    var date: [Int]
    var Count: Int
}
//試合データ
struct matchDataType: Identifiable {
    var id: String = UUID().uuidString
    var date: String
}
//プレーデータ
struct turnDataType: Identifiable {
    var id: String = UUID().uuidString
    var service: Int //(選手ID)
    var receive: Int //(選手ID)
    var s_pos: Int //(左上から012345678)
    var s_style: Int //(横回転:0, 縦回転:1, YG:2, バックハンド:3,　巻き込み:4, しゃがみ込み:5)
    var r_pos: Int //(左上から012345678)
    var r_style: Int //(チキータ:0, フリック:1, ストップ:2, ツッツキ:3,　流し:4, ドライブ(強):5, ドライブ(弱):6, カット:7, 逆チキータ:8)
    var winner: Int //(勝ち:1, 負け:0)
    var rallyCount: Int //(ラリー回数)
    var date: [Int]

}
//選手情報
struct userDataType: Identifiable {
    var id: String = UUID().uuidString
    var group: String
    var player_name: String
    var handedness: Int
    var rubber: Int
}
//所属情報
struct groupDataType: Identifiable {
    var id: String = UUID().uuidString
    var group: String
}

class KyotakuViewModel: ObservableObject {
    
    @Published var singles = [singlesDataType]()
    @Published var doubles = [doublesDataType]()
    @Published var users = [userDataType]()
    @Published var groups = [groupDataType]()
    @Published var match = [matchDataType]()
    @Published var turn = [turnDataType]()
    
    private var db = Firestore.firestore()
    
    init() {
    }
    
    func addData(user: Int , player1: Int, player2: Int) {
        let data = [
            "make_user": user,
            "player1_id": player1,
            "player2_id": player2
        ]

        let db = Firestore.firestore()

        db.collection("singles").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            print("success")
        }
    }
    
    func addUserData(handedness: Int, player_name: String, rubber:Int, group1: String,  group2: String,  group3: String,  group4: String) {
        let data = [
            "handedness": handedness,
            "player_name": player_name,
            "rubber" : rubber
        ] as [String : Any]
        
        let data2 = [
            "group1": group1,
            "group2": group2,
            "group3": group3,
            "group4": group4
        ] as [String : Any]

        let db = Firestore.firestore()

        db.collection("user").addDocument(data: data).collection("group").addDocument(data: data2) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            print("success")
        }
    }
    
    func addMatchData(player1: String, player2: String, date: Date, r_pos: Int, r_style : Int, s_pos: Int, s_style: Int, rallyCount: Int, service: Int, receive: Int, winner: Int) -> (GameReference: DocumentReference, MatchReference: DocumentReference, TurnReference: DocumentReference) {
        
        let data1 = [
            "player1": player1,
            "player2" : player2
        ] as [String : Any]

        let data2 = [
            "date": date
        ] as [String : Any]
        
        let data3 = [
            "r_pos": r_pos,
            "r_style": r_style,
            "s_pos": s_pos,
            "s_style": s_style,
            "rallyCount": rallyCount,
            "service": service,
            "receive": receive,
            "winner": winner
        ] as [String : Any]

        let db = Firestore.firestore()
        let newCityRef1 = db.collection("singles").document()
        let newCityRef2 = newCityRef1.collection("match").document()
        let newCityRef3 = newCityRef2.collection("turn").document()
        
        newCityRef1.setData(data1)
        newCityRef2.setData(data2)
        newCityRef3.setData(data3)
        
        return(newCityRef1, newCityRef2, newCityRef3)

    }
    
    func addDoublesMatchData(player1: String, player2: String, player3: String, player4: String, date: Date, r_pos: Int, r_style : Int, s_pos: Int, s_style: Int, rallyCount: Int, service: Int, receive: Int,winner: Int) -> (GameReference: DocumentReference, MatchReference: DocumentReference, TurnReference: DocumentReference) {
        
        let data1 = [
            "player1": player1,
            "player2" : player2,
            "player3": player3,
            "player4" : player4
        ] as [String : Any]

        let data2 = [
            "date": date
        ] as [String : Any]
        
        let data3 = [
            "r_pos": r_pos,
            "r_style": r_style,
            "s_pos": s_pos,
            "s_style": s_style,
            "rallyCount": rallyCount,
            "service": service,
            "receive": receive,
            "winner": winner
        ] as [String : Any]

        let db = Firestore.firestore()
        let newCityRef1 = db.collection("doubles").document()
        let newCityRef2 = newCityRef1.collection("match").document()
        let newCityRef3 = newCityRef2.collection("turn").document()
        
        newCityRef1.setData(data1)
        newCityRef2.setData(data2)
        newCityRef3.setData(data3)
        
        return(newCityRef1, newCityRef2, newCityRef3)

    }
    
    func addtestData(date: Date, r_pos: Int, r_style : Int, s_pos: Int, s_style: Int, rallyCount: Int, service: Int, receive: Int, winner: Int, Ref: DocumentReference) {
        
        let data3 = [
            "r_pos": r_pos,
            "r_style": r_style,
            "s_pos": s_pos,
            "s_style": s_style,
            "rallyCount": rallyCount,
            "service": service,
            "receive": receive,
            "winner": winner
        ] as [String : Any]

        let newCityRef3 = Ref.collection("turn").document()
        
        newCityRef3.setData(data3)
    }
    func addNextGameData(date: Date, r_pos: Int, r_style : Int, s_pos: Int, s_style: Int, rallyCount: Int, service: Int, receive: Int, winner: Int, Ref: DocumentReference) -> (MatchReference: DocumentReference, TurnReference: DocumentReference){
        
        let data2 = [
            "date": date
        ] as [String : Any]
        
        let data3 = [
            "r_pos": r_pos,
            "r_style": r_style,
            "s_pos": s_pos,
            "s_style": s_style,
            "rallyCount": rallyCount,
            "service": service,
            "receive": receive,
            "winner": winner
        ] as [String : Any]
        
        let newCityRef2 = Ref.collection("match").document()
        let newCityRef3 = newCityRef2.collection("turn").document()
        
        newCityRef2.setData(data2)
        newCityRef3.setData(data3)
        
        return(newCityRef2, newCityRef3)
    }
    
    
    func addGroupData(group: String) {
        let data = [
            "group": group
        ] as [String : Any]

        let db = Firestore.firestore()

        db.collection("group").addDocument(data: data) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            print("success")
        }
    }
    //ユーザデータの登録
    func fetchData() {
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> userDataType in
                let data = queryDocumentSnapshot.data()
                let id = data["group"] as? String ?? ""
                let name = data["player_name"] as? String ?? ""
                let handedness = data["handedness"] as? Int ?? 0
                let rubber = data["rubber"] as? Int ?? 0

                return userDataType(group: id, player_name: name, handedness: handedness, rubber: rubber)
            }
        }
    }
    //所属データの登録
    func fetchData1() {
        db.collection("group").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.groups = documents.map { (queryDocumentSnapshot) -> groupDataType in
                let data = queryDocumentSnapshot.data()
                let group = data["group"] as? String ?? ""

                return groupDataType(group: group)
            }
        }
    }
    //シングルスデータの登録
    func fetchSinglesMatchData() {
        var id = [String]()
        var id2 = [String]()
        var num = [Int]()
        var count = 0
        var createdDate = ""
        var array = [String]()
        
        db.collection("singles").addSnapshotListener { (querySnapshot, error) in
            querySnapshot?.documents.forEach{ a in
                id.append(a.documentID)
            }
            guard let documents1 = querySnapshot?.documents else {
                print("No documents")
                return
            }
            for co in 0 ..< id.count{
            self.db.collection("singles").document(id[co]).collection("match").addSnapshotListener { (querySnapshot, error) in
                querySnapshot?.documents.forEach{ a in
                    id2.append(a.documentID)
                }
                num.append(id2.count)
                print(num)
                guard let documents2 = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.match = documents2.map { (queryDocumentSnapshot1) -> matchDataType in
                    
                    let data = queryDocumentSnapshot1.data()
                    let date = data["date"] as? Timestamp
                    let formatterDate = DateFormatter()
                    formatterDate.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
                    createdDate = formatterDate.string(from: date!.dateValue())
                    array.append(createdDate)
                    count = 0

                    return matchDataType(date: createdDate)
                }
                self.singles = documents1.map { (queryDocumentSnapshot2) -> singlesDataType in
                        let data = queryDocumentSnapshot2.data()
                        let player1 = data["player1"] as? String ?? ""
                        let player2 = data["player2"] as? String ?? ""

                        count += 1
                    return singlesDataType(DocumentId: id[count - 1],player1: player1, player2: player2, array: array, date: num, Count: count - 1)
                }
            }
            }
        }
    }
    //ダブルスデータの登録
    func fetchDoublesMatchData() {
        
        var id = [String]()
        var id2 = [String]()
        var num = [Int]()
        var count = 0
        var createdDate = ""
        var array = [String]()
        
        db.collection("doubles").addSnapshotListener { (querySnapshot, error) in
            querySnapshot?.documents.forEach{ a in
                id.append(a.documentID)
            }
            guard let documents1 = querySnapshot?.documents else {
                print("No documents")
                return
            }
            for co in 0 ..< id.count{
                self.db.collection("doubles").document(id[co]).collection("match").addSnapshotListener { (querySnapshot, error) in
                    querySnapshot?.documents.forEach{ a in
                        id2.append(a.documentID)
                    }
                    num.append(id2.count)
                    
                    guard let documents2 = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    self.match = documents2.map { (queryDocumentSnapshot1) -> matchDataType in
                        
                        let data = queryDocumentSnapshot1.data()
                        let date = data["date"] as? Timestamp
                        let formatterDate = DateFormatter()
                        formatterDate.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
                        createdDate = formatterDate.string(from: date!.dateValue())
                        array.append(createdDate)
                        count = 0

                        return matchDataType(date: createdDate)
                    }
                        self.doubles = documents1.map { (queryDocumentSnapshot2) -> doublesDataType in
                                let data = queryDocumentSnapshot2.data()
                                let player1 = data["player1"] as? String ?? ""
                                let player2 = data["player2"] as? String ?? ""
                                let player3 = data["player3"] as? String ?? ""
                                let player4 = data["player4"] as? String ?? ""
                                count += 1
                            return doublesDataType(DocumentId: id[count - 1],player1: player1, player2: player2, player3: player3, player4: player4, array: array, date: num, Count: count - 1)
                        }
                }
                
            }
            
            
        }

    }
    
    //試合一覧の取得(シングル)
    func fetchDateData(SelectId: String) {
        var id = [String]()
        var id2 = [String]()
        var num = [Int]()
        var count = 0
        
        db.collection("singles").document(SelectId).collection("match").addSnapshotListener { (querySnapshot, error) in
            querySnapshot?.documents.forEach{ a in
                id.append(a.documentID)
            }

            for _ in 0 ..< id.count{
                a()
                count += 1
                print(count)
            }
            func a(){
                self.db.collection("singles").document(SelectId).collection("match").document(id[count]).collection("turn").addSnapshotListener { (querySnapshot, error) in
                    querySnapshot?.documents.forEach{ a in
                        id2.append(a.documentID)
                    }
                    num.append(id2.count)
                    guard let documents2 = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                        
                    self.turn += documents2.map { (queryDocumentSnapshot) -> turnDataType in
                            let data = queryDocumentSnapshot.data()
                            let service = data["service"] as? Int ?? 0
                            let receive = data["receive"] as? Int ?? 0
                            let s_pos = data["s_pos"] as? Int ?? 0
                            let s_style = data["s_style"] as? Int ?? 0
                            let r_pos = data["r_pos"] as? Int ?? 0
                            let r_style = data["r_style"] as? Int ?? 0
                            let winner = data["winner"] as? Int ?? 0
                            let rallyCount = data["rallyCount"] as? Int ?? 0
                        
                        return turnDataType(service: service, receive: receive, s_pos: s_pos, s_style: s_style, r_pos: r_pos, r_style: r_style, winner: winner, rallyCount: rallyCount, date: num)
                    }
                }
            }
        }
    }
    //試合一覧の取得(ダブルス)
    func fetchDateDataD(SelectId: String) {
        var id = [String]()
        var id2 = [String]()
        var num = [Int]()
        var count = 0
        
        db.collection("doubles").document(SelectId).collection("match").addSnapshotListener { (querySnapshot, error) in
            querySnapshot?.documents.forEach{ a in
                id.append(a.documentID)
            }
            
            for _ in 0 ..< id.count{
                a()
                count += 1
                print(count)
            }
            func a(){
                self.db.collection("doubles").document(SelectId).collection("match").document(id[count]).collection("turn").addSnapshotListener { (querySnapshot, error) in
                    querySnapshot?.documents.forEach{ a in
                        id2.append(a.documentID)
                    }
                    num.append(id2.count)
                    guard let documents2 = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    
                    self.turn += documents2.map { (queryDocumentSnapshot) -> turnDataType in
                            let data = queryDocumentSnapshot.data()
                            let service = data["service"] as? Int ?? 0
                            let receive = data["receive"] as? Int ?? 0
                            let s_pos = data["s_pos"] as? Int ?? 0
                            let s_style = data["s_style"] as? Int ?? 0
                            let r_pos = data["r_pos"] as? Int ?? 0
                            let r_style = data["r_style"] as? Int ?? 0
                            let winner = data["winner"] as? Int ?? 0
                            let rallyCount = data["rallyCount"] as? Int ?? 0
                        
                        return turnDataType(service: service, receive: receive, s_pos: s_pos, s_style: s_style, r_pos: r_pos, r_style: r_style, winner: winner, rallyCount: rallyCount, date: num)
                    }
                }
            }
        }
    }
}
