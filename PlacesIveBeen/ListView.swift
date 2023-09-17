//
//  ListView.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-14.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

struct ListView: View {
    @FirestoreQuery(collectionPath: "places") var places: [Place]
    @EnvironmentObject var placeVM: PlaceViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(places) { place in
                    NavigationLink {
                        DetailView(place: place)
                    } label: {
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.blue)
                        Text(place.city)
                    }
                }
                .onDelete { indexSet in
                    guard let index = indexSet.first else {return}
                    Task {
                        await placeVM.deletePlace(place: places[index])
                    }
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Sign Out") {
                        do {
                            try Auth.auth().signOut()
                            print("🪵 ➡️ Log out successful!")
                            dismiss()
                        } catch {
                            print("😡 ERROR: Could not sign out! \(error.localizedDescription)")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
            .sheet(isPresented: $showSheet) {
                NavigationStack {
                    DetailView(place: Place())
                }
            }
        }
        .padding()
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
