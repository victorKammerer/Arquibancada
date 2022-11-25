//
//  GameView.swift
//  Arquibancada Watch App
//
//  Created by aaav on 24/11/22.
//

import SwiftUI


struct GameView: View {
    
    @ObservedObject var api : API = API()
    
    var body: some View {
        
        VStack{
            HStack(spacing: 5){
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
                        Text(api.match?.data[0].away_team_en.prefix(3).uppercased() ?? "TEAM 1").accessibilityLabel(api.match?.data[0].away_team_en ?? "Team one")
                        Text("\(api.match?.data[0].away_score ?? 0)")
                    }
                }
                
                Image(systemName: "xmark").resizable().frame(width: 20, height: 20)
                
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
                        Text(api.match?.data[0].home_team_en.prefix(3).uppercased() ?? "TEAM 2").accessibilityLabel(api.match?.data[0].away_team_en ?? "Team one")
                        Text("\(api.match?.data[0].home_score ?? 0)")
                    }
                }
            }
            
            Text("90' + 2")
                .font(.footnote)
        }.onAppear(){
            Task.init {
                await api.loadData(matchnum: 4)
            }
            
        }
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
