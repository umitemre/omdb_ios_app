//
//  RecentlyViewedCell.swift
//  OMDP
//
//  Created by Emre Aydin on 15.02.2023.
//

import UIKit

class RecentlyViewedCell: UICollectionViewCell {
    static var cellId = "RecentlyViewedCell"

    let moviePoster = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension RecentlyViewedCell {
    func setupUI() {
        self.contentView.addSubview(moviePoster)
        
        moviePoster.image = UIImage(named: "placeholder")
        moviePoster.contentMode = .scaleAspectFill
        moviePoster.clipsToBounds = true
        moviePoster.layer.cornerRadius = 20
        moviePoster.layer.borderWidth = 1
        moviePoster.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        
        moviePoster.clipsToBounds = true

        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviePoster.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16),
            moviePoster.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            moviePoster.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            moviePoster.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
}

extension RecentlyViewedCell {
    func bindData(_ data: MovieDetailLocal) {
        self.moviePoster.loadImageFromUrl(data.poster)
    }
}
