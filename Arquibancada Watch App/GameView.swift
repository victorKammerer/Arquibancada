//
//  GameView.swift
//  Arquibancada Watch App
//
//  Created by aaav on 24/11/22.
//

import SwiftUI


struct GameView: View {
    @State private var match : String = ""
    @State var urlStr = "http://api.cup2022.ir/api/v1/match/3"
    @State var yourToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2MzdjZDgwNzQ4NzA5MjMzZmQ5ZWU1MzIiLCJpYXQiOjE2NjkyMzgzNTYsImV4cCI6MTY2OTMyNDc1Nn0.TB65_PmnS8mNE4wRcNafu1VKimecVkMYmKsxeiFX9IY"
    
    var body: some View {
        VStack{
            Text(match)
        }.task {
            await loadData()
        }
    }
    
    func loadData() async {
        guard let url = URL(string: urlStr) else {
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
                
                let word = String(data: data, encoding: .utf8)
                self.match = word!
                
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
