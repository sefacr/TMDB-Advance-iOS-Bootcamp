//
//  DetailedContentViewController.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//

import Foundation
import UIKit

class DetailedContentViewController: UIViewController {
    
    private let contentId: Int
    private let mediaType: MediaType
    
    private let tvSeriesStore = TVSeriesStore()
    
    private var tvSeries: TVSeries?
    
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
    
    init(contentId: Int, mediaType: MediaType) {
        self.contentId = contentId
        self.mediaType = mediaType
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
        fetchData()
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
    
    private func fetchData() {
        activityIndicator.startAnimating()
        
        tvSeriesStore.fetchDetailedTVSeries(id: contentId) { [weak self] result in
            self?.activityIndicator.stopAnimating()
            switch result {
            case .success(let tvSeries):
                self?.tvSeries = tvSeries
                self?.configure()
            case .failure(let error):
                print("Error fetching tv series details: \(error)")
            }
        }
    }
    
    private func configure() {
        guard let tvSeries = tvSeries else { return }
        
        if let posterPath = tvSeries.posterPath {
            posterImageView.setTMDBImage(filePath: posterPath)
        }
        
        titleLabel.text = tvSeries.name
        if tvSeries.originalName != tvSeries.name {
            originalTitleLabel.text = tvSeries.originalName
        } else {
            originalTitleLabel.isHidden = true
        }
        
        if let tagline = tvSeries.tagline, !tagline.isEmpty {
            taglineLabel.text = tagline
        } else {
            taglineLabel.isHidden = true
        }
        
        releaseDateLabel.text = "First Air Date: \(tvSeries.firstAirDate ?? "N/A")"
        languageLabel.text = "Original Language: \(tvSeries.originalLanguage.uppercased())"
        genresLabel.text = "Genres: \(tvSeries.genres?.map { $0.name }.joined(separator: ", ") ?? "N/A")"
        statusLabel.text = "Status: \(tvSeries.status ?? "Unknown")"
        voteAverageLabel.text = "Rating: \(String(format: "%.1f", tvSeries.voteAverage))"
        overviewLabel.text = tvSeries.overview
    }
}
