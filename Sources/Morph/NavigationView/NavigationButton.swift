//
//  NavigationButton.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

/// A view that controls a navigation presentation.
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct NavigationButton<Label: View, Destination: View>: View {
    
    private let label: Label
    private let destination: Destination
    private var isDetailLink: Bool = true
    
    @Environment(\.navigationStack) var stack: NavigationStack?
    
    @Binding private var isInternalActive: Bool
    
    private let navigationLink: NavigationLink<Label, Destination>

    /// Creates an instance that presents `destination`.
    public init(destination: Destination, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
        let isInternalActive = State(wrappedValue: false)
        self._isInternalActive = isInternalActive.projectedValue
        self.navigationLink = NavigationLink(destination: destination, label: label)
    }

    /// Creates an instance that presents `destination` when active.
    public init(destination: Destination, isActive: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.label = label()
        self._isInternalActive = isActive
        self.navigationLink = NavigationLink(destination: destination, isActive: isActive, label: label)
    }

    /// Creates an instance that presents `destination` when `selection` is set
    /// to `tag`.
    public init<V>(destination: Destination, tag: V, selection: Binding<V?>, @ViewBuilder label: () -> Label) where V : Hashable {
        self.destination = destination
        self.label = label()
        self._isInternalActive = Binding(get: { selection.wrappedValue == tag },
                                         set: { if $0 == false { selection.wrappedValue = nil }})
        self.navigationLink = NavigationLink(destination: destination, tag: tag, selection: selection, label: label)
    }

    /// Declares the content and behavior of this view.
    public var body: some View {
        
        if self.isInternalActive && self.stack != nil {
            DispatchQueue.main.async {
                self.isInternalActive = false
                self.push()
            }
        }
        
        return
            Group {
                if self.stack == nil {
                    self.navigationLink
                        .isDetailLink(self.isDetailLink)
                } else {
                    Button(action: self.push, label: { self.label })
                }
        }
    }
    
    private func push() {
        stack?.push(self.destination, withId: UUID().uuidString)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension NavigationButton where Label == Text {

    /// Creates an instance that presents `destination`, with a `Text` label
    /// generated from a title string.
    public init(_ titleKey: LocalizedStringKey, destination: Destination) {
        self.label = Text(titleKey)
        self.destination = destination
        let isInternalActive = State(wrappedValue: false)
        self._isInternalActive = isInternalActive.projectedValue
        self.navigationLink = NavigationLink(titleKey, destination: destination)
    }

    /// Creates an instance that presents `destination`, with a `Text` label
    /// generated from a title string.
    public init<S>(_ title: S, destination: Destination) where S : StringProtocol {
        self.label = Text(title)
        self.destination = destination
        let isInternalActive = State(wrappedValue: false)
        self._isInternalActive = isInternalActive.projectedValue
        self.navigationLink = NavigationLink(title, destination: destination)
    }

    /// Creates an instance that presents `destination` when active, with a
    /// `Text` label generated from a title string.
    public init(_ titleKey: LocalizedStringKey, destination: Destination, isActive: Binding<Bool>) {
        self.label = Text(titleKey)
        self.destination = destination
        self._isInternalActive = isActive
        self.navigationLink = NavigationLink(titleKey, destination: destination, isActive: isActive)
    }

    /// Creates an instance that presents `destination` when active, with a
    /// `Text` label generated from a title string.
    public init<S>(_ title: S, destination: Destination, isActive: Binding<Bool>) where S : StringProtocol {
        self.label = Text(title)
        self.destination = destination
        self._isInternalActive = isActive
        self.navigationLink = NavigationLink(title, destination: destination, isActive: isActive)
    }

    /// Creates an instance that presents `destination` when `selection` is set
    /// to `tag`, with a `Text` label generated from a title string.
    public init<V>(_ titleKey: LocalizedStringKey, destination: Destination, tag: V, selection: Binding<V?>) where V : Hashable {
        self.label = Text(titleKey)
        self.destination = destination
        self._isInternalActive = Binding(get: { selection.wrappedValue == tag },
                                         set: { if $0 == false { selection.wrappedValue = nil }})
        self.navigationLink = NavigationLink(titleKey, destination: destination, tag: tag, selection: selection)
    }

    /// Creates an instance that presents `destination` when `selection` is set
    /// to `tag`, with a `Text` label generated from a title string.
    public init<S, V>(_ title: S, destination: Destination, tag: V, selection: Binding<V?>) where S : StringProtocol, V : Hashable {
        self.label = Text(title)
        self.destination = destination
        self._isInternalActive = Binding(get: { selection.wrappedValue == tag },
                                         set: { if $0 == false { selection.wrappedValue = nil }})
        self.navigationLink = NavigationLink(title, destination: destination, tag: tag, selection: selection)
    }
}

@available(iOS 13.0, *)
@available(OSX, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension NavigationButton {

    /// Sets whether or not the `NavigationLink` should present its destination
    /// as the "detail" component of the containing `NavigationView`.
    ///
    /// If not set, defaults to `true`.
    @available(OSX, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public func isDetailLink(_ isDetailLink: Bool) -> some View {
        var copy = self
        copy.isDetailLink = isDetailLink
        return copy
    }
    
}
