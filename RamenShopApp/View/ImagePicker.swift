//
//  ImagePicker.swift
//  RamenShopApp
//
//  Created by Koro Saka on 2020-12-22.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    init(reviewImages: Binding<[UIImage]?>) {
        self._reviewImages = reviewImages
        self._profileIconImage = Binding.constant(nil)
        role = .reviewPicture
    }
    
    init(iconImage: Binding<UIImage?>) {
        self._profileIconImage = iconImage
        self._reviewImages = Binding.constant(nil)
        role = .userIcon
    }
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    let role: PickerRole
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator  // Coordinater to adopt UIImagePickerControllerDelegate Protcol.
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {}
    
    // MARK: - Using Coordinator to Adopt the UIImagePickerControllerDelegate Protocol
    @Binding var reviewImages: [UIImage]?
    @Binding var profileIconImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                switch parent.role {
                case .reviewPicture:
                    if parent.reviewImages == nil {
                        parent.reviewImages = .init()
                    }
                    parent.reviewImages!.append(image)
                case .userIcon:
                    parent.profileIconImage = image
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

enum PickerRole {
    case reviewPicture, userIcon
}
