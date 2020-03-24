//
//  File.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

struct NavigationViewStyleKey: EnvironmentKey {
    static var defaultValue: AnyNavigationViewStyle?
}

public protocol NavigationViewStyle {
    
    associatedtype Body: View
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = NavigationViewStyleConfiguration
}

extension EnvironmentValues {
    var navigationViewStyle: AnyNavigationViewStyle? {
        get { self[NavigationViewStyleKey.self] }
        set { self[NavigationViewStyleKey.self] = newValue }
    }
}

// MARK: - Environment Key

extension NavigationViewStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

public struct AnyNavigationViewStyle: NavigationViewStyle {
    private let _makeBody: (NavigationViewStyle.Configuration) -> AnyView
    
    public init<ST: NavigationViewStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }
    
    public func makeBody(configuration: NavigationViewStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

public struct NavigationViewStyleConfiguration {
    public struct Content: View {
        init<V: View>(_ view: V) {
            self.body = AnyView(view)
        }
        
        public var body: AnyView
    }
    
    public struct BackgroundContent: View {
        
        init<V: View>(_ view: V) {
            self.body = AnyView(view)
        }
        
        public var body: AnyView
    }
    
    public let content: Content
    public let navigationBarItems: NavigationBarButtomItems
    public let navigationBarTitle: Text
    public let previousNavigationBarTitle: Text?
    public let navigationBarBackground: BackgroundContent
    public let navigationBarTintColor: Color
}

public struct NavigationBarButtomItems: Equatable {
    public struct Items: View, Equatable {
        
        public static func == (lhs: NavigationBarButtomItems.Items, rhs: NavigationBarButtomItems.Items) -> Bool {
            lhs.id == rhs.id
        }
        
        private let id: String
        
        init<T: View>(_ view: T) {
            self.id = UUID().uuidString
            self.body = AnyView(view.id(self.id))
        }
        
        public var body: AnyView
    }
    
    init<L: View, T: View>(leading: L, trailing: T) {
        self.leading = .init(leading)
        self.trailing = .init(trailing)
    }
    
    init() {
        self.leading = .init(EmptyView())
        self.trailing = .init(EmptyView())
    }
    
    public let leading: Items
    public let trailing: Items
}
