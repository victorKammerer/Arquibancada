//
//  ContentView.swift
//  Arquibancada Watch App
//
//  Created by vko on 23/11/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        ZStack{
            HomeView()
            GameView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

