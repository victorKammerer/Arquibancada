//
//  API.swift
//  Arquibancada Watch App
//
//  Created by aaav on 25/11/22.
//

import Foundation

class API : ObservableObject {
    var notify = NotificationHandler()
    var gameon = true
    @Published var match : Match?
    var urlStr = "http://api.cup2022.ir/api/v1/match/"
    var token1 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzdjZDgwNzQ4NzA5MjMzZmQ5ZWU1MzIiLCJpYXQiOjE2Njk0ODg0ODUsImV4cCI6MTY2OTU3NDg4NX0.peDBEnUZ__Qh3vDFIrYvlQmi5jJPRMTN-2znhh_At1k"
    
    var token = UserDefaults.standard.string(forKey: "token")
    var email = UserDefaults.standard.string(forKey: "email")
    var password = UserDefaults.standard.string(forKey: "password")
    
    
    
    func loadData(matchnum : Int) async {
        
        guard let url = URL(string: urlStr + "\(matchnum)") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.setValue("Bearer \(token ?? token1)", forHTTPHeaderField:"Authorization")
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
                    
                    if (self.match?.data[0].away_score != decodedResponse.data[0].away_score){
                        if (decodedResponse.data[0].away_score != 0){
                            self.notify.sendNotification(title: "⚽️ GOL!",
                                                         timeInterval: 5,
                                                         body:  "\(decodedResponse.data[0].away_team_en)")
                        }
                    }
                    if (self.match?.data[0].home_score != decodedResponse.data[0].home_score){
                        if (decodedResponse.data[0].home_score != 0){
                            self.notify.sendNotification(title: "⚽️ GOL!",
                                                         timeInterval: 5,
                                                         body:  "\(decodedResponse.data[0].home_team_en)")
                        }
                        else {
                            print(decodedResponse.data[0].time_elapsed)
                            if (decodedResponse.data[0].time_elapsed == "h1" && self.gameon){
                                self.notify.sendNotification(title: "Jogo em andamento",
                                                             timeInterval: 5,
                                                             body:  "\(decodedResponse.data[0].home_team_en) x \(decodedResponse.data[0].away_team_en)")
                                self.gameon = false                            }
                            if (decodedResponse.data[0].time_elapsed == "finished"){
                                self.gameon = true
                            }
                        }
                    }
                    self.match = decodedResponse
                }
            }
        }.resume()
        
        @Sendable func getNewToken(matchnum : Int) async {
            let dict : [String : Any] = ["email" : email ?? "aaavalenca@gmail.com", "password" : password ?? "kiorasao"]
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
                        self.token = decodedResponse.data.token
                        print(self.token ?? self.token1)
                        
                        Task.init {
                            await self.loadData(matchnum: matchnum)
                        }
                    }
                }
            }.resume()
        }
    }
}
