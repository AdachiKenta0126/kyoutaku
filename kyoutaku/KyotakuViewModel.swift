//
//  KyotakuViewModel.swift
//  kyoutaku
//
//  Created by k18004kk on 2021/05/20.
//  Copyright © 2021 AIT. All rights reserved.
//
import Foundation
import Firebase

struct singlesDataType: Identifiable {
    var id: String
    var make_user: Int
    var player1_id: Int
    var player2_id: Int
}

struct matchDataType: Identifiable {
    var id: String
    var date: Timestamp
    var movie_url: String
    var movie_time: Float
    var match_date: String
}

struct turnDataType: Identifiable {
    var id: String
    var service: Int //(選手ID)
    var s_pos: Int //(左上から012345678)
    var s_style: Int //(横回転:0, 縦回転:1, YG:2, バックハンド:3,　巻き込み:4, しゃがみ込み:5)
    var r_pos: Int //(左上から012345678)
    var r_style: Int //(チキータ:0, フリック:1, ストップ:2, ツッツキ:3,　流し:4, ドライブ(強):5, ドライブ(弱):6, カット:7, 逆チキータ:8)
    var winner: Int //(勝ち:1, 負け:0)
    var rallyCount: Int //(ラリー回数)
}

struct userDataType: Identifiable {
    var id: String = UUID().uuidString
    var group_id: String
    var player_name: String
    var handedness: Int
    var rubber: Int
}

struct groupDataType: Identifiable {
    var id: String = UUID().uuidString
    var group: String
}

class KyotakuViewModel: ObservableObject {
    
    @Published var singles = [singlesDataType]()
    @Published var users = [userDataType]()
    @Published var groups = [groupDataType]()
    private var db = Firestore.firestore()
    
    init() {

        db.collection("singles").addSnapshotListener { (snap, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let snap = snap {
                for i in snap.documentChanges {
                    if i.type == .added {
                        let make_user = i.document.get("make_user") as! Int
                        let player1_id = i.document.get("player1_id") as! Int
                        let player2_id = i.document.get("player2_id") as! Int

                        let id = i.document.documentID

                        self.singles.append(singlesDataType(id: id, make_user: make_user, player1_id: player1_id, player2_id: player2_id))
                    }
                }
            }
        }
        
        
//        db.collection("user").addSnapshotListener { (snap, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            if let snap = snap {
//                for i in snap.documentChanges {
//                    if i.type == .added {
//
//
//                        let group_id = i.document.get("group_id") as! String
//                        let player_name = i.document.get("player_name") as! String
//                        let handedness = i.document.get("handedness") as! Int
//                        let rubber = i.document.get("rubber") as! String
//
//                        let id = i.document.documentID
//
//                        self.users.append(userDataType(id: id, group_id: group_id, player_name: player_name, handedness: handedness, rubber: rubber))
//                    }
//                }
//            }
//        }
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
//            "group_id": group_id,
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
    
    func fetchData() {
        db.collection("user").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.users = documents.map { (queryDocumentSnapshot) -> userDataType in
                let data = queryDocumentSnapshot.data()
                let id = data["group_id"] as? String ?? ""
                let name = data["player_name"] as? String ?? ""
                let handedness = data["handedness"] as? Int ?? 0
                let rubber = data["rubber"] as? Int ?? 0

                return userDataType(group_id: id, player_name: name, handedness: handedness, rubber: rubber)
            }
        }
    }
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
}
