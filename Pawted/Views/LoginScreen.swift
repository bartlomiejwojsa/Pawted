//
//  LoginScreen.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var userService: UserService

    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue)
                Text("Welcome to Pawted!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding(.bottom, 30)
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                    .textInputAutocapitalization(.never)
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 40)
                    .padding(.bottom, 20)
                Button(action: {
                    // Handle login logic here
                    isLoading = true
                    userService.authenticate(email: email, password: password)
                    
                }, label: {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 80)
                        .padding(.vertical, 15)
                        .background(Color.blue)
                        .cornerRadius(30)
                })
                .padding(.top, 30)
                Text(userService.errorMessage?.message ?? "")
            }
            .padding()
            LoaderView(message: "Logging...", isLoading: $isLoading)

        }
        .onDisappear {
            self.isLoading = false
        }
        .onAppear {
            self.isLoading = false
        }
        .onChange(of: userService.errorMessage?.timestamp) { newValue in
            self.isLoading = false
        }
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
