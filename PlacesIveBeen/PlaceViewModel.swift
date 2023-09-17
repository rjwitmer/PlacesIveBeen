//
//  PlaceViewModel.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-15.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import UIKit

@MainActor

class PlaceViewModel: ObservableObject {
    @Published var place = Place()
    let collectionName = "places"
    
    func savePlace(place: Place) async -> String? {
        let db = Firestore.firestore()
        
        if let id = place.id {   // place already exists, so save
            do {
                try await db.collection(collectionName).document(id).setData(place.dictionary)
                print("😎 Data updated successfully!")
                return place.id
            } catch {
                print("😡 ERROR: Could not update data in '\(collectionName)' --> \(error.localizedDescription)")
                return nil
            }
        } else {    // There is no id so this must be a new place to add
            do {
                let documentRef = try await db.collection(collectionName).addDocument(data: place.dictionary)
                self.place = place
                self.place.id = documentRef.documentID
                print("😎 Data updated successfully!")
                return documentRef.documentID
            } catch {
                print("😡 ERROR: Could not create a new spot in '\(collectionName)' --> \(error.localizedDescription)")
                return nil
            }
        }
    }
    
    func deletePlace(place: Place) async {
        let db = Firestore.firestore()
        guard let id = place.id else {
            print("😡 ERROR: place.id was nil. This should not have happened!")
            return
        }
        
        do {
            let _ = try await db.collection(collectionName).document(id).delete()
            print("🗑️ Place document successfully removed!")
            return
        } catch {
            print("😡 ERROR: removing document: ➡️ \(error.localizedDescription)")
            return
        }
    }
    
    func saveImage(id: String, image: UIImage) async {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")
        
        let resizedImage = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let resizedImage = resizedImage {
            do {
                let metadata = try await storageRef.putDataAsync(resizedImage)
                print("Metadata: ", metadata)
                print("📸 Image Saved!")
            } catch {
                print("😡 ERROR: Uploading image to Firebase Cloud Storage ➡️ \(error.localizedDescription)")
            }
        }
    }
    
    func getImageURL(id: String) async -> URL? {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id)/image.jpg")
        
        do {
            let url = try await storageRef.downloadURL()
            return url
        } catch {
            return nil
        }
    }
    
}
