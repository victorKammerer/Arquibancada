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
            Text(adjustTime(gametime: api.match?.data[0].time_elapsed ?? "tempo"))
                .font(.footnote)
            
            Text(adjustMatch(stage: api.match?.data[0].type ?? "finais"))
                .font(.footnote)
            
        }.onAppear(){
            Task.init {
                await api.loadData(matchnum: matchnum)
            }
        }
    }
    
    func adjustTime(gametime: String) -> String{
        if gametime == "tempo"{
            return "tempo"
        }else if gametime == "notstarted"{
            return "Próximo jogo"
        }else if gametime == "h1" {
            return "1º Tempo"
        } else if gametime == "h2" {
            return "2º Tempo"
        }else if gametime == "hf" {
            return "Intervalo"
        } else {
            return "Terminado"
        }
    }
    
    func adjustMatch(stage: String) -> String{
        if stage == "finais"{
            return "finais"
        }else if stage == "R16"{
            return "Oitavas de final"
        }else if stage == "QR" {
            return "Quartas de final"
        } else if stage == "semi" {
            return "Semifinal"
        }else if stage == "3RD"{
            return "Terceiro lugar"
        }else if stage == "FIN" {
            return "Final"
        } else {
            return "Terminado"
        }
    }
    
}


struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
