//
//  DetailView.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-15.
//

import SwiftUI

struct DetailView: View {
    
    @EnvironmentObject var placeVM: PlaceViewModel
    @Environment(\.dismiss) private var dismiss
    @State var place: Place
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("City:")
                .bold()
            TextField("city", text: $place.city)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            Text("Country:")
                .bold()
            TextField("country", text: $place.country)
                .textFieldStyle(.roundedBorder)
                .padding(.bottom)
            
            HStack {
                Text("Flag:")
                    .bold()
                TextField("flag", text: $place.flag)
                    .textFieldStyle(.roundedBorder)
            }
            .padding(.bottom)
            
            HStack {
                Text("Type of travel:")
                    .bold()
                Spacer()
                Picker("", selection: $place.traveledAs) {
                    ForEach(TraveledAs.allCases, id: \.self) { traveledAs in
                        Text(traveledAs.rawValue.capitalized)
                            .tag(traveledAs.rawValue)
                    }
                }
            }
            .padding(.bottom)
            
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    Task {
                        let id = await placeVM.savePlace(place: place)
                        if id != nil {  // save worked!
                            dismiss()
                        } else {
                            print("😡 ERROR: Saving place!")
                        }
                    }
                }
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationStack {
            DetailView(place: Place(city: "Valletta", country: "Malta", flag: "🇲🇹"))
                .environmentObject(PlaceViewModel())
        }
    }
}
