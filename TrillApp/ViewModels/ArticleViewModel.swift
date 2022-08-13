//
//  ArticleViewModel.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/09.
//

import Foundation
import RxSwift
import RxCocoa

struct ArticleViewModel {
    weak var apiService: APIServiceObservable?
    let input: Input
    let output: Output
    
    
    struct Input {
        let reload: PublishRelay<Void>
    }
    
    struct Output {
        let articles: Driver<[ArticleModel]>
        let errorMessage: Driver<String>
    }
    
    // api service call
    init(apiService: APIServiceObservable = APIService.shared) {
        self.apiService = apiService
        
        let errorRelay = PublishRelay<String>()
        let reloadRelay = PublishRelay<Void>()
        
        
        let articles = reloadRelay
            .asObservable()
            .flatMapLatest({ apiService.fetchArticles() })
            .map({$0})
            .asDriver { (error) -> Driver<[ArticleModel]> in
                errorRelay.accept((error as? ErrorResult)?.localizedDescription ?? error.localizedDescription)
                return Driver.just([])
            }
        
        self.input = Input(reload: reloadRelay)
        self.output = Output(articles: articles,
                             errorMessage: errorRelay.asDriver(onErrorJustReturn: "An error happened"))
    }
}
