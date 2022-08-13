//
//  RequestHandler.swift

//  TrillDemo
//  Created by Zahidul Islam on 2022/08/08.

import Foundation

class RequestHandler {
    let reachability = Reachability()!
    
    // For an array data
    func networkResult<T: Parseable>(completion: @escaping ((Result<[T], ErrorResult>) -> Void)) -> ((Result<Data, ErrorResult>) -> Void) {
        return { dataResult in
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)

                case .failure(let error) :
                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                }
            })
        }
    }
    
}
