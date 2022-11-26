//
//  ViewRouter.swift
//  Arquibancada Watch App
//
//  Created by aaav on 26/11/22.
//

import Foundation

class ViewRouter : ObservableObject {
    init() {
        if !UserDefaults.standard.bool(forKey: "didLaunchBefore") {
            UserDefaults.standard.set(true, forKey: "didLaunchBefore")
            currentPage = "onboardingView"
        } else {
            currentPage = "contentView"
        }
    }
    
    @Published var currentPage: String
    
}
