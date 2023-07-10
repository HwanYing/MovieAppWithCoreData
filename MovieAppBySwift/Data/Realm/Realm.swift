//
//  Realm.swift
//  MovieAppBySwift
//
//  Created by 梁世仪 on 2023/7/7.
//

import Foundation
import RealmSwift

class MovieDBRealm {
    
    static let shared = MovieDBRealm()
    let realm = try! Realm()
    
    private init() {
        print("Realm Default is at \(realm.configuration.fileURL?.absoluteString ?? "undefined")")

    }
    
}
