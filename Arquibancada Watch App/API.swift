//
//  API.swift
//  Arquibancada Watch App
//
//  Created by aaav on 25/11/22.
//

import Foundation

class API : ObservableObject {
    
    @Published var match : Match?
    var urlStr = "http://api.cup2022.ir/api/v1/match/"
    var token1 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzdjZDgwNzQ4NzA5MjMzZmQ5ZWU1MzIiLCJpYXQiOjE2NjkzODMzMDcsImV4cCI6MTY2OTQ2OTcwN30.5eNJCUY-5gR9yGGQEhBnb74aTLkhxKk3eKEOlkLcyQk"
    

    func loadData(matchnum : Int) async {
        guard let url = URL(string: urlStr + "\(matchnum)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("Bearer \(token1)", forHTTPHeaderField:"Authorization")
        request.timeoutInterval = 60.0
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            if let httpResponse = response as? HTTPURLResponse{
                if httpResponse.statusCode == 401{
                    print("Refresh token...")
                    
                    // get another token by reloging
                    
                    return
                }
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                if let decodedResponse = try? JSONDecoder().decode(Match.self, from: data){
                    self.match = decodedResponse
                }
            }
        }.resume()
    }
    
}
