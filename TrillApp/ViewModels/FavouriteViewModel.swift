//
//  FavouriteViewModel.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 11/8/22.
//

import Foundation
import RxSwift
import RxCocoa

class FavouriteViewModel {
    
    let manager = DBManager.shared
    private let disposeBag = DisposeBag()
    
    let favoriteArticlesRelay = PublishRelay<[ArticleModel]>()
    let isFavoriteRelay = PublishRelay<Bool>()
    let errorRelay = PublishRelay<String>()
    
    // add favouite
    func addFavorite(article: ArticleModel) {
            manager
                .addFavorite(article: article)
                .subscribe { [weak self] in
                    self?.fetchFavorites()
                } onError: { [weak self] error in
                    self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
                }
                .disposed(by: disposeBag)
    }
    
    // delete favouite
    func deleteFavorite(id: Int) {
            manager
                .deleteFavorite(id: id)
                .subscribe { [weak self] in
                    self?.fetchFavorites()
                } onError: { [weak self] error in
                    self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
                }
                .disposed(by: disposeBag)
    }
    
    // data feach from favrouite
    func fetchFavorites() {
        manager.fetchFavorites()
                .asObservable()
                .subscribe { [weak self] articles in
                    self?.favoriteArticlesRelay.accept(articles)
                } onError: { [weak self] error in
                    self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
                }
                .disposed(by: disposeBag)
    }
    
    //check favrouite data
    func isFavorite(id: Int) {
        manager.isFavorite(id: id)
                .asObservable()
                .subscribe { [weak self] isFav in
                    self?.isFavoriteRelay.accept(isFav)
                } onError: { [weak self] error in
                    self?.errorRelay.accept(self?.getErrorMsg(error) ?? "Unexpected error")
                }
                .disposed(by: disposeBag)
    }
    // error message Realm
    private func getErrorMsg( _ error: Error) -> String? {
            (error as? RealmError)?.msg
    }
}
