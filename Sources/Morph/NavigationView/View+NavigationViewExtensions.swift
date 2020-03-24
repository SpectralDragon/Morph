//
//  View+NavigationViewExtensions.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

public extension View {
    func navigationBarTitle(text: Text) -> some View {
        self.preference(key: NavigationBarTitlePreferences.self, value: text)
        .navigationBarTitle(text, displayMode: .inline)
    }
    
    func navigationBarTitle(_ string: String) -> some View {
        self.preference(key: NavigationBarTitlePreferences.self, value: Text(string))
        .navigationBarTitle(Text(string), displayMode: .inline)
    }
    
    func navigationBarBackground<V: View>(_ view: V) -> some View {
        self.preference(key: NavigationBarBackgroundPreference.self, value: .init(view))
    }
    
    func navigationBarTintColor(_ color: Color) -> some View {
        self.preference(key: NavigationBarTintColorPreference.self, value: color)
    }
}

public extension View {

    /// Configures the navigation bar items for this view.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a `NavigationView`.
    ///
    /// - Parameters:
    ///     - leading: A view that appears on the leading edge of the title.
    ///     - trailing: A view that appears on the trailing edge of the title.
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    func navigationBarButtonItems<L, T>(leading: L, trailing: T) -> some View where L : View, T : View {
        self.preference(key: NavigationBarButtonItemsPreferences.self, value: NavigationBarButtomItems(leading: leading, trailing: trailing))
        .navigationBarItems(leading: leading, trailing: trailing)
    }


    /// Configures the navigation bar items for this view.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a `NavigationView`.
    ///
    /// - Parameters:
    ///     - leading: A view that appears on the leading edge of the title.
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    func navigationBarButtonItems<L>(leading: L) -> some View where L : View {
        self.preference(key: NavigationBarButtonItemsPreferences.self, value: NavigationBarButtomItems(leading: leading, trailing: EmptyView()))
        .navigationBarItems(leading: leading)
    }


    /// Configures the navigation bar items for this view.
    ///
    /// This modifier only takes effect when this view is inside of and visible
    /// within a `NavigationView`.
    ///
    /// - Parameters:
    ///     - trailing: A view shown on the trailing edge of the title.
    @available(OSX, unavailable)
    @available(watchOS, unavailable)
    func navigationBarButtonItems<T>(trailing: T) -> some View where T : View {
        self.preference(key: NavigationBarButtonItemsPreferences.self, value: NavigationBarButtomItems(leading: EmptyView(), trailing: trailing))
        .navigationBarItems(trailing: trailing)
    }
}
