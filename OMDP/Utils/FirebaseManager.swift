//
//  FirebaseManager.swift
//  OMDP
//
//  Created by Emre Aydin on 14.02.2023.
//

import Foundation
import Firebase
import FirebaseRemoteConfig
import FirebaseAnalytics

class FirebaseManager {
    let config: RemoteConfig
    let analytics: Analytics.Type

    static let shared = FirebaseManager()

    private init() {
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0

        self.config = RemoteConfig.remoteConfig()
        self.config.configSettings = settings
        self.config.setDefaults(fromPlist: "remote_config_defaults")
        
        self.analytics = Analytics.self
    }

    func fetchRemoteConfig(completion: @escaping () -> ()) {
        self.config.fetch { status, error in
            if status == .success {
                self.config.activate { changed, error in
                    completion()
                }
            } else {
                completion()
            }
        }
    }
}
