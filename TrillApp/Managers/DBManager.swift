//
//  DBManager.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 11/8/22.
//

import Foundation
import RealmSwift
import Realm
import RxSwift
class DBManager {
    
    static let shared: DBManager = {
        let manager = DBManager()
        do {
            manager.db = try Realm()
        } catch {
            print("Realm error")
        }
        return manager
    }()
    
    private var db: Realm?
    
    // data insert to database
    func addFavorite(article: ArticleModel) -> Completable {
        return Completable.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm add favorite error")
            
            guard let self = self else {
                observer(.error(maybeError))
                return Disposables.create()
            }
            do {
                try self.db?.write {
                    self.db?.create(ArticleModel.self,value: article,update:Realm.UpdatePolicy.all)
                    observer(.completed)
                }
            } catch {
                observer(.error(maybeError))
            }

            return Disposables.create {
                print("Disposable")
            }
        }
    }
    
    // featch fevrouite data from table
    func fetchFavorites() -> Single<[ArticleModel]> {
        return Single<[ArticleModel]>.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm fetch error")
            
            guard let self = self else {
                observer(.error(maybeError))
                return Disposables.create()
            }
            
            if let results = self.db?.objects(ArticleModel.self).sorted(byKeyPath: "createdAt", ascending: false){
                let articleArray: [ArticleModel] = Array(results)
                observer(.success(articleArray))
            } else {
                observer(.error(maybeError))
            }
            
            return Disposables.create {
                print("Disposable")
            }
        }
    }
    
    // check fav data
    func isFavorite(id: Int) -> Single<Bool> {
        return Single<Bool>.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm fetch error")
            guard let self = self else {
                observer(.error(maybeError))
                return Disposables.create()
            }
            
            if (self.db?.object(ofType: ArticleModel.self, forPrimaryKey: id)) != nil{
                observer(.success(true))
            }
            else{
                observer(.success(false))
            }
            
            return Disposables.create {
                print("Disposable")
            }
        }
    }
    // delete fav data
    func deleteFavorite(id: Int) -> Completable {
        return Completable.create { [weak self] observer in
            let maybeError = RealmError(msg: "Realm delete error")
            guard let self = self else {
                observer(.error(maybeError))
                return Disposables.create()
            }
            
            if let article = self.db?.object(ofType: ArticleModel.self, forPrimaryKey: id){
                try! self.db?.write {
                    self.db?.delete(article)
                    observer(.completed)
                }
            }
            else{
                observer(.error(maybeError))
            }
            
            return Disposables.create {
                print("Disposable")
            }
        }
    }
}

// error message
struct RealmError: Error {
    let msg: String
}
