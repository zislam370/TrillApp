//
//  APIService.swift
//  TrillDemo

//  Created by Zahidul Islam on 2022/08/08.
//

import Foundation
import RxSwift

protocol APIServiceObservable: class {
    func fetchArticles() -> Observable<[ArticleModel]>
}

// api service
final class APIService: RequestHandler, APIServiceObservable {
    static let shared = APIService()
    // json data endpoint
    let endpoint = "https://gist.githubusercontent.com/ishida-dely/79b4372791dd21a1653b8dbacaa6f9d3/raw/d792fb585dba34f44bd03c3e26fae75c75767003/articles.json"
    
    var task : URLSessionTask?
    
    // fetch data from json
    func fetchArticles() -> Observable<[ArticleModel]> {
        return Observable.create { [weak self] observer in
            guard let self = self else { return observer.onError(ErrorResult.network(string: "Something has gone wrong. Please Try Again!")) as! Disposable }
            self.cancelFetch()
            self.task = RequestService().loadData(urlString: self.endpoint,
                                                  completion: self.networkResult(){ (result: Result<[ArticleModel], ErrorResult>) in
                                                    
                                                    switch result {
                                                    case .success(let article):
                                                        observer.onNext(article)
                                                        
                                                    case .failure(let error):
                                                        observer.onError(error)
                                                    }
                                                    
                                                    observer.onCompleted()
                
            })
            
            self.task?.resume()
            
            return Disposables.create {
                self.task?.cancel()
            }
        }
    }
    
    // cancel fetch data
    func cancelFetch() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
