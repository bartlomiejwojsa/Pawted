//
//  MultipartFormDataConverter.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 04/05/2023.
//

import Foundation
import Alamofire

final class MultiPartFormDataService {
    static func createMultipartFormData(image: UIImage?, parameters: [String: String] = [:]) -> MultipartFormData {
        let multipartFormData = MultipartFormData()
        for (key, value) in parameters {
            multipartFormData.append(value.data(using: .utf8)!, withName: key)
        }
        if let safeImage = image {
            let imageData = safeImage.jpegData(compressionQuality: 0.5)!
            multipartFormData.append(imageData, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
        }
        return multipartFormData
    }
}

