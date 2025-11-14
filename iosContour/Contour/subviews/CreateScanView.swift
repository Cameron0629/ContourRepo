// CreateScanView.swift

import SwiftUI
import UIKit // 1. Import UIKit

/// The view where the user initiates a new 3D scan using the device camera.
struct CreateScanView: View {
    
    // 2. ADD THIS: Receive the image binding from ProfileView
    @Binding var mostRecentImage: UIImage?
    
    // 3. ADD THIS: State to control showing the camera
    @State private var isShowingCamera = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Ready to Scan?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            // 4. MODIFY THIS: This ZStack now shows the image if it exists
            ZStack {
                if let image = mostRecentImage {
                    // Show the image they just took
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(15)
                } else {
                    // Show the placeholder if no image is set yet
                    Rectangle()
                        .fill(Color.black)
                        .aspectRatio(3/4, contentMode: .fit)
                        .cornerRadius(15)
                    
                    Image(systemName: "video.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60)
                        .foregroundColor(Color.gray.opacity(0.8))
                }
                
                // Overlay for the scanning frame (can stay)
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.green, lineWidth: 4)
                    .frame(width: 250, height: 350)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // 5. MODIFY THIS: The button now opens the camera
            Button {
                isShowingCamera = true // This will open the sheet
            } label: {
                Text(mostRecentImage == nil ? "Start Scanning" : "Take New Photo")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationTitle("New Scan")
        // 6. ADD THIS: This sheet presents the ImagePicker
        .sheet(isPresented: $isShowingCamera) {
            ImagePicker(image: $mostRecentImage)
        }
    }
}

struct CreateScanView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // 7. MODIFY THIS: Update preview to work with the binding
            CreateScanView(mostRecentImage: .constant(nil))
        }
    }
}
