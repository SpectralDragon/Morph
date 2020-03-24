//
//  NavigationViewPreferences.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

struct NavigationBarTitlePreferences: PreferenceKey {
    typealias Value = Text

    static var defaultValue: Text { Text("") }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct NavigationBarButtonItemsPreferences: PreferenceKey {
    typealias Value = NavigationBarButtomItems

    static var defaultValue: NavigationBarButtomItems { NavigationBarButtomItems() }

    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

struct NavigationBarBackgroundPreference: PreferenceKey {
    
    struct BackgroundContent: View, Equatable {
        static func == (lhs: NavigationBarBackgroundPreference.BackgroundContent, rhs: NavigationBarBackgroundPreference.BackgroundContent) -> Bool {
            lhs.id == rhs.id
        }
        
        init<V: View>(_ view: V) {
            self.id = UUID().uuidString
            self.body = AnyView(view.id(self.id))
        }
        
        private let id: String
        
        var body: AnyView
    }
    
    typealias Value = BackgroundContent

    static var defaultValue: BackgroundContent { BackgroundContent(EmptyView()) }
    
    static func reduce(value: inout BackgroundContent, nextValue: () -> BackgroundContent) {
        value = nextValue()
    }
}

struct NavigationBarTintColorPreference: PreferenceKey {
    typealias Value = Color?

    static var defaultValue: Color? { return nil }
    
    static func reduce(value: inout Color?, nextValue: () -> Color?) {
        value = nextValue()
    }
}
