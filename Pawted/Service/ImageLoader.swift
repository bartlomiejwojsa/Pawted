//
//  ImageLoader.swift
//
//  Created by Bartłomiej Wojsa on 26/03/2023.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published var downloadedImage: UIImage?
    
    private var cache = NSCache<NSString, UIImage>()

    func load(url: String) {
        guard let encodedURLString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let imageURL = URL(string: encodedURLString) else {
            print("Image url \(url) is incorrect or could not be encoded properly.")
            return
        }

        // Check the cache
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: imageURL)),
           let cachedImage = UIImage(data: cachedResponse.data) {
            self.downloadedImage = cachedImage
        } else {
            let session = URLSession.shared
            let task = session.dataTask(with: imageURL) { (data, response, error) in
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.downloadedImage = nil
                    }
                    return
                }

                if let image = UIImage(data: data) {
                    // Save the response into the cache
                    let cachedData = CachedURLResponse(response: response!, data: data)
                    URLCache.shared.storeCachedResponse(cachedData, for: URLRequest(url: imageURL))

                    DispatchQueue.main.async {
                        self.downloadedImage = image
                    }
                }
            }
            task.resume()
        }
    }

}
