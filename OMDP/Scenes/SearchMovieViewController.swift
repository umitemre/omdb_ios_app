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
    private let searchController: UISearchController = {
        let resultsViewController = ResultsViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let searchController = UISearchController(searchResultsController: resultsViewController)
        searchController.searchBar.placeholder = "Type a movie name and hit ⏎"
        
        return searchController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"

        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.sizeToFit()

        navigationItem.searchController = searchController

        view.backgroundColor = UIColor.white
    }
    
    private func getResultsViewController() -> ResultsViewController {
        return self.searchController.searchResultsController as! ResultsViewController
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
