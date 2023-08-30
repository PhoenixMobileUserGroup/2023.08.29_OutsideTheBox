//
//  ContentView.swift
//  Expenses
//
//  Created by michael.collins on 8/29/23.
//

import SwiftUI

struct ContentView: View {
	@State private var text = "Hello, World!"

    var body: some View {
        VStack {
            Text(text)
        }
        .padding()
		.onOpenURL(perform: { url in
			switch url.path() {
			case "/create":
				text = "TODO: create an expense"
			case "/scan":
				text = "TODO: scan a receipt"
			default:
				text = "ERROR: unrecognized action"
			}
		})
    }
}

#Preview {
    ContentView()
}
