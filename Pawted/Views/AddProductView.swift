//
//  AddProductView.swift
//  Pawted
//
//  Created by Bartłomiej Wojsa on 04/05/2023.
//

import SwiftUI
import UIKit

struct AddProductView: View {
    @EnvironmentObject var productService: ProductService
    @EnvironmentObject var userService: UserService

    @State private var title = ""
    @State private var isTitleValid = false
    @State private var category = ""
    @State private var isCategoryValid = false
    @State private var price = ""
    @State private var isPriceValid = false
    @State private var description = ""
    @State private var isDescriptionValid = false
    @State private var image: UIImage?
    @State private var isImageValid = false
    @State private var isShowingImagePicker = false
    @State private var formErrorMessage: String? = nil
    
    @State private var showNewProductAdded: Bool = false
    @State private var showFormInvalid: Bool = false
    

    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Form {
                        Section(header: Text("Add product").font(.title)) {
                            TextField("Title", text: $title)
                                .border((formErrorMessage != nil && !isTitleValid) ? Color.red : Color.clear)
                            TextField("Price", text: $price)
                                .keyboardType(.decimalPad)
                                .onChange(of: price) { newValue in
                                    price = Utils.parseStringToDecimal(text: newValue, precision: 2) ?? ""
                                }
                                .border((formErrorMessage != nil && !isPriceValid) ? Color.red : Color.clear)
                            TextEditor(text: $description)
                                .frame(height: 150)
                                .border((formErrorMessage != nil && !isDescriptionValid) ? Color.red : Color.clear)
                        }
                        Section(header:
                            Text("Image")
                                .border((formErrorMessage != nil && !isImageValid) ? Color.red : Color.clear)
                        ) {
                            SelectedImageView(image: $image, isShowingImagePicker: $isShowingImagePicker)
                                .frame(height: 250)
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .onAppear {
                        self.category = productService.productCategories.first?.tag ?? ""
                    }
                    .onChange(of: title, perform: { value in
                        isTitleValid = !value.isEmpty // or add your own validation check here
                    })
                    .onChange(of: description, perform: { value in
                        isDescriptionValid = !value.isEmpty // or add your own validation check here
                    })
                    .onChange(of: price, perform: { value in
                        isPriceValid = Double(value) != nil // or add your own validation check here
                    })
                    .onChange(of: category, perform: { value in
                        isCategoryValid = productService.productCategories.map({ category in
                            return category.tag
                        }).contains(value)
                    })
                    .onChange(of: image, perform: { value in
                        isImageValid = (value != nil) // or add your own validation check here
                    })
                    .sheet(isPresented: $isShowingImagePicker) {
                        ImagePicker(selectedImage: $image)
                    }
                    .presentStandardBottomToast(isPresented: $showNewProductAdded) {
                        ToastManager.getOperationToast(
                            message: "New product has been added!")
                    }
                    .presentStandardBottomToast(isPresented: $showFormInvalid) {
                        ToastManager.getOperationToast(
                            message: "Complete empty fields!", iconSystemName: "exclamationmark.circle"
                        )
                    }
                }
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
            Picker("Category", selection: $category) {
                    ForEach(productService.productCategories, id: \.id) { cat in
                        Text(cat.name).tag(cat.tag)
                    }
                }
                .pickerStyle(SegmentedPickerStyle()) // Use SegmentedPickerStyle for a different look
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
                .padding()
                .frame(maxWidth: .infinity)
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                if (!isTitleValid || !isPriceValid || !isDescriptionValid || !isCategoryValid || !isImageValid) {
                    DispatchQueue.main.async {
                        self.formErrorMessage = "Form incomplete"
                        withAnimation {
                            showFormInvalid.toggle()
                        }
                    }
                    return
                }
                guard let image = image else {
                    return
                }
                self.formErrorMessage = nil
                guard let safeUser = userService.appUser else {
                    return
                }
                let product = Product(id: "-1", title: title, description: description, userId: ProductUser(email: safeUser.email, nick: safeUser.nick), price: Double(price), likes: [])
                
                DispatchQueue.main.async {
                    productService.addProduct(product, categoryTag: category, image: image, user: safeUser)
                    withAnimation {
                        showNewProductAdded.toggle()
                    }
                    title = ""
                    description = ""
                    price = ""
                    self.image = nil
                }
            }, label: {
                Text("Add Product")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 80)
                    .padding(.vertical, 15)
                    .background(Color.blue)
                    .cornerRadius(30)
            })
        }
        .padding(.bottom, 30)

    }
}

struct SelectedImageView: View {
    @Binding var image: UIImage?
    @Binding var isShowingImagePicker: Bool

    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width * 4 / 5, height: 250)
                } else {
                    Text("Select image ...")
                        .frame(width: geometry.size.width * 4 / 5, height: 250)
                }
                ImagePickerView(
                    imageSystemName: (image != nil) ? "xmark.circle.fill" : "folder.fill.badge.plus"
                )
                .background(Color.accentColor)
                .onTapGesture {
                    if let _ = image {
                        self.image = nil
                    } else {
                        self.isShowingImagePicker = true
                    }
                }
            }
        }
    }
}

struct ImagePickerView: View {
    let imageSystemName: String
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Button(action: {}) {
                        Image(systemName: imageSystemName)
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }
                .frame(height: geometry.size.height)
                Spacer()
            }
        }
    }
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView().environmentObject(ProductService())
            .environmentObject(UserService())
    }
}

extension Color {
    static let systemBackground: Color = Color(UIColor.systemBackground)
}
