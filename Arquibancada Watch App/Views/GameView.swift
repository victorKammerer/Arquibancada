//
//  GameView.swift
//  Arquibancada Watch App
//
//  Created by aaav on 24/11/22.
//

import SwiftUI
//import Foundation

struct GameView: View {
    
    var notify = NotificationHandler()
    
    @ObservedObject var api : API = API()
    
    @AppStorage("matchnum") var matchnum : Int = 36
    
    let timer = Timer.publish(every: 120, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack{
            HStack(spacing: 5){
                VStack(alignment: .center, spacing: 10){
                    Group{
                        AsyncImage(url: URL(string: api.match?.data[0].home_flag ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 64, height: 44)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.white, lineWidth: 1)
                            )
                        Text(api.match?.data[0].home_team_en.prefix(3).uppercased() ?? "TEAM 1").accessibilityLabel(api.match?.data[0].home_team_en ?? "Team one")
                        Text("\(api.match?.data[0].home_score ?? 0)").font(.largeTitle)
                    }
                }
                
                Image(systemName: "xmark").resizable().frame(width: 20, height: 20)
                
                VStack(alignment: .center, spacing: 10){
                    Group{
                        AsyncImage(url: URL(string: api.match?.data[0].away_flag ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 64, height: 44)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.white, lineWidth: 1)
                            )
                        Text(api.match?.data[0].away_team_en.prefix(3).uppercased() ?? "TEAM 2").accessibilityLabel(api.match?.data[0].home_team_en ?? "Team one")
                        Text("\(api.match?.data[0].away_score ?? 0)").font(.largeTitle)
                    }
                }
            }.onReceive(timer){ _ in
                Task.init {
                    await api.loadData(matchnum: matchnum)
                }
            }
            
            .onChange(of: api.match?.data[0].id) {newValue in
                
                if ((api.match?.data[0].finished) ?? "FALSE" != "FALSE") {
                    matchnum += 1
                    Task.init {
                        await api.loadData(matchnum: matchnum)
                    }
                }
            }
            Text(adjustDate(qatar_date: api.match?.data[0].local_date ?? "matchtime"))
                .font(.footnote)
            
        }.onAppear(){
            Task.init {
                await api.loadData(matchnum: matchnum)
            }
        }
    }
    
    func adjustDate(qatar_date: String) -> String{
        if qatar_date == "matchtime"{
            return "matchtime"
        }
        
        let qatar_date = "12/1/2022/ 18:00"
        let qatar_full_hour = qatar_date.suffix(5)
        let qatar_hour = qatar_full_hour.prefix(2)
        let brazil_hour = Int(qatar_hour)! - 6
        let final_hour = qatar_date.dropLast(5) + String(brazil_hour) + ":00"

        return final_hour
    }
    
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
