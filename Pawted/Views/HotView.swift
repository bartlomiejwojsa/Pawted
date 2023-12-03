//
//  HotView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI



struct HotView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var userService: UserService
    @State var productsReady: Bool = false
    @State var productCategoriesReady: Bool = false

    var body: some View {
        ScrollView {
            if (productsReady && productCategoriesReady) {
                let productCats = productService.productCategories.sorted(by: { prodCat1, prodCat2 in
                    prodCat1.id < prodCat2.id
                })
                ForEach(productCats, id: \.id) { category in
                    let carouselProducts = productService.hotProducts.filter { $0.category?.tag ?? "" == category.tag }
                    ProductsCarousel(
                        products: carouselProducts,
                        title: category.name
                    )
                    .id(category.id)
                }
            }

        }
        .scrollIndicators(.hidden)
        .onAppear {
            if let safeUser = userService.appUser {
                productService.getProductCategories(user: safeUser)
                productService.getHotProducts(user: safeUser)
            }
        }
        .onChange(of: productService.hotProducts) { newValue in
            if !newValue.isEmpty {
                productsReady = true
            }
        }
        .onChange(of: productService.productCategories) { newValue in
            if !newValue.isEmpty {
                productCategoriesReady = true
            }
        }
    }
}

//struct HotView_Previews: PreviewProvider {
//    static var previews: some View {
//        HotView()
//            .environmentObject(ProductService())
//            .environmentObject(UserService())
//    }
//}
