//
//  PictureViewerView.swift
//  ExternalDisplayDemo
//
//  Created by michael.collins on 8/29/23.
//

import PhotosUI
import SwiftUI

struct PictureViewerView: View {
	@State private var photo: UIImage?

	let publisher = NotificationCenter.default.publisher(for: showPictureNotification)

	var body: some View {
		VStack {
			if let photo {
				Image(uiImage: photo)
					.resizable()
					.aspectRatio(contentMode: .fit)
			} else {
				Text("Select a photo in the app")
			}
		}
		.onReceive(publisher) {
			guard let photo = $0.object as? UIImage else {
				fatalError("Expected a UIImage")
			}

			self.photo = photo
		}
	}
}

#Preview {
    PictureViewerView()
}
