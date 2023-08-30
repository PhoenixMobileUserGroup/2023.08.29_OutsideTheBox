//
//  ContentView.swift
//  ExternalDisplayDemo
//
//  Created by michael.collins on 8/29/23.
//

import PhotosUI
import SwiftUI

let showPictureNotification = Notification.Name("ShowPicture")

struct ContentView: View {
	@State private var selectedPhotoItem: PhotosPickerItem?
	@State private var photo: UIImage?
	@State private var hasExternalDisplay = false

	let willConnectPublisher = NotificationCenter.default.publisher(for: UIScene.willConnectNotification)
	let didDisconnectPublisher = NotificationCenter.default.publisher(for: UIScene.didDisconnectNotification)

	var body: some View {
		VStack {
			PhotosPicker(
				selection: $selectedPhotoItem,
				matching: .images
			) {
				Text("Select a Photo")
			}

			Spacer()

			if !hasExternalDisplay, let photo {
				Image(uiImage: photo)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.animation(.default, value: photo)

				Spacer()
			}
		}
		.onChange(of: selectedPhotoItem) {
			guard let selectedPhotoItem else {
				return
			}

			Task(priority: .userInitiated) {
				do {
					guard let data = try await selectedPhotoItem.loadTransferable(type: Data.self) else {
						fatalError("expected a Data")
					}

					guard let photo = UIImage(data: data) else {
						fatalError("unable to create UIImage")
					}

					await MainActor.run {
						self.photo = photo
					}

					showPicture(photo)
				} catch {
					print("ERROR: \(error)")
				}
			}
		}
		.onReceive(willConnectPublisher) {
			guard let scene = $0.object as? UIScene,
				  scene.session.role == .windowExternalDisplayNonInteractive else {
				return
			}

			hasExternalDisplay = true

			if let photo {
				Task { @MainActor in
					showPicture(photo)
				}
			}
		}
		.onReceive(didDisconnectPublisher) {
			guard let scene = $0.object as? UIScene,
				  scene.session.role == .windowExternalDisplayNonInteractive else {
				return
			}

			hasExternalDisplay = false
		}
	}

	private func showPicture(_ photo: UIImage) {
		NotificationCenter.default.post(
			name: showPictureNotification,
			object: photo
		)
	}
}

#Preview {
    ContentView()
}
