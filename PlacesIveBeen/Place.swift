//
//  Place.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-14.
//

import Foundation
import FirebaseFirestoreSwift

enum TraveledAs: String, CaseIterable, Codable {
    case solo, family, friends, business, study
}

struct Place: Codable, Identifiable {
    @DocumentID var id: String?
    var city = ""
    var country = ""
    var flag = ""
    var traveledAs = TraveledAs.solo.rawValue
    var imageID = ""
    
    var dictionary: [String: Any] {
        return ["city": city, "country": country, "flag": flag, "traveledAs": traveledAs, "imageID": imageID]
    }
}
