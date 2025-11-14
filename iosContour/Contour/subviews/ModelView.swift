// ModelView.swift

import SwiftUI
import UIKit // 1. Import UIKit

/// The destination view for displaying the user's 3D model or model list.
struct ModelView: View {
    
    // 2. ADD THIS: Receive the image binding from ProfileView
    @Binding var mostRecentImage: UIImage?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Your 3D Model")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)

            // 3. MODIFY THIS: This VStack now shows the image if it exists
            VStack {
                if let image = mostRecentImage {
                    // Show the image
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                    
                } else {
                    // Show the original placeholder if no image exists
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(maxWidth: .infinity)
                        .frame(height: 400)
                        .cornerRadius(15)
                        .overlay(
                            VStack {
                                Image(systemName: "cube.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .foregroundColor(.secondary)
                                Text("3D Model Viewer Placeholder")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                        )
                }
                
                Text(mostRecentImage == nil ? "Your latest model will appear here." : "This is the image from your latest scan.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("3D Model")
    }
}

struct ModelView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // 4. MODIFY THIS: Update preview to work with the binding
            ModelView(mostRecentImage: .constant(nil))
        }
    }
}
