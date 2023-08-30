//
//  ContentView.swift
//  AppLinks
//
//  Created by michael.collins on 8/29/23.
//

import SwiftUI

struct ContentView: View {
	@Environment(\.openURL) private var openURL

	@State private var title = "Try a link"

    var body: some View {
        VStack {
            Text(title)
				.font(.title)

			Spacer()

			Button {
				openURL(URL(string: "https://proud-cliff-098617f1e.3.azurestaticapps.net")!)
			} label: {
				HStack {
					Text("Home")
				}
			}
			.padding()

			Button {
				openURL(URL(string: "https://proud-cliff-098617f1e.3.azurestaticapps.net/create")!)
			} label: {
				Text("Create")
			}
			.padding()

			Spacer()
        }
        .padding()
		.onOpenURL {
			switch $0.path() {
			case "", "/":
				title = "Home"
			case "/create":
				title = "Create"
			default:
				title = "Unknown link"
			}
		}
    }
}

#Preview {
    ContentView()
}
