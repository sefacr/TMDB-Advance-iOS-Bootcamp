//
//  ShowDetailViewController.swift
//  MovieList
//
//  Created by Sefa Acar on 28.01.2026.
//

import UIKit

final class ShowDetailViewController: UIViewController {
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private var contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let originalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let taglineLabel: UILabel = {
        let label = UILabel()
        label.font = .italicSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let voteAverageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let collectionsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var viewModel: ShowDetailViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        viewModel.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        view.addSubview(activityIndicator)
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        mainStackView.addArrangedSubview(posterImageView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(originalTitleLabel)
        mainStackView.addArrangedSubview(taglineLabel)
        mainStackView.addArrangedSubview(releaseDateLabel)
        mainStackView.addArrangedSubview(languageLabel)
        mainStackView.addArrangedSubview(genresLabel)
        mainStackView.addArrangedSubview(statusLabel)
        mainStackView.addArrangedSubview(voteAverageLabel)
        mainStackView.addArrangedSubview(collectionsLabel)
        mainStackView.addArrangedSubview(overviewLabel)
        
        contentView.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5)
        ])
    }
    
    private func configure(_ detailPresentation: ShowDetailPresentation) {
        
        if let posterPath = detailPresentation.posterPath {
            posterImageView.setTMDBImage(filePath: posterPath)
        }
        
        titleLabel.text = detailPresentation.name
        if detailPresentation.originalName != detailPresentation.name {
            originalTitleLabel.text = detailPresentation.originalName
        } else {
            originalTitleLabel.isHidden = true
        }
        
        if let tagline = detailPresentation.tagline, !tagline.isEmpty {
            taglineLabel.text = tagline
        } else {
            taglineLabel.isHidden = true
        }
        
        releaseDateLabel.text = detailPresentation.releaseDateText
        languageLabel.text = detailPresentation.languageText
        genresLabel.text = detailPresentation.genresText
        statusLabel.text = detailPresentation.statusText
        voteAverageLabel.text = detailPresentation.voteAverageText
        overviewLabel.text = detailPresentation.overviewText
    }
}

extension ShowDetailViewController: ShowDetailViewModelDelegate {
    
    func handleOutput(_ output: ShowDetailViewModelOutput) {
        switch output {
        case .showLoading(let isLoading):
            if isLoading {
                activityIndicator.startAnimating()
            }else {
                activityIndicator.stopAnimating()
            }
        case .displayShow(let show):
            configure(show)
        }
    }
}
