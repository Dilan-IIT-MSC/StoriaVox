//
//  FilterDropdownView.swift
//  StoriaVox
//
//  Created by Dilan Anuruddha on 2025-04-16.
//

import Foundation
import SwiftUI

struct FilterDropdownView<T: SelectableItem>: View {
    var title: String
    var placeholder: String
    @Binding var value: T?
    var onTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 0) {
                Text(title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.secondValue)
                    .padding(.vertical, 5)
                
                Spacer()
            }
            
            HStack(alignment: .center, spacing: 0) {
                if let val = value, !val.displayTitle.isEmpty {
                    Button {
                        onTapped()
                    } label: {
                        HStack(alignment: .center, spacing: 0) {
                            Text(val.displayTitle)
                                .font(.system(size: 15))
                                .kerning(0.06)
                                .lineLimit(1)
                                .foregroundStyle(Color.title)
                            
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    
                    Button {
                        value = nil
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                            .fontDesign(.rounded)
                            .foregroundStyle(Color.title)
                            .frame(width: 20, height: 20)
                    }
                } else {
                    Button {
                        onTapped()
                    } label: {
                        HStack(alignment: .center, spacing: 0) {
                            Text(placeholder)
                                .font(.system(size: 15))
                                .fontDesign(.rounded)
                                .kerning(0.06)
                                .foregroundStyle(Color.value)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14))
                                .fontDesign(.rounded)
                                .foregroundStyle(Color.value)
                                .frame(width: 20, height: 20)
                        }
                        .contentShape(Rectangle())
                    }
                }
            }
            .modifier(Dropdownmodifier(showError: .constant(false)))
        }
        .padding(.bottom, 20)
    }
}
