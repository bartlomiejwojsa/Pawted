//
//  ProductViewModel.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 03/12/2023.
//

import Foundation

class ProductViewModel: ObservableObject {
    @Published var product: Product

    init(product: Product) {
        self.product = product
    }
}
