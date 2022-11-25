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
    var token1 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzdjZDgwNzQ4NzA5MjMzZmQ5ZWU1MzIiLCJpYXQiOjE2NjkzOTAzNzIsImV4cCI6MTY2OTQ3Njc3Mn0.lYHRQkYfSTnz5mfAtn1kcXCo3SbEuUVwJ4Q905VpXKA"
    
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
                    
                    Task.init {
                        await getNewToken(matchnum: matchnum)

                    }
                    
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
        
        @Sendable func getNewToken(matchnum : Int) async {
            var dict : [String : Any] = ["email" : "aaav@academy.cin.ufpe.br", "password" : "kiorasao"]
            let jsonData = try? JSONSerialization.data(withJSONObject: dict)
            
            guard let urlLogin = URL(string: "http://api.cup2022.ir/api/v1/user/login") else {
                print("Invalid URL")
                return
            }
            var requestToken = URLRequest(url: urlLogin)
            requestToken.httpMethod = "POST"
            requestToken.setValue("application/json", forHTTPHeaderField:"Content-Type")
            requestToken.httpBody = jsonData
            requestToken.timeoutInterval = 60.0
            URLSession.shared.dataTask(with: requestToken) { (data, response, error) in
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 401{
                        print("I can't token anymore...")
                        return
                    }
                }
                guard let data = data else { return }
                DispatchQueue.main.async {
                    if let decodedResponse = try? JSONDecoder().decode(Login.self, from: data){
                        print("retrieving new token")
                        self.token1 = decodedResponse.data.token
                        print(self.token1)
                        
                        Task.init {
                            await self.loadData(matchnum: matchnum)
                        }
                    }
                }
            }.resume()
        }
    }
}
