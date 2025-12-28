//
//  ShowListViewController.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 26.09.2025.
//

import UIKit

// Presenter -> View Controller
protocol ShowListViewControllerInput: AnyObject {
    func showTvShows(tvShows: [ShowListViewModel])
    func showLoading(isLoading: Bool)
}

// View Controller -> Presenter
protocol ShowListViewControllerOutput: AnyObject {
    func loadData(request: ShowListRequest)
}

class ShowListViewController: UIViewController {
    
    var output: ShowListViewControllerOutput!
    var tvShows: [ShowListViewModel] = []
    var router: (ShowListRouterInput & ShowListDataPassing)?
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var selectedItem: IndexPath?
    
    var mainCollectionView: UICollectionView = {
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
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        ShowListConfigurator.shared.configure(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectedItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        mainCollectionView.dataSource = self
        mainCollectionView.delegate = self
        setupView()
        
        let request = ShowListRequest()
        output.loadData(request: request)
    }
    
    // MARK: - View Setup

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
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

extension ShowListViewController: ShowListViewControllerInput {
    func showTvShows(tvShows: [ShowListViewModel]) {
        self.tvShows.append(contentsOf: tvShows)
        mainCollectionView.reloadData()
    }
    
    func showLoading(isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}

extension ShowListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            output.loadData(request: ShowListRequest())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tvShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        let tvShow = tvShows[indexPath.row]
        
        cell.configure(posterPath: tvShow.posterPath)
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
        // TODO: Add selection
        selectedItem = indexPath
        router?.routeToShowDetail(segue: nil)
    }
}
