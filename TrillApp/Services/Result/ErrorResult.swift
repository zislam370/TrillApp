//
//  ErrorResult.swift
//  TrillDemo
//  Created by Zahidul Islam on 2022/08/08.


import Foundation

// error result
enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
    
    var localizedDescription: String {
        switch self {
        case .network(let value):   return value
        case .parser(let value):    return value
        case .custom(let value):    return value
        }
    }
}
