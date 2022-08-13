//
//  ArticleCollectionViewCell.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/08.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa

class ArticleCollectionViewCell: UICollectionViewCell {

    var article: ArticleModel?
    var delegate: ArticleCollectionViewCellDelegate?
    var isFavorite = false
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var medium: UILabel!
    @IBOutlet weak var fevBtn: UIButton!
    
    func setup(with articalModel:ArticleModel){
        self.article = articalModel
        articleImage.image = UIImage(url: URL(string: articalModel.thumbnail))
        title.text = articalModel.title
        views.text = String(articalModel.views) + "  views"
        medium.text = articalModel.medium
        articleImage.roundCorners([.topLeft, .topRight], radius: 5)
    }
    
    //Mark: button action
    @IBAction func favBtnPress(button: UIButton) {
        //check favrouit 
        if(self.isFavorite){
            self.isFavorite = false
            print("remove call")
            button.setImage(UIImage(systemName: "suit.heart" ), for: .normal)
            self.delegate?.removeFavorite(article: article!)
            
        }
        else{
            
            self.isFavorite = true
            print("add call")
            button.setImage(UIImage(systemName: "suit.heart.fill" ), for: .normal)
            self.delegate?.addFavorite(article: article!)
            

        }
    }
}
