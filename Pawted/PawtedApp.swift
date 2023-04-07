//
//  PawtedApp.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 08/04/2023.
//

import SwiftUI

@main
struct PawtedApp: App {
    let userService = UserService()
    let productService = ProductService()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userService)
                .environmentObject(productService)
        }
        
    }
}
