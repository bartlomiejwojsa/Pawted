//
//  MainView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var userService: UserService
    
    var body: some View {
        TabView {
            HotView()
                .tabItem {
                    Image(systemName: "flame.fill")
                    Text("Hot")
                }
            ProductsView(products: productService.hotProducts, categories: productService.productCategories)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Products")
                }
            AddProductView()
                .tabItem {
                    Image(systemName: "plus.app.fill")
                    Text("Add")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("Account")
                }
            //
//                CartView()
//                    .tabItem {
//                        Image(systemName: "cart.badge.plus")
//                        Text("Cart")
//                    }
//
        }
        .background(Color.red)
        .onAppear {
            if let safeUser = userService.appUser {
                productService.getProductCategories(user: safeUser)
                productService.getHotProducts(user: safeUser)
            }
        }
        .onChange(of: productService.lastErrorCode) { newValue in
            if newValue == .unauthorized {
                userService.logout()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
