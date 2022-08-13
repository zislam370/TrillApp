//
//  FevCollectionViewCell.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/10.
//

import UIKit
import SwiftUI
import RxSwift
import RxCocoa


class FevCollectionViewCell: UICollectionViewCell {
    
    var article: ArticleModel?
    let favViewModel = FavouriteViewModel()
    var delegate: FavoriteCollectionViewCellDelegate?
    
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
        fevBtn.setImage(UIImage(systemName: "suit.heart.fill" ), for: .normal)
        articleImage.roundCorners([.topLeft, .topRight], radius: 5)
    }
    // Mark: buttion action
    @IBAction func favBtnPress(button: UIButton) {
        button.setImage(UIImage(systemName: "suit.heart" ), for: .normal)
        //self.favViewModel.deleteFavorite(id: article!.id)
        //self.favViewModel.fetchFavorites()
        self.delegate?.removeFavorite(article: article!)
    }
}
