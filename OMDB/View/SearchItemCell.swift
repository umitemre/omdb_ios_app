//
//  SearchItemCell.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import UIKit

class SearchItemCell: UICollectionViewCell {
    static var cellId = "SearchItemCell"
    
    let imagePoster = UIImageView()
    let movieName = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SearchItemCell {
    func setupUI() {
        let block = UIView()
        block.layer.borderWidth = 1
        block.layer.cornerRadius = 10
        block.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor

        self.contentView.addSubview(block)

        block.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            block.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            block.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            block.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            block.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        // Step 1. Add UIImageView
        block.addSubview(imagePoster)
        
        imagePoster.image = .init(named: "placeholder")
        imagePoster.contentMode = .scaleAspectFill
        imagePoster.clipsToBounds = true
        imagePoster.translatesAutoresizingMaskIntoConstraints = false
        imagePoster.layer.cornerRadius = 10
        imagePoster.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        imagePoster.layer.borderWidth = 1

        NSLayoutConstraint.activate([
            imagePoster.leadingAnchor.constraint(equalTo: block.leadingAnchor, constant: 8),
            imagePoster.topAnchor.constraint(equalTo: block.topAnchor, constant: 8),
            imagePoster.bottomAnchor.constraint(equalTo: block.bottomAnchor, constant: -8),
            imagePoster.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        // Step 2. Add UILabel
        block.addSubview(movieName)
        
        movieName.numberOfLines = 0
        movieName.font = .systemFont(ofSize: 18)
        movieName.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            movieName.leadingAnchor.constraint(equalTo: imagePoster.trailingAnchor, constant: 16),
            movieName.trailingAnchor.constraint(equalTo: block.trailingAnchor, constant: -16),
            movieName.topAnchor.constraint(equalTo: block.topAnchor, constant: 16),
        ])
    }
}

extension SearchItemCell {
    func bindData(data: Search?) {
        guard let data = data else {
            return
        }
        
        movieName.text = data.title
        imagePoster.loadImageFromUrl(data.poster)
    }
}
