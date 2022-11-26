//
//  MotherView.swift
//  Arquibancada Watch App
//
//  Created by aaav on 26/11/22.
//

import SwiftUI

struct MotherView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        VStack {
            if viewRouter.currentPage == "onboardingView" {
                Onboarding()
            } else if viewRouter.currentPage == "contentView" {
                ContentView()
            }
        }.onAppear(){
            print(viewRouter.currentPage)
        }
    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView().environmentObject(ViewRouter())
    }
}
