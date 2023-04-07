//
//  TestConnectionManager.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 23/10/2023.
//

import Foundation
import Alamofire

enum TestNetworkError: Error {
    case badURL
    case noConnection
    case timedOut
}

struct TestConnectionManager {
    private let apiAddress = AppConfiguration.shared.apiAddress

    func getTestPage(completion: @escaping (Result<String, TestNetworkError>) -> ()) {
        guard let url = URL(string: "\(apiAddress)/") else {
            DispatchQueue.main.async {
                completion(.failure(.badURL))
            }
            return
        }
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 5
        let session = URLSession(configuration: sessionConfiguration)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error as? URLError, error.code == URLError.timedOut {
                // Handle the timeout error here
                DispatchQueue.main.async {
                    completion(.failure(.timedOut))
                }
            } else if let httpResponse = response as? HTTPURLResponse {
                guard (200...299).contains(httpResponse.statusCode) else {
                    DispatchQueue.main.async {
                        completion(.failure(.noConnection))
                    }
                    return
                }
                DispatchQueue.main.async {
                    completion(.success("ok"))
                }
            }
        }
        task.resume()
    }
}
