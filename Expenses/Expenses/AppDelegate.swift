//
//  AppDelegate.swift
//  Expenses
//
//  Created by michael.collins on 8/29/23.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
	) -> Bool {
		return true
	}

	func application(
		_ application: UIApplication,
		configurationForConnecting connectingSceneSession: UISceneSession,
		options: UIScene.ConnectionOptions
	) -> UISceneConfiguration {
		guard connectingSceneSession.role == .windowApplication else {
			return connectingSceneSession.configuration
		}

		let configuration = UISceneConfiguration(
			name: connectingSceneSession.configuration.name,
			sessionRole: connectingSceneSession.role
		)
		configuration.delegateClass = MainSceneDelegate.self
		return configuration
	}
}
