//
//  ArticleViewController.swift
//  TrillDemo
//
//  Created by Zahidul Islam on 2022/08/08.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleViewController: UIViewController {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var articleCollectionView: UICollectionView!
    
    let itemsPerRow: CGFloat = 2.0
    let sectionInsets = UIEdgeInsets.init(top: 1.0, left: 5.0, bottom: 1.0, right: 1.0)
    
    let viewModel = ArticleViewModel()
    let favViewModel = FavouriteViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add custom back button
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        // set coleection view data source and layout
        articleCollectionView.delegate = self
        articleCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        
        self.bindViews()
        
        // item select and go details page
        articleCollectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            let model = try? self?.articleCollectionView.rx.model(at: indexPath) as ArticleModel?
            self?.performSegue(withIdentifier: AppConstants.articleDetailSegue , sender: model)
            self?.articleCollectionView.deselectItem(at:indexPath, animated: true)}).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.viewModel.input.reload.accept(())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AppConstants.articleDetailSegue {
            let destinationVC = segue.destination as? ArticleDetailsViewController
            destinationVC?.hidesBottomBarWhenPushed = true
            if let article = sender as? ArticleModel {
                destinationVC?.article = article
            }
        }
    }
    
    // view bind for data
    private func bindViews() {
        self.viewModel.output.articles.drive(
            self.articleCollectionView.rx.items(cellIdentifier: "ArticleCollectionViewCell", cellType: ArticleCollectionViewCell.self)) { [self]
                (row, article, cell) in
                cell.setup(with:article)
                cell.delegate = self
                checkIsFavorite(article: article, cell: cell)
                
                // activity indicator hide
                self.activityIndicator.isHidden = true
        }.disposed(by: disposeBag)

        self.viewModel.output.errorMessage.drive(onNext: { [weak self] errorMessage in
            guard let self = self else { return }
            self.showError(errorMessage)
            // activity indicator hide
            self.activityIndicator.isHidden = true
        }).disposed(by: disposeBag)

        // reload data to collection view
        self.viewModel.input.reload.accept(())
    
        
    }
    
    // error message show
    private func showError(_ errorMessage: String) {
        let controller = UIAlertController(title: "An error occured", message: errorMessage, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    // alert for add favorite article
    private func showFabAlert(_ errorMessage: String) {
        let controller = UIAlertController(title: "Favourite", message: errorMessage, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
    
    // check favorite article and image change
    func checkIsFavorite(article: ArticleModel, cell: ArticleCollectionViewCell){
        self.favViewModel.manager.isFavorite(id: article.id)
            .asObservable()
            .subscribe { isFav in
                cell.isFavorite = isFav
                cell.fevBtn.setImage(UIImage(systemName: isFav ? "suit.heart.fill" : "suit.heart" ), for: .normal)
            } onError: { error in
                print(error)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // navigation bar hide
        //navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // navigation bar hide
        //navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// Mark: UICollectionView layout delegate
extension ArticleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        //var widthPerItem  = CGSize.init(width: view.frame.width, height: 0)
        var widthPerItem  = CGSize.init(width: 100, height: 0)
        let paddingSpace = sectionInsets.left * (itemsPerRow * 1)
        let availbleWidth = view.frame.width - paddingSpace
        let height = (availbleWidth/itemsPerRow)
        
        widthPerItem = CGSize.init(width: availbleWidth/itemsPerRow, height: height)
        return widthPerItem
    }
}

extension ArticleViewController: UICollectionViewDelegate,ArticleCollectionViewCellDelegate {
    // add favrouite list
    func addFavorite(article: ArticleModel) {
        // alert for add
        self.showFabAlert( "I added " + article.title + " to my favorites" )
        self.favViewModel.addFavorite(article: article)
        
        
    }
    
    // remove favrouite list
    func removeFavorite(article: ArticleModel) {
         //alert for delete form fav list
        self.showFabAlert( "I deleted " + article.title + " to my favorites" )
        self.favViewModel.deleteFavorite(id: article.id)
    
       
        
        
    }
}

// Mark: UICollectionView cell delegate
protocol ArticleCollectionViewCellDelegate {
    func removeFavorite(article: ArticleModel)
    func addFavorite(article: ArticleModel)
}
