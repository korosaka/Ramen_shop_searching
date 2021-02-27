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
    
    init(reviewImages: Binding<[UIImage]?>,
         sourceType: UIImagePickerController.SourceType) {
        self._reviewImages = reviewImages
        self.sourceType = sourceType
        role = .reviewPicture
    }
    
    init(delegate: ImagePickerDelegate?) {
        self._reviewImages = Binding.constant(nil)
        role = .userIcon
        self.delegate = delegate
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
    @Environment(\.presentationMode) private var presentationMode
    weak var delegate: ImagePickerDelegate?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        //MARK: TODO create function when couldn't get Pic even after selected it in Picker (this bug is sometimes happening)
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                switch parent.role {
                case .reviewPicture:
                    if parent.reviewImages == nil {
                        parent.reviewImages = .init()
                    }
                    parent.reviewImages!.append(image)
                case .userIcon:
                    parent.delegate?.pickedPicture(image: image)
                }
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

protocol ImagePickerDelegate: class {
    func pickedPicture(image: UIImage)
}

extension ImagePickerDelegate {
    func pickedPicture(image: UIImage) {
        print("default implemented pickedPicture")
    }
}

