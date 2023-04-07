//
//  UserService.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import Foundation
import Combine

class UserService: ObservableObject {
    @Published var appUser: User?
    @Published var errorMessage: ErrorMessage?
    
    private let apiAddress = AppConfiguration.shared.apiAddress
    
    private let AUTH_LOGIN_API: String
    private let AUTH_TOKEN_LOGIN_API: String
    
    private var fetchedToken: String? {
        didSet {
            onFetchedTokenChanged()

        }
    }
    
    init() {
        self.AUTH_LOGIN_API = "\(self.apiAddress)/api/auth/login"
        self.AUTH_TOKEN_LOGIN_API = "\(self.apiAddress)/api/users/user"
        if let appToken = UserDefaults.standard.string(forKey: "appToken") {
            self.fetchedToken = appToken
            onFetchedTokenChanged()
        }
    }
    
    private func onFetchedTokenChanged() {
        UserDefaults.standard.set(self.fetchedToken, forKey: "appToken")
        if let safeToken = self.fetchedToken {
            self.authenticate(token: safeToken)
        }
    }
    
    func logout(_ withMessage: String? = nil) {
        // reset user
        self.appUser = nil
        // deauthenticate
        self.fetchedToken = nil
        self.errorMessage = ErrorMessage(message: withMessage)
    }
    
    func authenticate(email: String, password: String) {
        guard let url = URL(string: self.AUTH_LOGIN_API) else {
            self.logout("Server error, please contact to admin")
            return
        }
        let body = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.logout("Server error, please contact to admin")
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(AuthDto.self, from: data)
                DispatchQueue.main.async {
                    guard response.success else {
                        self.logout(response.message)
                        return
                    }
                    self.appUser = response.user
                    self.fetchedToken = response.user?.token
                }
            } catch {
                DispatchQueue.main.async {
                    self.logout(error.localizedDescription)
                }
            }
        }
        
        task.resume()
    }
    
    private func authenticate(token: String) {
        guard let url = URL(string: "\(AUTH_TOKEN_LOGIN_API)?token=\(token)") else {
            self.logout("Server error, please contact to admin")
            return
        }
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.logout("Server error, please contact to admin")
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(AuthDto.self, from: data)
                DispatchQueue.main.async {
                    guard response.success else {
                        self.logout(response.message)
                        return
                    }
                    self.appUser = response.user
                }
            } catch {
                DispatchQueue.main.async {
                    self.logout(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
}

struct User: Codable {
    let _id: String
    let nick: String
    let email: String
    let token: String
    let imageUrl: String?
    let coins: Int
}


struct AuthDto: Codable {
    let success: Bool
    let message: String
    let user: User?
}

struct ErrorMessage {
    let message: String?
    let timestamp: TimeInterval = Date().timeIntervalSince1970
}
