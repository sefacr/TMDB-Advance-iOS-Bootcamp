//
//  ShowroomData.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//

import UIKit

struct ShowroomData {
    let contentType: ContentType
    let environmentType: MediaType
}

class PopularShowsViewController: UIViewController {
    
    var environmentType: MediaType = .tv
    var contentType: ContentType = .popular
    
    private var tvSeriesStore = TVSeriesStore()
    
    private var isLoading = false
    
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
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(contentType: ContentType, environmentType: MediaType) {
        self.contentType = contentType
        self.environmentType = environmentType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupView()
        
        loadInitialData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNavigationBar() {
        if #available(iOS 26.0, *) {
            mainCollectionView.topEdgeEffect.style = .hard
        }
    }
    
    private func loadInitialData() {
        isLoading = true
        activityIndicator.startAnimating()
        fetchData { [weak self] in
            self?.isLoading = false
            self?.activityIndicator.stopAnimating()
        }
    }
    
    private func loadMoreData() {
        guard !isLoading else { return }
        
        isLoading = true
        fetchData { [weak self] in
            self?.isLoading = false
        }
    }
    
    private func fetchData(completion: (() -> Void)? = nil) {
        switch contentType {
        case .popular:
            switch environmentType {
            case .tv:
                tvSeriesStore.fetchPopularTvSeries { [weak self] result in
                    switch result {
                    case .success(_):
                        self?.reloadCollectionView()
                    case .failure(let error):
                        print("error: \(error)")
                    }
                    completion?()
                }
            }
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] in
            self?.mainCollectionView.reloadData()
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

extension PopularShowsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            loadMoreData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch contentType {
        case .popular:
            switch environmentType {
            case .tv:
                return tvSeriesStore.popularTvSeries.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        let posterPath: String?
        switch contentType {
        case .popular:
            switch environmentType {
            case .tv:
                posterPath = tvSeriesStore.popularTvSeries[indexPath.row].posterPath
            }
        }
        
        
        cell.configure(posterPath: posterPath, showBorder: true)
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
        switch contentType {
        case .popular:
            switch environmentType {
            case .tv:
                let tvSeries: TVSeries = tvSeriesStore.popularTvSeries[indexPath.row]
                let detailVC = DetailedContentViewController(contentId: tvSeries.id, mediaType: .tv)
                navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
}
