//
//  NewsView.swift
//  Arquibancada Watch App
//
//  Created by vko on 26/11/22.
//

import SwiftUI

struct NewsView: View {
    
    @ObservedObject var api : API = API()
    
    @State var matchnum = 24
    
    let timer = Timer.publish(every: 120, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ScrollView {
            ScrollViewReader { value in
                VStack {
                    ForEach(0..<50) { index in
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 40)
                        
                    }
                    .onAppear {
                       //        proxy.scrollTo(value, anchor: .center)
                    }
                }
            }
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
