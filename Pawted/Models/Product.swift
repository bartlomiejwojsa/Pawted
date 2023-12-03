//
//  Product.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import Foundation

struct Product: Codable, Identifiable, Equatable, Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) // Assuming 'id' is a property in your Product type
    }

    let id: String
    let title: String
    let description: String
    let userId: ProductUser
    var imageUrl: String?
    var category: ProductCategory?
    let price: Double?
    var likes: [String]
}

struct ProductUser: Codable, Equatable {
    static func == (lhs: ProductUser, rhs: ProductUser) -> Bool {
        return lhs.nick == rhs.nick
    }
    let email: String
    let nick: String
}

struct ProductCategory: Codable, Identifiable, Equatable {
    static func == (lhs: ProductCategory, rhs: ProductCategory) -> Bool {
        return lhs.id == rhs.id
    }
    let id: Int
    let tag: String
    let name: String
    let description: String
}
