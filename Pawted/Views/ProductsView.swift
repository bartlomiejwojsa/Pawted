//
//  ProductsView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct ProductsView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var userService: UserService
    
    let products: [Product]
    let categories: [ProductCategory]

    private let defaultCategory: ProductCategory = ProductCategory(id: 0, tag: "ALL", name: "All", description: "All categories")
    @State private var categorySelection: String = "ALL"
    
    var filteredProducts: [Product] {
        if categorySelection == defaultCategory.tag {
            return products
        } else {
            return products.filter { $0.category?.tag == categorySelection }
        }
    }
    
    var body: some View {
        VStack() {
            Picker(selection: $categorySelection, label: Text("Select category")) {
                ForEach([defaultCategory] + categories, id: \.id) { category in
                    Text(category.name).tag(category.tag)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 16)
            
            if (products.isEmpty) {
                Spacer()
                HStack {
                    Text("Nothing here...")
                        .padding()
                }
                Spacer()

            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible(maximum: 250), spacing: 24), GridItem(.flexible(maximum: 250), spacing: 24)], spacing: 24) {
                        ForEach(filteredProducts) { product in
                            ProductView(product: product)
                                .frame(width: 180, height: 250)
                        }
                    }
                }
            }

        }
        .onAppear {
            if let safeUser = userService.appUser {
                productService.getProductCategories(user: safeUser)
                productService.getHotProducts(user: safeUser)
            }
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductsView(products: [], categories: [])
    }
}
