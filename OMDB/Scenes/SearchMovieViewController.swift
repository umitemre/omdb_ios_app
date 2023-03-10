//
//  ViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 11.02.2023.
//

import UIKit
import RxSwift
import FirebaseRemoteConfig

class SearchMovieViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let containerView = UIView()
    let recentlyViewedHeader = UILabel()
    let recentlyViewedDataSource = RecentlyViewedDataSource()
    let noRecentlyViewedMessage = UILabel()
    
    let viewModel = SearchViewModel()

    lazy var recentlyViewedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    private let searchController: UISearchController = {
        let resultsViewController = ResultsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "Type a movie name and hit ⏎"
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.setObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.fetchRecentlyViewed()
    }

    private func setObservers() {
        self.viewModel.recentlyViewedMovies.subscribe { [weak self] data in
            guard let data = data.element else {
                return
            }
            
            self?.noRecentlyViewedMessage.isHidden = data.count > 0
            self?.recentlyViewedCollectionView.isHidden = data.count == 0

            self?.recentlyViewedDataSource.updateData(data: data)
            self?.recentlyViewedCollectionView.reloadData()
        }.disposed(by: disposeBag)
    }

    private func getResultsViewController() -> ResultsViewController {
        return self.searchController.searchResultsController as! ResultsViewController
    }
}

private extension SearchMovieViewController {
    func setupUI() {
        title = "Search"

        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()

        navigationItem.searchController = searchController

        view.backgroundColor = UIColor.white
        
        setupContainerView()
        setupRecentlyViewedHeader()
        setupNoRecentlyViewedMessage()
        setupRecentlyViewedCollectionView()
    }
    
    func setupContainerView() {
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 32),
            containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupRecentlyViewedHeader() {
        recentlyViewedHeader.text = "Recently Viewed"
        recentlyViewedHeader.font = .systemFont(ofSize: 24, weight: .bold)
        
        containerView.addSubview(recentlyViewedHeader)
        
        recentlyViewedHeader.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentlyViewedHeader.topAnchor.constraint(equalTo: containerView.topAnchor),
            recentlyViewedHeader.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            recentlyViewedHeader.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    func setupRecentlyViewedCollectionView() {
        recentlyViewedCollectionView.isHidden = true

        containerView.addSubview(recentlyViewedCollectionView)

        recentlyViewedDataSource.navigationController = navigationController

        recentlyViewedCollectionView.dataSource = recentlyViewedDataSource
        recentlyViewedCollectionView.delegate = recentlyViewedDataSource

        recentlyViewedCollectionView.register(RecentlyViewedCell.self, forCellWithReuseIdentifier: RecentlyViewedCell.cellId)

        self.view.layoutIfNeeded()

        recentlyViewedCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentlyViewedCollectionView.topAnchor.constraint(equalTo: self.recentlyViewedHeader.bottomAnchor, constant: 16),
            recentlyViewedCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            recentlyViewedCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            recentlyViewedCollectionView.heightAnchor.constraint(equalToConstant: 250)
        ])
    }
    
    func setupNoRecentlyViewedMessage() {
        noRecentlyViewedMessage.isHidden = true
        
        noRecentlyViewedMessage.text = "Your recently checked movies will be shown here."
        noRecentlyViewedMessage.numberOfLines = 0
        noRecentlyViewedMessage.textAlignment = .left
        noRecentlyViewedMessage.font = .italicSystemFont(ofSize: 16)

        containerView.addSubview(noRecentlyViewedMessage)
        
        noRecentlyViewedMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noRecentlyViewedMessage.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            noRecentlyViewedMessage.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            noRecentlyViewedMessage.topAnchor.constraint(equalTo: self.recentlyViewedHeader.bottomAnchor, constant: 16)
        ])
    }
}

extension SearchMovieViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines)  else {
            return
        }

        if text.count == 0 {
            print("updateSearchResults: no query text provided")
            getResultsViewController().resetUI()
            return
        }
    }
}

extension SearchMovieViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        containerView.isHidden = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        containerView.isHidden = false
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            return
        }

        if text.count == 0 {
            print("searchBarTextDidEndEditing: no query text provided")
            getResultsViewController().resetUI()
            return
        }

        print("searchBarTextDidEndEditing: \(text)")
        getResultsViewController().search(for: text)
    }
}
