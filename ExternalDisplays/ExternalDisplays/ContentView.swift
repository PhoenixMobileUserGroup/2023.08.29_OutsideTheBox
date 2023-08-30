//
//  ContentView.swift
//  ExternalDisplays
//
//  Created by michael.collins on 8/29/23.
//

import PhotosUI
import SwiftUI

let showPictureNotification = Notification.Name("ShowPicture")

struct ContentView: View {
	@State private var hasExternalDisplay = false
	@State private var selectedPhotoItem: PhotosPickerItem?
	@State private var photo: UIImage?

	private let willConnectPublisher = NotificationCenter.default.publisher(for: UIScene.willConnectNotification)

    var body: some View {
        VStack {
			PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
				Text("Select a Photo")
			}

			Spacer()

			if !hasExternalDisplay, let photo {
				Image(uiImage: photo)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.transition(.opacity)
					.animation(.default, value: photo)

				Spacer()
			}
        }
        .padding()
		.onReceive(willConnectPublisher) {
			guard let scene = $0.object as? UIScene,
				  scene.session.role == .windowExternalDisplayNonInteractive else {
				return
			}

			hasExternalDisplay = true
			if let photo {
				Task { @MainActor in
					showPhotoInExternalDisplay(photo)
				}
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification)) {
			guard let scene = $0.object as? UIScene,
				  scene.session.role == .windowExternalDisplayNonInteractive else {
				return
			}

			hasExternalDisplay = false
		}
		.onChange(of: selectedPhotoItem, initial: false) {
			Task(priority: .userInitiated) {
				guard let item = selectedPhotoItem else {
					return
				}

				do {
					let data = try await item.loadTransferable(type: Data.self)
					guard let data else {
						fatalError("expected a Data")
					}

					guard let image = UIImage(data: data) else {
						fatalError("unable to create a UIImage")
					}

					await MainActor.run {
						photo = image
						showPhotoInExternalDisplay(image)
					}
				} catch {
					print("ERROR: \(error)")
				}
			}
		}
    }

	private func showPhotoInExternalDisplay(_ image: UIImage) {
		guard hasExternalDisplay else {
			return
		}

		NotificationCenter.default.post(
			name: showPictureNotification,
			object: image
		)
	}
}

#Preview {
    ContentView()
}
