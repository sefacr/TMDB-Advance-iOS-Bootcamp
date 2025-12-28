//
//  ShowDetailViewController.swift
//  MovieCleanSwift
//
//  Created by Seyfeddin Bassarac on 27.09.2025.
//

import UIKit

protocol ShowDetailViewControllerInput: AnyObject {
    func displayShow(tvShow: ShowDetailViewModel)
}

protocol ShowDetailViewControllerOutput: AnyObject {
    func loadData(request: ShowDetailRequest)
}

class ShowDetailViewController: UIViewController, ShowDetailViewControllerInput {
    
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
    
    var output: ShowDetailViewControllerOutput!
    var router: ShowDetailDataPassing?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        setupConstraints()
        output.loadData(request: ShowDetailRequest())
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        ShowDetailConfigurator.shared.configure(viewController: self)
    }
    
    func displayShow(tvShow: ShowDetailViewModel) {
        if let posterPath = tvShow.posterPath {
            posterImageView.setTMDBImage(filePath: posterPath)
        }
        
        titleLabel.text = tvShow.name
        if tvShow.originalName != tvShow.name {
            originalTitleLabel.text = tvShow.originalName
        } else {
            originalTitleLabel.isHidden = true
        }
        
        if let tagline = tvShow.tagline, !tagline.isEmpty {
            taglineLabel.text = tagline
        } else {
            taglineLabel.isHidden = true
        }
        
        releaseDateLabel.text = "First Air Date: \(tvShow.firstAirDate ?? "N/A")"
        languageLabel.text = "Original Language: \(tvShow.originalLanguage.uppercased())"
        statusLabel.text = "Status: \(tvShow.status ?? "Unknown")"
        voteAverageLabel.text = "Rating: \(String(format: "%.1f", tvShow.voteAverage))"
        overviewLabel.text = tvShow.overview
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
}
