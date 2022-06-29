//
//  HomeViewController.swift
//  GoodsMartTask
//
//  Created by Tawfik Sweedy✌️ on 6/26/22.
//

import UIKit
import RxSwift
import RxCocoa
import SVProgressHUD

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        homeViewModel.getStocks()
        homeViewModel.getNews()
        setupCollectionView()
        homeViewModel.stocksModelObservable.subscribe { [self] _ in
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
        homeViewModel.newsModelObservable.subscribe { [self] _ in
            self.collectionView.reloadData()
        }.disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        SubscribeLoading()
    }
    private func setupView () {
        navigationItem.title = "Stock Tickers"
    }
    private func setupCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.RegisterNib(cell: StocksCollectionViewCell.self)
        collectionView.RegisterNib(cell: LatestNewsCollectionViewCell.self)
        collectionView.RegisterNib(cell: MoreNewsCollectionViewCell.self)
        collectionView.register(UINib(nibName: "HeaderCollectionView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionView")
        collectionView.collectionViewLayout = HomeViewController.createLayout()
    }
    func SubscribeLoading(){
        homeViewModel.loadingBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
//                SVProgressHUD.show()
            }else{
//                SVProgressHUD.dismiss()
            }
        }).disposed(by: disposeBag)
    }
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber , environment in
            let footerHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                      heightDimension: .absolute(30.0))
                        let header = NSCollectionLayoutBoundarySupplementaryItem(
                            layoutSize: footerHeaderSize,
                            elementKind: UICollectionView.elementKindSectionHeader,
                            alignment: .top)
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .absolute(100)), subitems: [item] )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [header]
                return section
            }else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .absolute(260)), subitems: [item] )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [header]
                return section
            }else if sectionNumber == 2{
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(480)), subitems: [item] )
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                return section
            }else {
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(480)), subitems: [item] )
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
    }
}
extension HomeViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderCollectionView", for: indexPath as IndexPath) as! HeaderCollectionView
            if indexPath.section == 0 {
                headerView.headerTitleLabel.text = "Stocks"
            }else if indexPath.section == 1{
                headerView.headerTitleLabel.text = "Latest News"
            }else if indexPath.section == 2{
                headerView.headerTitleLabel.text = "More News"
            }else {
                headerView.headerTitleLabel.text = "History News"
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return homeViewModel.stockData.count
        }else if section == 1{
            return homeViewModel.newData.count < 6 ? homeViewModel.newData.count : 6
        }else if section == 2{
            let count = homeViewModel.newData.count
            return count > 6 ? count - 6 : 0
        }else{
            return homeViewModel.historyData.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StocksCollectionViewCell", for: indexPath) as! StocksCollectionViewCell
            cell.setupCell(data: homeViewModel.stockData[indexPath.row])
            return cell
        }else if indexPath.section == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestNewsCollectionViewCell", for: indexPath) as! LatestNewsCollectionViewCell
            cell.setupCell(data: homeViewModel.newData[indexPath.row])
            return cell
        }else if indexPath.section == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreNewsCollectionViewCell", for: indexPath) as! MoreNewsCollectionViewCell
            cell.setupCell(data: homeViewModel.newData[indexPath.row + 6])
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MoreNewsCollectionViewCell", for: indexPath) as! MoreNewsCollectionViewCell
            cell.setupHistoryCell(data: homeViewModel.historyData[indexPath.row])
            return cell
        }
    }
}
