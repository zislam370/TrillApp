//
//  ArticleModel.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/08.
//

import Foundation
import RealmSwift

final class ArticleModel: Object {
    @Persisted(primaryKey: true) var id : Int
    @Persisted var title : String
    @Persisted var thumbnail: String
    @Persisted var views: Int
    @Persisted var medium: String
    @Persisted var createdAt: Date? = Date()
    
}

// parceable method
extension ArticleModel: Parseable {
    static func parseObject(dictionary: [String : AnyObject]) -> Result<ArticleModel, ErrorResult> {
        if let id = dictionary["id"] as? Int,
            let title = dictionary["title"] as? String,
            let medium = dictionary["medium"] as? String,
            let views = dictionary["views"] as? Int,
            let thumbnail = dictionary["thumbnail"] as? String {
            
            let result = ArticleModel()
            result.id = id
            result.title = title
            result.medium = medium
            result.views = views
            result.thumbnail = thumbnail

            return .success(result)
        }
        else {
            return .failure(.parser(string: "Unable to parse article response"))
        }
    }
}
