//
//  ShowListViewController.swift
//  MovieList
//
//  Created by Sefa Acar on 8.01.2026.
//

import UIKit

enum ShowListRoute {
    case detail(ShowDetailViewModelProtocol)
}

final class ShowListViewController: UIViewController {
    
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
    
    var viewModel: ShowListViewModelProtocol! {
        didSet {
            viewModel.delegate = self // oluştuğu anda delegate bağlamak için bu şekilde bir kullanım da var
        }
    }
    
    var cellPresentation: [ShowListCellPresentation] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = false
        
        setupView()
        
        viewModel.loadData()
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

// MARK: - Delegate

extension ShowListViewController: ShowListViewModelDelegate {
    
    func handleOutput(_ output: ShowListViewModelOutput) {
        switch output {
        case .displayShows(let tvSeries):
            self.cellPresentation.append(contentsOf: tvSeries)
            mainCollectionView.reloadData()
        case .showLoading(let isLoading):
            if isLoading {
                activityIndicator.startAnimating()
            }else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    func navigate(to route: ShowListRoute) {
        switch route {
        case .detail(let viewModel):
            self.show(ShowDetailBuilder.make(viewModel: viewModel), sender: nil)
            
        }
    }
}


// MARK: - UICollectionViewDelegate, DataSourece, FlowLayout

extension ShowListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 2 {
            self.viewModel.loadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellPresentation.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        let cellPresentation = cellPresentation[indexPath.item]
        
        cell.configure(presantation: cellPresentation)
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
        viewModel.selectShow(at: indexPath.item)
    }
}
