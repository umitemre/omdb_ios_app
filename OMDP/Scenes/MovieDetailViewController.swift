//
//  MovieDetailViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 11.02.2023.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController {
    var imdbId: String?

    private let disposeBag = DisposeBag()

    private let viewModel = MovieDetailViewModel()

    private var scrollView = UIScrollView()

    private var stackView = UIStackView()
    private var dummyView = UIView()
    private var containerView = UIView()

    private var moviePoster = UIImageView()
    private var movieTitle = UILabel()
    private var movieGenre = UILabel()
    private var movieActors = UILabel()
    private var movieDescription = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

        navigationItem.largeTitleDisplayMode = .never

        guard let imdbId = imdbId else {
            return
        }
        
        navigationItem.title = "Movie Detail"

        viewModel.fetchMovieDetail(for: imdbId)

        setupUI()
        setObservers()
    }
    
    private func setObservers() {
        viewModel.movieDetailResult.subscribe { [weak self] data in
            guard let detail = data.element else {
                return
            }

            self?.movieGenre.text = "Genre: \(detail.genre ?? "")"
            self?.movieActors.text = "Actors: \(detail.actors ?? "")"
            self?.movieDescription.text = detail.plot
        }.disposed(by: disposeBag)
    }
    
    func presetKnownFields(from search: Search) {
        self.moviePoster.loadImageFromUrl(search.poster)
        self.movieTitle.text = search.title
    }
}

private extension MovieDetailViewController {
    func setupMoviePoster() {
        view.addSubview(moviePoster)
        
        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            moviePoster.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            moviePoster.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            moviePoster.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            moviePoster.heightAnchor.constraint(equalToConstant: 500)
        ])
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)

        scrollView.delegate = self

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupStackView() {
        scrollView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupDummyView() {
        stackView.addSubview(dummyView)

        dummyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dummyView.topAnchor.constraint(equalTo: stackView.topAnchor),
            dummyView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            dummyView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            dummyView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }

    func setupContainerView() {
        // Add container view
        stackView.addSubview(containerView)
        
        containerView.backgroundColor = .white
        
        let maskPath = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 32, height: 32))

        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = view.bounds
        shapeLayer.path = maskPath.cgPath
        
        containerView.layer.mask = shapeLayer
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: dummyView.bottomAnchor)
        ])
    }

    func setupMovieTitle() {
        containerView.addSubview(movieTitle)

        movieTitle.numberOfLines = 0
        movieTitle.font = .systemFont(ofSize: 32, weight: .medium)
        
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            movieTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }

    func setupMovieGenre() {
        containerView.addSubview(movieGenre)

        movieGenre.numberOfLines = 0
        movieGenre.textColor = UIColor.gray
        movieGenre.font = .systemFont(ofSize: 16, weight: .bold)

        movieGenre.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieGenre.topAnchor.constraint(equalTo: movieTitle.bottomAnchor, constant: 16),
            movieGenre.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieGenre.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupMovieActors() {
        containerView.addSubview(movieActors)

        movieActors.numberOfLines = 0
        movieActors.textColor = UIColor.gray
        movieActors.font = .systemFont(ofSize: 16, weight: .bold)

        movieActors.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieActors.topAnchor.constraint(equalTo: movieGenre.bottomAnchor, constant: 16),
            movieActors.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieActors.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupMovieDescription() {
        containerView.addSubview(movieDescription)

        movieDescription.numberOfLines = 0
        
        movieDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieDescription.topAnchor.constraint(equalTo: movieActors.bottomAnchor, constant: 16),
            movieDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            movieDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            movieDescription.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: movieDescription.bottomAnchor, constant: -16),
        ])
    }

    func setupUI() {
        setupMoviePoster()

        setupScrollView()
        setupStackView()
        
        setupDummyView()
        setupContainerView()
        
        setupMovieTitle()
        setupMovieGenre()
        setupMovieActors()
        setupMovieDescription()
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        
        guard contentOffsetY < 0 else {
            return
        }
        
        let scale = 1 + (-contentOffsetY / 400)
        moviePoster.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
}
