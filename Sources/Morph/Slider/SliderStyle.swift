//
//  SliderStyle.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

/// Defines the implementation of all `Slider` instances within a view
/// hierarchy.
///
/// To configure the current `SliderStyle` for a view hiearchy, use the
/// `.sliderStyle()` modifier.
public protocol SliderStyle {
    
    associatedtype Body: View
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = SliderStyleConfiguration
    
}

// MARK: - Environment Key
extension EnvironmentValues {
    var sliderStyle: AnySliderStyle {
        get {
            return self[SliderStyleKey.self]
        }
        set {
            self[SliderStyleKey.self] = newValue
        }
    }
}

extension SliderStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

public struct SliderStyleKey: EnvironmentKey {
    public static let defaultValue: AnySliderStyle = AnySliderStyle(DefaultSliderStyle())
}

public struct AnySliderStyle: SliderStyle {
    private let _makeBody: (SliderStyle.Configuration) -> AnyView
    
    init<ST: SliderStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }
    
    public func makeBody(configuration: SliderStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

public extension View {
    func sliderStyle<S: SliderStyle>(_ style: S) -> some View {
        self.environment(\.sliderStyle, AnySliderStyle(style))
    }
}

public struct SliderStyleConfiguration {
    
    /// A type-erased label of a `Toggle`.
    public struct Label : View {
        
        init<V: View>(body: V) {
            self.body = AnyView(body)
        }
        
        public var body: AnyView
        
        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required `body` property.
        public typealias Body = AnyView
    }
    
    public struct ValueLabel : View {
        
        init<V: View>(body: V) {
            self.body = AnyView(body)
        }
        
        
        public var body: AnyView
        
        /// The type of view representing the body of this view.
        ///
        /// When you create a custom view, Swift infers this type from your
        /// implementation of the required `body` property.
        public typealias Body = AnyView
    }
    
    /// A view that describes the effect of slider `value`.
    public let label: SliderStyleConfiguration.Label
    
    public var value: Float {
        get { projectedValue.wrappedValue }
        nonmutating set { projectedValue.wrappedValue = newValue }
    }
    
    public let projectedValue: Binding<Float>
    
    public let minimumValueLabel: SliderStyleConfiguration.ValueLabel
    public let maximumValueLabel: SliderStyleConfiguration.ValueLabel
    
    public let bounds: ClosedRange<Float>
    
    public let step: Float
    
    public let onEditingChanged: (Bool) -> Void
}



struct DefaultSliderStyle: SliderStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        SwiftUI.Slider(value: configuration.projectedValue,
                       in: configuration.bounds,
                       step: configuration.step,
                       onEditingChanged: configuration.onEditingChanged,
                       minimumValueLabel: configuration.minimumValueLabel,
                       maximumValueLabel: configuration.maximumValueLabel,
                       label: { configuration.label })
    }
}
