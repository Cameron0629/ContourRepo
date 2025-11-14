// ImagePicker.swift

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    
    // The image that is selected or taken will be stored here
    @Binding var image: UIImage?
    
    // Handles dismissing the camera view
    @Environment(\.presentationMode) private var presentationMode

    // The Coordinator class acts as the bridge between UIKit and SwiftUI
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        // This function is called when the user finishes picking an image
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Get the original image
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            // Dismiss the camera
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    // Creates the Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Creates the UIKit view (UIImagePickerController)
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        
        // Tell the picker to use the .camera
        // (You could also use .photoLibrary to let them pick from their photos)
        picker.sourceType = .camera
        
        return picker
    }

    // This function is required, but we don't need to update the view
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        // No update needed
    }
}
