//
//  ContentView.swift
//  API Games
//
//  Created by Quinn Kozak on 2/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var titles = [Titles]()
    var body: some View {
        NavigationView {
            List(titles) { heading in
                NavigationLink {
                    VStack {
                        Text(heading.titles)
                    }
                } label: {
                    Text(heading.titles)
                }
            }
            .navigationTitle("Games By Title")
        }
        .task {
            await getTitles()
        }
    }
    func getTitles() async {
            let query = "https://www.cheapshark.com/api/1.0/deals?storeID=1"
            if let url = URL(string: query) {
                if let (data, _) = try? await URLSession.shared.data(from: url) {
                    if let decodedResponse = try? JSONDecoder().decode([Titles].self, from: data) {
                        titles = decodedResponse
                    }
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Titles: Identifiable, Codable {
    var id = UUID()
    var titles: String
    
    
    enum CodingKeys: String, CodingKey {
        case titles = "title"
        
    }
}
