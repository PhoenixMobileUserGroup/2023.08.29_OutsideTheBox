//
//  PictureViewerSceneDelegate.swift
//  ExternalDisplayDemo
//
//  Created by michael.collins on 8/29/23.
//

import SwiftUI

final class PictureViewerSceneDelegate: NSObject, UIWindowSceneDelegate {
	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("expected a UIWindowScene")
		}

		let window = UIWindow(windowScene: windowScene)
		let view = PictureViewerView()
		let viewController = UIHostingController(rootView: view)
		window.rootViewController = viewController
		window.makeKeyAndVisible()
		self.window = window
	}
}
