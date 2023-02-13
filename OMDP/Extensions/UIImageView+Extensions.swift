//
//  UIImageView+Extensions.swift
//  OMDP
//
//  Created by Emre Aydin on 12.02.2023.
//

import Foundation
import AlamofireImage
import UIKit

extension UIImageView {
    func loadImageFromUrl(_ path: String?) {
        guard let path = path else { return }
        guard isValidURL(string: path) else { return }
        self.loadImageFromUrl(URL(string: path))
    }

    func loadImageFromUrl(_ url: URL?) {
        guard let url = url else { return }
        self.image = nil
        self.af.setImage(withURL: url)
    }

    func isValidURL(string: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector?.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) {
            return match.range.length == string.utf16.count
        } else {
            return false
        }
    }
}
