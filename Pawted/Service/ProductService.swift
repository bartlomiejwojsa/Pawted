//
//  ProductService.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import Foundation
import Combine
import Alamofire

class ProductService: ObservableObject {
    @Published var hotProducts: [Product] = []
    @Published var productCategories: [ProductCategory] = []
    private var cancellables = Set<AnyCancellable>()
    private var needRefresh = true
    @Published var lastErrorMessage: String?
    @Published var lastErrorCode: HTTPError?

    private let apiAddress = AppConfiguration.shared.apiAddress

    func getProductCategories(user: User) {
        guard let url = URL(string: "\(apiAddress)/api/products/categories") else {
            self.lastErrorMessage = "Invalid URL"
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPError.badServerResponse
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    if (401...403).contains(httpResponse.statusCode) {
                        // should be logout
                        throw HTTPError.unauthorized
                    }
                    throw HTTPError.badServerResponse
                }

                return data
            }
            .decode(type: GetProductCategoriesDto.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let error = error as? HTTPError {
                        self.lastErrorCode = error
                    }
                    print("Error while fecthing productCategories!: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.productCategories = response.productCategories ?? []
            }
            .store(in: &cancellables)
    }
    
    func getHotProducts(user: User) {
        guard let url = URL(string: "\(apiAddress)/api/products/top-rated?limit=999") else {
            self.lastErrorMessage = "Invalid URL"
            return
        }
        var request = URLRequest(url: url)
        request.addValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPError.badServerResponse
                }
                guard (200..<300).contains(httpResponse.statusCode) else {
                    if (401...403).contains(httpResponse.statusCode) {
                        // should be logout
                        throw HTTPError.unauthorized
                    }
                    throw HTTPError.badServerResponse
                }
                return data
            }
            .decode(type: GetProductsDto.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let error = error as? HTTPError {
                        self.lastErrorCode = error
                    }
                    print("Error while fecthing products!: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                self?.hotProducts = result.products ?? []
            }
            .store(in: &cancellables)
    }
    
    func updateLike(for product: Product, by user: User, isLiked: Bool) {
        guard let url = URL(string: "\(apiAddress)/api/products/\(product.id ?? "")") else {
            self.lastErrorMessage = "Invalid URL"
            return
        }
        
        let body = ["like": ["userId": user._id, "value": (isLiked ? 1 : 0)]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: body)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(user.token)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.lastErrorMessage = error?.localizedDescription ?? "Unknown error"
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(UpdateProductDto.self, from: data)
                guard response.success else {
                    DispatchQueue.main.async {
                        self.lastErrorMessage = response.message
                    }
                    return
                }
                DispatchQueue.main.async {
                    var newProduct = product
                    newProduct.likes = (isLiked ? 1 : 0)
                    let newProducts = self.hotProducts.map { prod in
                        var updatedProd = prod
                        if updatedProd.id == product.id {
                            updatedProd.likes = newProduct.likes
                        }
                        return updatedProd
                    }
                    self.hotProducts = newProducts
                }
            } catch {
                DispatchQueue.main.async {
                    self.lastErrorMessage = error.localizedDescription
                }
            }
        }
        task.resume()
    }
    
    func addProduct(_ product: Product, categoryTag: String, image: UIImage?, user: User) {
        guard let url = URL(string: "\(apiAddress)/api/products") else {
            self.lastErrorMessage = "Invalid URL"
            return
        }
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(user.token)",
            "Content-type": "multipart/form-data"
        ]
        let multiPartFormData = MultiPartFormDataService.createMultipartFormData(
            image: image,
            parameters: [
                "title"         : product.title,
                "description"   : product.description,
                "price"         : String(product.price ?? 0),
                "categoryTag"   : categoryTag
            ])
        AF.upload(multipartFormData: multiPartFormData, to: url, method: .post, headers: headers)
            .validate()
            .responseDecodable(of: UpdateProductDto.self) { response in
                // ok
                switch response.result {
                case .failure(let error):
                    print("Error while uploading photo", error)
                case .success(_):
                    print("New photo has been uploaded")
                    
                }
            }
        
    }
}

struct UpdateProductDto: Codable {
    let success: Bool
    let message: String
}

struct GetProductsDto: Codable {
    let success: Bool
    let message: String
    let products: [Product]?
}

struct GetProductCategoriesDto: Codable {
    let success: Bool
    let message: String
    let productCategories: [ProductCategory]?
}
