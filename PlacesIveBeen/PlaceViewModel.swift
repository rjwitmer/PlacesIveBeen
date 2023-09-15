//
//  PlaceViewModel.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-15.
//

import Foundation
import FirebaseFirestore

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
}
