//
//  GameView.swift
//  Arquibancada Watch App
//
//  Created by aaav on 24/11/22.
//

import SwiftUI


struct GameView: View {
    @State private var away_team_en : String = ""
    @State private var away_score : Int = 0
    @State private var home_team_en : String = ""
    @State private var home_score : Int = 0
    @State var urlStr = "http://api.cup2022.ir/api/v1/match/"
    @State var yourToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzdjZDgwNzQ4NzA5MjMzZmQ5ZWU1MzIiLCJpYXQiOjE2NjkyMzgzNTYsImV4cCI6MTY2OTMyNDc1Nn0.TB65_PmnS8mNE4wRcNafu1VKimecVkMYmKsxeiFX9IY"
    @State var matchnum : Int = 3
    
    var body: some View {
        HStack{
            
            VStack{
                Text(away_team_en)
                Text("\(away_score)")
            }
            VStack{
                Text(home_team_en)
                Text("\(home_score)")
            }
        }.task {
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

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
