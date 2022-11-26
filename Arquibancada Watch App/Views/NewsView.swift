//
//  NewsView.swift
//  Arquibancada Watch App
//
//  Created by vko on 26/11/22.
//

import SwiftUI

struct NewsView: View {
    
    var body: some View {
        ScrollView {
            ScrollViewReader { value in
                VStack {
                    ForEach(0..<50) { index in
                        RoundedRectangle(cornerRadius: 5)
                            .frame(height: 40)
                    }
                    .onAppear {
                        //value.scrollTo()
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
