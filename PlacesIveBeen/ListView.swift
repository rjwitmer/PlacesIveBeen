//
//  ListView.swift
//  PlacesIveBeen
//
//  Created by Bob Witmer on 2023-09-14.
//

import SwiftUI
import Firebase

struct ListView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
            }
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
