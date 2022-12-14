//
//  RequestService.swift

//  TrillDemo
//  Created by Zahidul Islam on 2022/08/08.
//

import Foundation

// service request
final class RequestService {
    func loadData(urlString: String,
                  session: URLSession = URLSession(configuration: .default),
                  completion: @escaping (Result<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        
        var request = RequestFactory.request(method: .GET, url: url)
        
        if let reachability = Reachability(), !reachability.isReachable {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                return
            }
            
            if let data = data {
                completion(.success(data))
            }
        }
        
        task.resume()
        return task
    }
}

