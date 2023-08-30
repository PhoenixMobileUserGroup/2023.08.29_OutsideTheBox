//
//  PictureViewerView.swift
//  ExternalDisplays
//
//  Created by michael.collins on 8/29/23.
//

import SwiftUI

struct PictureViewerView: View {
	@State private var photo: UIImage?

    var body: some View {
		VStack {
			if let photo {
				Image(uiImage: photo)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.transition(.opacity)
					.animation(.default, value: photo)
			} else {
				Text("Select a photo on your phone to view")
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: showPictureNotification)) {
			guard let image = $0.object as? UIImage else {
				fatalError("expected a UIImage")
			}

			self.photo = image
		}
    }
}

#Preview {
    PictureViewerView()
}
