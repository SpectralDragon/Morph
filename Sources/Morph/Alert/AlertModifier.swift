//
//  AlertModifier.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

struct StyleAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let alertContent: Alert
    
    func body(content: _ViewModifier_Content<StyleAlertModifier>) -> some View {
        InternalView(isPresented: $isPresented, alert: alertContent, content: content)
    }
    
    struct InternalView<Content: View>: View {
        
        @Binding var isPresented: Bool
        let alert: Alert
        let content: Content
        
        @Environment(\.alertStyle) var alertStyle
                
        var body: some View {
            let configuration = AlertStyleConfiguration(content: AlertStyleConfiguration.Content(content),
                                                        alert: alert,
                                                        isPresented: $isPresented)
            
            return self.alertStyle.makeBody(configuration: configuration)
        }
    }
    
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension View {
    
    /// Presents an alert.
    ///
    /// - Parameters:
    ///     - item: A `Binding` to an optional source of truth for the `Alert`.
    ///     When representing a non-nil item, the system uses `content` to
    ///     create an alert representation of the item.
    ///
    ///     If the identity changes, the system will dismiss a
    ///     currently-presented alert and replace it by a new alert.
    ///
    ///     - content: A closure returning the `Alert` to present.
    func alertWithStyle<Item>(item: Binding<Item?>, content: (Item) -> Alert) -> some View where Item : Identifiable {
        ZStack {
            if item.wrappedValue != nil {
                self.modifier(StyleAlertModifier(
                    isPresented: Binding(get: { item.wrappedValue != nil }, set: {
                        if $0 == false {
                            item.wrappedValue = nil
                        }
                    }).animation(),
                    alertContent: content(item.wrappedValue!)))
            } else {
                self
            }
        }
    }
    
    
    /// Presents an alert.
    ///
    /// - Parameters:
    ///     - isPresented: A `Binding` to whether the `Alert` should be shown.
    ///     - content: A closure returning the `Alert` to present.
    func alertWithStyle(isPresented: Binding<Bool>, content: () -> Alert) -> some View {
        self.modifier(StyleAlertModifier(isPresented: isPresented.animation(), alertContent: content()))
    }
    
}
