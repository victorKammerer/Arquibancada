//
//  GameView.swift
//  Arquibancada Watch App
//
//  Created by aaav on 23/11/22.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        
        
        
        
        VStack{
            
            HStack(spacing: 15){
                VStack(alignment: .center, spacing: 10){
                    Group{
                        Rectangle().frame(width: 42, height: 42).cornerRadius(5)
                        Text("BRA").font(.system(size: 15)).fontWeight(.thin).accessibilityLabel("Brasil")
                        Text("\(2)").font(.system(size: 40))
                    }
                }
                
                Image(systemName: "xmark").resizable().frame(width: 20, height: 20)
                
                VStack(alignment: .center, spacing: 10){
                    Group{
                        Rectangle().frame(width: 42, height: 42).cornerRadius(5)
                        Text("ARG").font(.system(size: 15)).fontWeight(.thin).accessibilityLabel("Argentina")
                        Text("\(0)").font(.system(size: 40))
                    }
                }
            }
            
            Text("90' + 2").font(.system(size: 10))
        }
        
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}
