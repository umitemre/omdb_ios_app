//
//  ResultsViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import UIKit
import Foundation
import RxSwift

class ResultsViewController: UICollectionViewController {
    private let disposeBag = DisposeBag()

    private let viewModel = ResultsViewModel()

    private let loadingView = UIView()
    private let errorText = UILabel()
    
    private var query = ""
    private var currentPage = 1
    private var totalResults = 0
    private var searchResults: [Search]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(SearchItemCell.self, forCellWithReuseIdentifier: SearchItemCell.cellId)

        configureLoadingIndicator()
        configureErrorView()

        setObservers()
        
        collectionView.delegate = self
    }

    private func configureLoadingIndicator() {
        loadingView.isHidden = true
        loadingView.translatesAutoresizingMaskIntoConstraints = false

        let loadingLabel = UILabel()
        loadingLabel.text = "Loading..."
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingLabel.textAlignment = .center

        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.startAnimating()

        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            loadingIndicator.topAnchor.constraint(equalTo: loadingView.topAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor),
            loadingLabel.topAnchor.constraint(equalTo: loadingIndicator.bottomAnchor, constant: 8),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor)
        ])

        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingView.widthAnchor.constraint(equalToConstant: 160),
            loadingView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }

    private func configureErrorView() {
        errorText.isHidden = true
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.numberOfLines = 0
        errorText.textAlignment = .center

        view.addSubview(errorText)

        NSLayoutConstraint.activate([
            errorText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            errorText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            errorText.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setObservers() {
        viewModel.searchMovieResult.subscribe { [weak self] data in
            self?.loadingView.isHidden = true

            let result = data.element
            
            guard let totalResults = result?.totalResults,
                  let search = result?.search else {
                self?.errorText.isHidden = false
                self?.errorText.text = "No results found for \"\(self?.query ?? "")\", please narrow down your query and try again."
                return
            }
            
            print("Total results: \(totalResults)")
            
            self?.totalResults = Int(totalResults) ?? 0
            self?.searchResults?.append(contentsOf: search)
            self?.collectionView.reloadData()

            self?.errorText.isHidden = true
            self?.collectionView.isHidden = false
        }.disposed(by: disposeBag)
    }

    private func loadMoreItems() {
        if let count = searchResults?.count,
           count < totalResults {
            print("loadMoreItems")
            
            self.currentPage += 1
            viewModel.fetchSearchResults(for: query, page: currentPage)

            return
        }

        print("No more items to load")
    }

    func search(for query: String) {
        self.resetUI()

        self.loadingView.isHidden = false
        self.query = query
        self.currentPage = 1
        
        // Clear search results
        self.searchResults = []
        
        viewModel.fetchSearchResults(for: query, page: currentPage)
    }
    
    func resetUI() {
        self.searchResults = nil
        self.currentPage = 1
        self.totalResults = 0
        self.collectionView.reloadData()

        loadingView.isHidden = true
        errorText.isHidden = true
        collectionView.isHidden = true
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchItemCell.cellId, for: indexPath) as! SearchItemCell
        let search = searchResults?[indexPath.row]
        
        cell.bindData(data: search)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = self.searchResults?[indexPath.row] else {
            return
        }

        let vc = MovieDetailViewController()
        vc.imdbId = item.imdbID
        vc.presetKnownFields(from: item)
        
        presentingViewController?.navigationController?.pushViewController(vc, animated: true)
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = searchResults?.count else {
            return
        }
        
        if indexPath.row == count - 1 {
            loadMoreItems()
        }
    }
}

extension ResultsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 100 + 32)
    }
}
