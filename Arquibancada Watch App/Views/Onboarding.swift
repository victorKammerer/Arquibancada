//
//  Onboarding.swift
//  Arquibancada Watch App
//
//  Created by aaav on 26/11/22.
//

import SwiftUI

struct Onboarding: View {
    
    let notify = NotificationHandler()
    
    @AppStorage("name") var name : String = "User"
    @AppStorage("email") var email : String = "Email"
    @AppStorage("password") var password : String = "Password"
    @AppStorage("token") var token : String = "Token"
    
    var body: some View {
        
        TabView {
            Image("icon_onboarding").resizable().scaledToFit().clipShape(Circle())
            Text("Acompanhe todos jogos da Copa. Se rolar gol, não se preocupa que a gente treme aqui pra te avisar!").padding().multilineTextAlignment(.center)
            
            VStack{
                Text("Você nos permite lhe enviar notificações?").padding().multilineTextAlignment(.center)
                
                Button("Permito"){
                    notify.askPermission()
                }
            }
            
            NavigationView{
                VStack {
                    NavigationLink(destination: ContentView()) {
                        Text("Vamos começar!")
                    }
                }
            }.onAppear(){
                Task.init{
                    await createLogin()
                }
                
            }
            
            
        }.tabViewStyle(.page)
        
        
    }
    
    func createLogin() async {
        self.name = randomString()
        self.email = "\(randomString())@kiorasao.com.br"
        self.password = randomString()
        let dict : [String : Any] = ["name": name, "email" : email, "password" : password, "passwordConfirm" : password]
        let jsonData = try? JSONSerialization.data(withJSONObject: dict)
        
        print(dict)
        guard let urlUser = URL(string: "http://api.cup2022.ir/api/v1/user") else {
            print("Invalid URL")
            return
        }
        var requestToken = URLRequest(url: urlUser)
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
                print(data)
                if let decodedResponse = try? JSONDecoder().decode(User.self, from: data){
                    print("retrieving user token")
                    self.token = decodedResponse.data.token
                }
            }
        }.resume()
    }
}

func randomString() -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0..<Int.random(in: 8..<16)).map{ _ in letters.randomElement()! })
}


struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
