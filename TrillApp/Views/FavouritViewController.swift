//
//  FavouritViewController.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/08.
//

import UIKit
import RxSwift
import RxCocoa

class FavouritViewController: UIViewController {
    
    
    @IBOutlet weak var fevCollectionView: UICollectionView!
    
    let itemsPerRow: CGFloat = 2
    let sectionInsets = UIEdgeInsets.init(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    
    let viewModel = FavouriteViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add custom back button
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        // set coleection view data source and layout
        fevCollectionView.delegate = self
        fevCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        // 
        self.bindViews()
        self.loadFavorites()
        
        // item select and go details page
        fevCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let model = try? self?.fevCollectionView.rx.model(at: indexPath) as ArticleModel?
            self?.performSegue(withIdentifier: AppConstants.articleDetailSegue , sender: model)
            self?.fevCollectionView.deselectItem(at:indexPath, animated: true)
                    
        }).disposed(by: disposeBag)
    }
    

    // view bind for data
    private func bindViews() {
        self.viewModel
                .favoriteArticlesRelay
                .asDriver(onErrorJustReturn: [])
                .map { list -> [ArticleModel] in
                    return list
                }
                .drive(
                    self.fevCollectionView.rx.items(cellIdentifier: "FevCollectionViewCell",cellType: FevCollectionViewCell.self)) { (row, article, cell) in
                                    cell.setup(with:article)
                        cell.delegate = self
                        print(">>>>>>>>>>=======\(article.id)")
                }
                .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadFavorites()
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
    }
    
    private func showError(_ errorMessage: String) {
        let controller = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    private func loadFavorites() {
        viewModel.fetchFavorites()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.articleDetailSegue {
            let destinationVC = segue.destination as? ArticleDetailsViewController
            destinationVC?.hidesBottomBarWhenPushed = true
            if let article = sender as? ArticleModel  {
                destinationVC?.article = article
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Hide the navigation bar on the this view controller
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

}
extension FavouritViewController: UICollectionViewDelegateFlowLayout {

    // collectionview cell hight width
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var widthPerItem  = CGSize.init(width: 200, height: 190)
        let paddingSpace = sectionInsets.left * (itemsPerRow * 1)
        let availbleWidth = view.frame.width - paddingSpace
        let height = (availbleWidth/itemsPerRow)
        widthPerItem = CGSize.init(width: availbleWidth/itemsPerRow, height: height)
        return widthPerItem

       // return CGSize(width: 100, height: 100)


    }
}


extension FavouritViewController: UICollectionViewDelegate, FavoriteCollectionViewCellDelegate {
    func removeFavorite(article: ArticleModel) {
        self.viewModel.deleteFavorite(id: article.id)
    }
}

extension UICollectionView {
    // if message no data
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
    }

    func restore() {
        self.backgroundView = nil
    }
}

protocol FavoriteCollectionViewCellDelegate {
    func removeFavorite(article: ArticleModel)
}

