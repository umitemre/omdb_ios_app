//
//  SplashViewController.swift
//  OMDP
//
//  Created by Emre Aydin on 14.02.2023.
//

import UIKit
import Reachability

class SplashViewController: UIViewController {
    var loadingView: UIView!
    var activityIndicator: UIActivityIndicatorView!

    var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupUI()
        
        self.checkInternetConnection()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.checkInternetConnection()
    }

    private func checkInternetConnection() {
        let reachability = try! Reachability()
        if reachability.connection == .unavailable {
            self.showNoInternetConnectionPopup()
            return
        }
        
        onInternetConnectionSuccess()
    }

    private func showNoInternetConnectionPopup() {
        let alert = UIAlertController(title: "No Internet Connection", message: "An internet connection is required to continue. Please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { _ in
            self.checkInternetConnection()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    private func animateAppName() {
        UIView.animate(withDuration: 2.0, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.titleLabel.alpha = 1.0
            self.titleLabel.transform = CGAffineTransform.identity
        }) { _ in
            self.onAnimationCompleted()
        }
    }
    
    private func onInternetConnectionSuccess() {
        FirebaseManager.shared.fetchRemoteConfig { [weak self] in
            let val = FirebaseManager.shared.config.configValue(forKey: "splash_screen_app_name")
            
            guard let appName = val.stringValue else {
                return
            }

            DispatchQueue.main.async {
                self?.titleLabel.text = appName
                self?.animateAppName()
            }
        }
    }

    private func onAnimationCompleted() {
        activityIndicator.frame = view.bounds.offsetBy(dx: 0, dy: 64)
        
        view.addSubview(loadingView)
        
        activityIndicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let navVC = UINavigationController(rootViewController: SearchMovieViewController())
            navVC.modalTransitionStyle = .crossDissolve
            navVC.modalPresentationStyle = .fullScreen

            DispatchQueue.main.async { [weak self] in
                self?.present(navVC, animated: true) {
                    self?.activityIndicator.stopAnimating()
                    self?.loadingView.removeFromSuperview()
                }
            }
        }
    }
}

private extension SplashViewController {
    func setupUI() {
        self.view.backgroundColor = .white

        self.setupAppName()
        self.setupLoadingIndicator()
    }
    
    func setupLoadingIndicator() {
        // Set up the loading view
        loadingView = UIView(frame: view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        
        loadingView.addSubview(activityIndicator)
    }

    func setupAppName() {
        // Set up the label
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 36, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.alpha = 0.0
        titleLabel.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat.pi)

        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
    }
}
