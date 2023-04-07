//
//  ContentView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 08/04/2023.
//

import SwiftUI

struct ContentView: View {
    @State var showWelcome: Bool = true
    @State var connectionTestResult: Bool? = nil
    @EnvironmentObject var userService: UserService

    var body: some View {
        if showWelcome || (AppConfiguration.shared.shouldTestConnection && !(connectionTestResult ?? false)) {
            WelcomeView(connectionTestResult: $connectionTestResult, showWelcome: $showWelcome)
        } else if userService.appUser != nil {
            MainView()
        } else {
            LoginScreen()
        }
    }
    

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

