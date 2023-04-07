//
//  Product.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import Foundation

struct Product: Codable, Identifiable, Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String?
    let title: String
    let description: String
    var imageUrl: String?
    var category: ProductCategory?
    let price: Double?
    var likes: Int = 0
    
}

struct ProductCategory: Codable, Identifiable {
    let id: Int
    let tag: String
    let name: String
    let description: String
}
