//
//  RecentlyViewedDataSource.swift
//  OMDP
//
//  Created by Emre Aydin on 15.02.2023.
//

import UIKit

class RecentlyViewedDataSource: NSObject {
    private var data: [MovieDetailLocal] = []
    
    weak var navigationController: UINavigationController?

    func updateData(data: [MovieDetailLocal]) {
        self.data = data
    }
}

extension RecentlyViewedDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecentlyViewedCell.cellId, for: indexPath) as! RecentlyViewedCell

        let data = self.data[indexPath.row]
        cell.bindData(data)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.data[indexPath.row]

        let vc = MovieDetailViewController()
        vc.imdbId = item.imdbId
        vc.presetKnownFields(from: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RecentlyViewedDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 250)
    }
}
