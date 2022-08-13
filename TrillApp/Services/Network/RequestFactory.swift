//
//  RequestFactory.swift
//  TrillDemo
//  Created by Zahidul Islam on 2022/08/08.


import Foundation

final class RequestFactory {
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
        case PATCH
    }
    
    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
