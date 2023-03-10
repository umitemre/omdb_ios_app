//
//  MovieDetailViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 11.02.2023.
//

import UIKit
import RxSwift
import CoreData

class MovieDetailViewController: UIViewController {
    var imdbId: String?

    private let disposeBag = DisposeBag()

    private let viewModel = MovieDetailViewModel()

    private var loadingView: UIView!
    private var activityIndicator: UIActivityIndicatorView!
    
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
    
    private func logEvent(_ detail: MovieDetail) {
        FirebaseManager.shared.analytics.logEvent("view_movie_detail", parameters: [
            "imdb_id": detail.imdbID ?? "",
            "movie_title": detail.title ?? "",
            "movie_year": detail.year ?? "",
        ])
    }

    private func setObservers() {
        viewModel.movieDetailResult.subscribe { [weak self] data in
            self?.loadingView.isHidden = true

            guard let result = data.element else {
                self?.showError(nil)
                return
            }

            switch result {
            case .failure(let error):
                self?.showError(error)
            case .success(let detail):
                self?.logEvent(detail)

                self?.movieGenre.text = "Genre: \(detail.genre ?? "")"
                self?.movieActors.text = "Actors: \(detail.actors ?? "")"
                self?.movieDescription.text = detail.plot
            }
        }.disposed(by: disposeBag)
    }
    
    private func showError(_ error: Error?) {
        let alert = UIAlertController(title: "No Internet Connection", message: "Something went wrong, please try again. (\(error?.localizedDescription ?? "")", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { [weak self] _ in
            guard let imdbId = self?.imdbId else {
                return
            }

            self?.loadingView.isHidden = false
            self?.viewModel.fetchMovieDetail(for: imdbId)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        self.present(alert, animated: true, completion: nil)
    }

    func presetKnownFields(from search: Search) {
        self.moviePoster.loadImageFromUrl(search.poster)
        self.movieTitle.text = search.title
        
        CoreDataManager.shared.saveMovieDetail(search)
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

    func setupLoadingIndicator() {
        // Set up the loading view
        loadingView = UIView()
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = UIColor.white

        loadingView.addSubview(activityIndicator)

        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: self.loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: self.loadingView.centerYAnchor),
        ])
        
        activityIndicator.startAnimating()
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
        setupLoadingIndicator()
        
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
