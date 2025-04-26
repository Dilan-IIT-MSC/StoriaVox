//
//  ProfileHeaderView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-25.
//

import Foundation
import PhotosUI
import SwiftUI

extension ProfileView {
    @ViewBuilder
    func header() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.accentColor.opacity(0.8), Color.accentColor.opacity(0.5)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 200)
            
            HStack(spacing: 20) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    profileImage?
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                            .background(Color.white.clipShape(Circle()))
                            .offset(x: 5, y: 5)
                    }
                }
                .onChange(of: selectedItem) { _, newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            uiProfileImage = uiImage
                            profileImage = Image(uiImage: uiImage)
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(userName)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Member since \(memberSince)")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.8))
                    
                    if isEditingBio {
                        TextField("Edit Bio", text: $editedBio)
                            .font(.caption)
                            .padding(4)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(6)
                        
                        HStack {
                            Button("Save") {
                                userBio = editedBio
                                isEditingBio = false
                            }
                            .foregroundColor(.green)
                            
                            Button("Cancel") {
                                isEditingBio = false
                            }
                            .foregroundColor(.red)
                        }
                        .font(.caption)
                    } else {
                        HStack {
                            Text(userBio)
                                .font(.caption)
                                .foregroundColor(Color.white.opacity(0.9))
                                .lineLimit(3)
                                .fixedSize(horizontal: false, vertical: true)
                            
                            Button(action: {
                                editedBio = userBio
                                isEditingBio = true
                            }) {
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .padding(.trailing, 8)
            }
            .padding(.horizontal, 20)
        }
        .padding(.top, 16)
    }
}
