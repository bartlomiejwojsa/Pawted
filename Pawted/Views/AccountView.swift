//
//  AccountView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 02/05/2023.
//

import SwiftUI

struct AccountView: View {
    @EnvironmentObject var userService: UserService
    @State private var hasClickedNotImplemented = false

    var body: some View {
        VStack {
            if let safeImage = userService.appUser?.imageUrl, safeImage != "" {
                URLImageView(url: safeImage)
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
            }

            Text("Hello ! \(userService.appUser?.nick ?? "")")
            List {
                Button("Orders") {
                    // Navigate to OrdersView
                    hasClickedNotImplemented.toggle()

                }
                Button("Logout") {
                    userService.logout()
                }
            }
        }
        .presentStandardBottomToast(isPresented: $hasClickedNotImplemented) {
            ToastManager.getOperationToast(
                message: "Functionality not yet implemented!", iconSystemName: "exclamationmark.circle"
            )
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(UserService())
    }
}
