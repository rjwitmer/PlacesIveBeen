//
//  DetailView.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-15.
//

import SwiftUI
import PhotosUI

struct DetailView: View {
    
    @EnvironmentObject var placeVM: PlaceViewModel
    @Environment(\.dismiss) private var dismiss
    @State var place: Place
    @State private var selectedImage: Image = Image(systemName: "photo")
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var imageURL: URL?
    
    var body: some View {
        NavigationStack {
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
                
                HStack {
                    Text("Favorite Image:")
                        .bold()
                    Spacer()
                    PhotosPicker(selection: $selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Label("", systemImage: "photo.fill.on.rectangle.fill")
                    }
                    .onChange(of: selectedPhoto) { newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        selectedImage = Image(uiImage: uiImage)
                                    }
                                }
                            } catch {
                                print("😡 ERROR: loading failed ➡️ \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .padding(.bottom)
                
                if imageURL != nil {
                    AsyncImage(url: imageURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    selectedImage
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                }
                
                Spacer()
                
            }
            .padding()
            .task {
                if let id = place.id {  // This isn't a new place
                    if let url = await placeVM.getImageURL(id: id) {
                        imageURL = url
                    }
                }
            }
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
                                place.id = id
                                print("place.id = \(place.id ?? "nil")")
                                await placeVM.saveImage(id: place.id ?? "", image: ImageRenderer(content: selectedImage).uiImage ?? UIImage())
                                dismiss()
                            } else {
                                print("😡 ERROR: Saving place!")
                            }
                        }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
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
