
//  Result.swift
//  TrillDemo

//  Created by Zahidul Islam on 2022/08/08.


import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

