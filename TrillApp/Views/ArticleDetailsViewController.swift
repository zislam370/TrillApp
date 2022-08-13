//
//  ArticleDetailsUIViewController.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/09.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleDetailsViewController: UIViewController {
    
    let favViewModel = FavouriteViewModel()
    private let disposeBag = DisposeBag()
    var isFavorite = false
    var article: ArticleModel?
    
    @IBOutlet weak var thumnail: UIImageView!
    @IBOutlet weak var views: UILabel!
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var medium: UILabel!
    @IBOutlet weak var favBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // data from model
        thumnail.image = UIImage(url: URL(string: article!.thumbnail))
        articleTitle.text = article?.title
        views.text = String(article!.views) as String + " Views"
        medium.text = article?.medium
        thumnail.roundCorners([.topLeft, .topRight], radius: 5)
        // cehck favorite
        self.checkIsFavorite()
    }
    
    //Mark: button action
    @IBAction func favBtnPress(button: UIButton){
        if(self.isFavorite){
            button.setImage(UIImage(systemName: "suit.heart" ), for: .normal)
            self.favViewModel.deleteFavorite(id: article!.id)
            self.isFavorite = false
        }
        else{
            button.setImage(UIImage(systemName: "suit.heart.fill" ), for: .normal)
            self.favViewModel.addFavorite(article: article!)
            self.isFavorite = true
        }
    }
    
    func checkIsFavorite(){
        self.favViewModel.manager.isFavorite(id: article!.id)
            .asObservable()
            .subscribe {[self] isFav in
                self.isFavorite = isFav
                self.favBtn.setImage(UIImage(systemName: isFav ? "suit.heart.fill" : "suit.heart" ), for: .normal)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }

}
