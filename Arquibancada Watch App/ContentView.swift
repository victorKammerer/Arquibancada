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
            Color.gray.ignoresSafeArea().opacity(0.1)
            VStack{
                Circle()
                    .fill(LinearGradient(colors: [.black, .gray], startPoint: .init(x: 0, y: 0.6), endPoint: .init(x: 0, y: 1.5)))
                    .frame(width: 250, height: 250)
                    .scaledToFill()
                Circle()
                    .opacity(0)
                    .frame(width: 250, height: 250)
                    .scaledToFill()
            }
            HomeView()
        }

struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

