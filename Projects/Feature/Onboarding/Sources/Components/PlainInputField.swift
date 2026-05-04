//
//  PlainInputField.swift
//  FeatureOnboarding
//
//  Created by 유지완 on 4/29/26.
//  Copyright © 2026 ttokdog. All rights reserved.
//

import SwiftUI

struct PlainInputField: View {
    
    @Binding var text: String
    
    let placeholder: String
    var isError: Bool = false
    var onClear: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $text)
                .foregroundStyle(text.isEmpty ? Color.gray400 : Color.gray900)
                .typography(.body11)
            
            if !text.isEmpty, let onClear {
                Button(action: onClear) {
                    Image.inputErase
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.leading, 16)
        .padding(.trailing, 14)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isError ? Color.error : Color.gray200, lineWidth: 1.2)
        )
    }
}

// MARK: - Preview

#Preview("비어있음") {
    PlainInputField(
        text: .constant(""),
        placeholder: "example@example.com"
    )
    .padding(20)
}

#Preview("입력됨") {
    PlainInputField(
        text: .constant("ttokdog826@gmail.com"),
        placeholder: "example@example.com"
    )
    .padding(20)
}

#Preview("에러") {
    PlainInputField(
        text: .constant("ttokdog826gmail.com"),
        placeholder: "example@example.com",
        isError: true
    )
    .padding(20)
}


