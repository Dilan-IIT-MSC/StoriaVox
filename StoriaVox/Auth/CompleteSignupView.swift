//
//  CompleteSignupView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-02.
//

import SwiftUI

struct CompleteSignupView: View {
    @EnvironmentObject var appSettings: AppSettings
    @State private var birthdate: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date()) ?? Date()
    @State private var chipViewHeight: CGFloat = .zero
    @State private var showDatePicker: Bool = false
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Complete Your Profile")
                                .font(.system(size: 28, weight: .medium))
                                .fontDesign(.rounded)
                            
                            Text("Help us personalize your storytelling experience")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 16)
                        .padding(.bottom, 16)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("When's your birthday?")
                                .font(.system(size: 18, weight: .medium))
                            
                            Button {
                                withAnimation {
                                    showDatePicker.toggle()
                                }
                            } label: {
                                HStack {
                                    Text(dateFormatter.string(from: birthdate))
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "calendar")
                                        .foregroundColor(.accentColor)
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.accent.opacity(0.1))
                                        .stroke(Color.accentColor, lineWidth: 1)
                                )
                            }
                            
                            if showDatePicker {
                                DatePicker("", selection: $birthdate,
                                           in: ...Date(),
                                           displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.background)
                                        .shadow(color: .gray.opacity(0.2), radius: 5)
                                )
                                .transition(.scale)
                            }
                        }
                        
                        Divider()
                            .background(.border)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 4) {
                                Text("What stories interest you?")
                                    .font(.system(size: 18, weight: .medium))
                                
                                Text("(Choose up to 5)")
                                    .font(.system(size: 14, weight: .light))
                                    .italic()
                                
                                Spacer()
                            }
                            
                            Text("We'll use these to customize your story feed")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                            
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
                
                VStack {
                    Button {

                    } label: {
                        HStack {
                            Spacer()
                            
                            Text("Get Started")
                                .font(.system(size: 18, weight: .medium))
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .background(Color.accentColor)
                        .cornerRadius(16)
                        .contentShape(Rectangle())
                    }
                    .padding(.top, 16)
                    
                    Button {

                    } label: {
                        Text("I'll do this later")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    CompleteSignupView().environmentObject(AppSettings())
}
