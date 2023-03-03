//
//  ContentView.swift
//  API Games
//
//  Created by Quinn Kozak on 2/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var titles = [Titles]()
    @State private var showingAlert = false
    var body: some View {
        NavigationView {
            List(titles) { heading in
                NavigationLink {
                    VStack {
                        Text(heading.titles).fontWeight(.bold).font(.largeTitle)
                        Text("Normal Price: $\(heading.normalPrice)").padding()
                        Text("Current Sale Price: $\(heading.salePrice)").padding()
                        Text("Rated \(heading.metacriticScore)/100 by Metacritic").padding()
                        Link("Link to Steam Page", destination: URL(string: "http://store.steampowered.com/app/\(heading.steamAppID)/")!).padding()
                    }
                    Spacer()
                } label: {
                    Text(heading.titles)
                }
            }
            .navigationTitle("Games By Title")
        }
        .task {
            await getTitles()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Loading Error"), message: Text("There was a problem loading the list of games"), dismissButton: .default(Text("OK")))
        }
    }
    func getTitles() async {
            let query = "https://www.cheapshark.com/api/1.0/deals?storeID=1"
            if let url = URL(string: query) {
                if let (data, _) = try? await URLSession.shared.data(from: url) {
                    if let decodedResponse = try? JSONDecoder().decode([Titles].self, from: data) {
                        titles = decodedResponse
                        return
                    }
                }
            }
        showingAlert = true
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
    var steamAppID: String
    var normalPrice: String
    var salePrice: String
    var metacriticScore: String
    
    enum CodingKeys: String, CodingKey {
        case titles = "title"
        case steamAppID = "steamAppID"
        case normalPrice = "normalPrice"
        case salePrice = "salePrice"
        case metacriticScore = "metacriticScore"
    }
}
