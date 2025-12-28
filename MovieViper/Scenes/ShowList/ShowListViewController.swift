//
//  ShowListViewController.swift
//  MovieViper
//
//  Created by Sefa Acar on 26.12.2025.
//

import UIKit

final class ShowListViewController: UIViewController {
    
    // vc sadece presenterla haberleşiyor o yüzden biz buraya sadece presenter dependencysi koyduk.
    var presenter: ShowListPresenterProtocol!
    
    //var tvSeries: [TVSeries] = [] artık burada model tutmaya ihtiyacım yok presentation objem var
//    var tvSeries: [ShowListCellPresentation] = [] presentation objei de tutmayacağım çünkü bana artık presentor ne gerekiyorsa verecek
    
    
    private var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupView()
        
        presenter.loadData()
    }
    
    private func setupNavigationBar() {
        if #available(iOS 26.0, *) {
            mainCollectionView.topEdgeEffect.style = .hard
        }
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Popular TV Shows"
        
        view.addSubview(mainCollectionView)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            
            mainCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            mainCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mainCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            mainCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

extension ShowListViewController: ShowListViewProtocol {
    
    func handleOutput(_ output: ShowListPresenterOutput) {
        //presenter datayı olduğu gibi vermemeli vcnin ihtiyacı olacağı şekilde verir
        switch output {
        case .showTVSeries:
            mainCollectionView.reloadData()
        case .showLoading(let isLoading):
            isLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }
}

extension ShowListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            presenter.loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        let cellPresentation = presenter.getPresentation(at: indexPath.item)
        //ben burada cell modeli tutuyordum böyle yapmamam gerekli, postercell bir presantation objesi almalı
//        cell.configure(posterPath: serie.posterPath, showBorder: true)
        
        cell.configure(presentation: cellPresentation)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10
        
        let totalSpacing = (itemsPerRow - 1) * spacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let widthPerItem = floor(availableWidth / itemsPerRow)
        let heightPerItem = widthPerItem * 1.5
        
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.selectTVSeries(at: indexPath.item)
    }
}
