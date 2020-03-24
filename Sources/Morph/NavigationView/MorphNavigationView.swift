//
//  MorphNavigationView.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

public struct MorphNavigationView<Content: View>: View {
    
    private let content: Content
    
    @Environment(\.navigationViewStyle) private var style
    
    @State private var title: Text = Text("")
    @State private var previousTitle: [Text] = []
    @State private var navigationBarButtonItems: NavigationBarButtomItems = NavigationBarButtomItems()
    @State private var navigationBarBackground: AnyView = AnyView(EmptyView())
    @State private var navigationBarTintColor: Color = Color(.tertiarySystemBackground)
    @ObservedObject private var navigationStack = NavigationStack()
    
    private let transitions: (push: AnyTransition, pop: AnyTransition)
    
    public init(
        pushTransition: AnyTransition = AnyTransition.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)),
        popTransition: AnyTransition = AnyTransition.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)),
        @ViewBuilder content: () -> Content
    ) {
        self.transitions = (pushTransition, popTransition)
        self.content = content()
    }
    
    public var body: some View {
        
        let showRoot = self.navigationStack.currentPage == nil
        let navigationType = self.navigationStack.navigationType
        
        return
            Group {
                if showRoot {
                    self.style?.makeBody(configuration:
                        self.configuration(for:
                            self.content
                                .id("root")
                                .transition(navigationType == .push ? transitions.push : transitions.pop)
                        )
                    )
                    
                } else {
                    self.style?.makeBody(configuration:
                        self.configuration(for:
                            self.navigationStack.currentPage!.body
                                .id(self.navigationStack.currentPage!.id)
                                .transition(navigationType == .push ? transitions.push : transitions.pop)
                        )
                    )
                }
            }
            .environment(\.navigationStack, self.navigationStack)
    }
    
    private func configuration<V: View>(for view: V) -> NavigationViewStyleConfiguration {
        let content = view
            .onPreferenceChange(NavigationBarTitlePreferences.self) {
                if self.navigationStack.navigationType == .push {
                    self.previousTitle.append(self.title)
                } else {
                    if !self.previousTitle.isEmpty {
                        self.previousTitle.removeLast()
                    }
                    
                }
                self.title = $0
            }
            .onPreferenceChange(NavigationBarButtonItemsPreferences.self) { self.navigationBarButtonItems = $0 }
            .onPreferenceChange(NavigationBarBackgroundPreference.self) { self.navigationBarBackground = $0.body }
            .onPreferenceChange(NavigationBarTintColorPreference.self) { color in
                if let color = color {
                    self.navigationBarTintColor = color
                }
        }
            
        
        let configuration = NavigationViewStyleConfiguration(content: .init(content),
                                                             navigationBarItems: self.navigationBarButtonItems,
                                                             navigationBarTitle: self.title,
                                                             previousNavigationBarTitle: self.previousTitle.last,
                                                             navigationBarBackground: .init(self.navigationBarBackground),
                                                             navigationBarTintColor: self.navigationBarTintColor)
        
        return configuration
    }
    
}
