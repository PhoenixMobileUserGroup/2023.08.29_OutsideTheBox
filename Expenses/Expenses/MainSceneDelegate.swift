//
//  MainSceneDelegate.swift
//  Expenses
//
//  Created by michael.collins on 8/29/23.
//

import SwiftUI

final class MainSceneDelegate: NSObject, UIWindowSceneDelegate {
	@Environment(\.openURL) private var openURL

	var window: UIWindow?

	func scene(
		_ scene: UIScene,
		willConnectTo session: UISceneSession,
		options connectionOptions: UIScene.ConnectionOptions
	) {
		guard let windowScene = scene as? UIWindowScene else {
			fatalError("Expected a UIWindowScene")
		}

		self.window = windowScene.keyWindow
	}

	@MainActor
	func windowScene(
		_ windowScene: UIWindowScene,
		performActionFor shortcutItem: UIApplicationShortcutItem
	) async -> Bool {
		switch shortcutItem.type {
		case "com.michaelfcollins3.expenses.create":
			openURL(.init(string: "expenses://app/create")!)
			return true
		case "com.michaelfcollins3.expenses.receipt":
			openURL(.init(string: "expenses://app/scan")!)
			return true
		default:
			return false
		}
	}
}
