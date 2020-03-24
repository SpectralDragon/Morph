//
//  ActionSheetModifier.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

struct StyleActionSheetModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let actionSheet: ActionSheet
    
    func body(content: _ViewModifier_Content<StyleActionSheetModifier>) -> some View {
        InternalView(isPresented: $isPresented, actionSheet: actionSheet, content: content)
    }
    
    struct InternalView<Content: View>: View {
        
        @Binding var isPresented: Bool
        let actionSheet: ActionSheet
        let content: Content
        
        @Environment(\.actionSheetStyle) var actionSheetStyle
        
        
        var body: some View {
            let configuration = ActionSheetStyleConfiguration(content: .init(content),
                                                              actionSheet: actionSheet,
                                                              isPresented: $isPresented)
            
            return self.actionSheetStyle.makeBody(configuration: configuration)
        }
    }
    
}

public extension View {
    
    /// Presents an action sheet.
    ///
    /// - Parameters:
    ///     - item: A `Binding` to an optional source of truth for the action
    ///     sheet. When representing a non-nil item, the system uses
    ///     `content` to create an action sheet representation of the item.
    ///
    ///     If the identity changes, the system will dismiss a
    ///     currently-presented action sheet and replace it by a new one.
    ///
    ///     - content: A closure returning the `ActionSheet` to present.
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    @available(OSX, unavailable)
    func actionSheetWithStyle<T>(item: Binding<T?>, content: (T) -> ActionSheet) -> some View where T : Identifiable {
        ZStack {
            if item.wrappedValue != nil {
                self.modifier(StyleActionSheetModifier(
                    isPresented: Binding(get: { item.wrappedValue != nil }, set: {
                        if $0 == false {
                            item.wrappedValue = nil
                        }
                    }).animation(),
                    actionSheet: content(item.wrappedValue!)))
            } else {
                self
            }
        }
    }
    
    
    /// Presents an action sheet.
    ///
    /// - Parameters:
    ///     - isPresented: A `Binding` to whether the action sheet should be
    ///     shown.
    ///     - content: A closure returning the `ActionSheet` to present.
    @available(iOS 13.0, tvOS 13.0, watchOS 6.0, *)
    @available(OSX, unavailable)
    func actionSheetWithStyle(isPresented: Binding<Bool>, content: () -> ActionSheet) -> some View {
        self.modifier(StyleActionSheetModifier(isPresented: isPresented.animation(), actionSheet: content()))
    }
    
}
