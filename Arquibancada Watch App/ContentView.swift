//
//  ContentView.swift
//  Arquibancada Watch App
//
//  Created by vko on 23/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var away_team_en : String = ""
    @State private var away_score : Int = 0
    @State private var home_team_en : String = ""
    @State private var home_score : Int = 0
    @State private var away_scorers : [String] = []
    
    @State var urlStr = "http://api.cup2022.ir/api/v1/match/"
    @State var yourToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzdlYWMyZmY5YzMyYjNmNjM0N2NjNTIiLCJpYXQiOjE2NjkyODkxNDYsImV4cCI6MTY2OTM3NTU0Nn0.f3S-865aUlyMCPyzIM3fypWmL2ZnWon8pPO4_ywVP6w"
    @State var matchnum : Int = 3
    
    var body: some View {
        
        NavigationView {
            List {
                HStack(alignment: .center) {
                    Image("gol_icon")
                        .colorInvert()
                    VStack(alignment: .leading) {
                        Text("GOOOL!!")
                            .font(.headline)
                        
                        HStack{
                            Image("bandeira")
                            Text(away_team_en + " -")
                            Text("E. Valencia")
                                .scaledToFill()
                        }
                        .scaledToFill()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        
                    }
                }
                HStack(alignment: .center) {
                    Image("gol_icon")
                        .colorInvert()
                    VStack(alignment: .leading) {
                        Text("GOOOL!!")
                            .font(.headline)
                        
                        HStack{
                            Image("bandeira")
                            Text(away_team_en + " -")
                            Text("E. Valencia")
                                .scaledToFill()
                        }
                        .scaledToFill()
                        .minimumScaleFactor(0.01)
                        .lineLimit(1)
                        
                    }
                }
            }
            .foregroundColor(.white)
            .navigationTitle("Arquibancada")
            .foregroundColor(.white)
        }
        .task {
            await loadData()
        }
    }
        
    
    func loadData() async {
        guard let url = URL(string: urlStr + "\(matchnum)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("Bearer \(yourToken)", forHTTPHeaderField:"Authorization")
        request.timeoutInterval = 60.0
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 401{
                    print("Refresh token...")
                    return
                }
            }
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                
                
                if let decodedResponse = try? JSONDecoder().decode(Match.self, from: data){
                    print(decodedResponse)
                    self.away_team_en = decodedResponse.data[0].away_team_en
                    self.away_score = decodedResponse.data[0].away_score
                    self.home_team_en = decodedResponse.data[0].home_team_en
                    self.home_score = decodedResponse.data[0].home_score
                }
                
                //                let word = String(data: data, encoding: .utf8)
                
            }
            
        }
        dataTask.resume()
    }
}
struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

