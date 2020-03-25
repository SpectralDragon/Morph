//
//  NavigationStack.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

// Main idea using stack representation was taken from https://github.com/biobeats/swiftui-navigation-stack/blob/master/Sources/NavigationStack/NavigationStack.swift
// Thanks!

public class NavigationStack: ObservableObject {
    
    public enum NavigationType {
        case push
        case pop
    }

    public enum PopDestination {
        case previous
        case root
        case view(withId: String)
    }

    
    public struct Page: View, Equatable, Identifiable {
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
        
        public let id: String
        public var body: AnyView
    }
    
    private(set) var navigationType = NavigationType.push
    
    private var stack = Stack() {
        didSet {
            currentPage = self.stack.peek()
        }
    }
    
    public var canPopUp: Bool {
        return !self.stack.pages.isEmpty
    }
    
    @Published public var currentPage: Page?
    
    public func push<Element: View>(_ element: Element, withId identifier: String? = nil) {
        withAnimation {
            self.navigationType = .push
            self.stack.push(Page(id: identifier ?? UUID().uuidString, body: AnyView(element)))
        }
    }

    public func pop(to: PopDestination = .previous) {
        withAnimation {
            self.navigationType = .pop
            switch to {
            case .root:
                self.stack.popToRoot()
            case .view(let viewId):
                self.stack.pop(to: viewId)
            default:
                self.stack.popToPrevious()
            }
        }
    }
    
    struct Stack {
        private(set) var pages: [Page] = []
        
        func peek() -> Page? {
            return self.pages.last
        }
        
        mutating func push(_ element: Page) {
            
            if self.pages.contains(element) {
                fatalError("Pushed element already exists on stack by id: \(element.id)")
            }
            
            self.pages.append(element)
        }
        
        mutating func popToPrevious() {
            _ = self.pages.popLast()
        }
        
        mutating func pop(to identifier: Page.ID) {
            guard let index = self.pages.firstIndex(where: { $0.id == identifier }) else {
                fatalError("View by id \(identifier) doesn't exists on stack")
            }
            
            self.pages.removeLast(self.pages.count - (index + 1))
        }
        
        mutating func popToRoot() {
            _ = pages.removeAll()
        }
    }
    
}

public struct NavigationStackKey: EnvironmentKey {
    public static var defaultValue: NavigationStack?
}

public extension EnvironmentValues {
    var navigationStack: NavigationStack? {
        get { self[NavigationStackKey.self] }
        set { self[NavigationStackKey.self] = newValue }
    }
}
