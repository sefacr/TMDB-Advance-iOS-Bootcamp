//
//  PosterCollectionViewCell.swift
//  MovieMVC
//
//  Created by Seyfeddin Bassarac on 24.09.2025.
//

import UIKit

class PosterCollectionViewCell: UICollectionViewCell {
    static let identifier = "PosterCollectionViewCell"
    
    private var currentImagePath: String?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(named: "no-poster")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(posterImageView)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = UIImage(named: "no-poster")
        posterImageView.layer.borderWidth = 0
        posterImageView.layer.borderColor = nil
        currentImagePath = nil
    }
    
    func configure(presentation: ShowListCellPresentation) {
        configure(posterPath: presentation.posterPath, showBorder: presentation.showBorder)
    }
    
    func configure(posterPath: String?, showBorder: Bool = false) {
        currentImagePath = posterPath
        
        posterImageView.image = UIImage(named: "no-poster")
        
        if let posterPath = posterPath {
            TMDBImageManager.shared.loadTMDBImage(filePath: posterPath, size: "w300") { [weak self] image in
                DispatchQueue.main.async {
                    if self?.currentImagePath == posterPath {
                        self?.posterImageView.image = image ?? UIImage(named: "no-poster")
                    }
                }
            }
        }
        
        if showBorder {
            posterImageView.layer.borderWidth = 1
            posterImageView.layer.borderColor = UIColor.black.cgColor
        } else {
            posterImageView.layer.borderWidth = 0
            posterImageView.layer.borderColor = nil
        }
    }
}
