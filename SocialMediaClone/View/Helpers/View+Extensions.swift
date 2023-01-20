//
//  View+Extensions.swift
//  SocialMediaClone
//
//  Created by Necati Bozkurt on 20.01.2023.
//

import SwiftUI

// MARK: View extensions for UI Building
extension View {
    // MARK: Closing All Actice Keyboards
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: Disabling with Opacity
    func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.6 : 1)
    }
    
    func hAling (_ alingment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alingment)
    }
    
    func vAling (_ alingment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alingment)
    }
    
    // MARK: Custum border view with padding
    func border(_ width: CGFloat, _ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
    
    // MARK: Custum fill view with padding
    func fillView(_ color: Color) -> some View {
        self
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .fill(color)
            }
    }
}
