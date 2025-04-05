//
//  AddMetaDataView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-03-31.
//

import SwiftUI

struct AddMetaDataView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State var chipViewHeight: CGFloat = .zero
    @State var storyTitle: String = ""
    @State var storyTitleError: String? = nil
    
    var body: some View {
        ZStack {
            Color.background
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack(spacing: 4) {
                            Text("Complete Your Story")
                                .font(.system(size: 20, weight: .medium))
                            
                            Spacer()
                        }
                        .padding(.bottom, 24)
                        
                        
                        HStack(spacing: 4) {
                            Text("Give your story a title")
                                .font(.system(size: 16, weight: .medium))
                            
                            Spacer()
                        }
                        
                        CustomTextField(placeholder: "Title", text: $storyTitle, errorMessage: $storyTitleError)
                        
                        Divider()
                            .background(.border)
                            .padding(.top, 24)
                        
                        // MARK: Category Selection
                        Section {
                            HStack(spacing: 4) {
                                Text("What's your story about?")
                                    .font(.system(size: 16, weight: .medium))
                                
                                Text("(Choose up to 3)")
                                    .font(.system(size: 14, weight: .light))
                                    .italic()
                                
                                Spacer()
                            }
                            
                            VStack {
                                var width = CGFloat.zero
                                var height = CGFloat.zero
                                GeometryReader { geo in
                                    ZStack(alignment: .topLeading, content: {
                                        ForEach(0..<appSettings.storyCategories.count, id: \.self) { index in
                                            CategoryChipView(category: appSettings.storyCategories[index])
                                                .padding(.all, 5)
                                                .alignmentGuide(.leading) { dimension in
                                                    if (abs(width - dimension.width) > geo.size.width) {
                                                        width = 0
                                                        height -= dimension.height
                                                    }
                                                    let result = width
                                                    if index == appSettings.storyCategories.count - 1 {
                                                        width = 0
                                                    } else {
                                                        width -= dimension.width
                                                    }
                                                    return result
                                                }
                                                .alignmentGuide(.top) { dimension in
                                                    let result = height
                                                    if index == appSettings.storyCategories.count - 1 {
                                                        height = 0
                                                    }
                                                    return result
                                                }
                                        }
                                    })
                                    .padding(.top, 12)
                                    .readSize { size in
                                        chipViewHeight = size.height
                                    }
                                }
                            }
                            .frame(height: chipViewHeight + 12)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Divider()
                    .background(.border)
                
                HStack {
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Save")
                            .foregroundStyle(.accent)
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(width: 150, alignment: .center)
                            .overlay {
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.accentColor, lineWidth: 1)
                            }
                    }

                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text("Publish")
                            .foregroundStyle(.white)
                            .font(.system(size: 16))
                            .fontDesign(.rounded)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .frame(width: 150, alignment: .center)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                            .contentShape(Rectangle())
                    }
                    
                    Spacer()
                }
                .padding(.vertical, 12)
            }
        }
    }
}

#Preview {
    AddMetaDataView().environmentObject(AppSettings())
}
