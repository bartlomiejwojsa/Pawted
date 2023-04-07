//
//  HotView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI



struct HotView: View {
//    @State var products: [Product] = []
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var userService: UserService

    var body: some View {
        ScrollView {
            ForEach(productService.productCategories.sorted(by: { prodCat1, prodCat2 in
                prodCat1.id < prodCat2.id
            }), id: \.id) { category in
                ProductsCarousel(
                    products: productService.hotProducts.filter { $0.category?.tag ?? "" == category.tag },
                    title: category.name
                )
            }
        }
        .scrollIndicators(.hidden)
        .onAppear {
            if let safeUser = userService.appUser {
                productService.getProductCategories(user: safeUser)
                productService.getHotProducts(user: safeUser)
            }
        }
    }
}

struct HotView_Previews: PreviewProvider {
    static var previews: some View {
        HotView()
            .environmentObject(ProductService())
            .environmentObject(UserService())
    }
}
