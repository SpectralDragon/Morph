//
//  MorphSlider.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

public typealias Slider = MorphSlider

public struct MorphSlider<Label: View, ValueLabel: View>: View {
    
    @Environment(\.sliderStyle) var style: AnySliderStyle
    
    let configuration: SliderStyleConfiguration
    
    public init<V: BinaryFloatingPoint>(value: Binding<V>,
                in bounds: ClosedRange<V> = 0...1,
                step: V.Stride = 0.01,
                onEditingChanged: @escaping (Bool) -> Void = { _ in },
                minimumValueLabel: ValueLabel,
                maximumValueLabel: ValueLabel,
                @ViewBuilder label: () -> Label) where V.Stride : BinaryFloatingPoint
    {
        
        let sliderLabel = SliderStyleConfiguration.Label(body: label())
        let minimumLabel = SliderStyleConfiguration.ValueLabel(body: minimumValueLabel)
        let maximumLabel = SliderStyleConfiguration.ValueLabel(body: maximumValueLabel)
        
        let projectedValue = Binding<Float>(
            get: { Float(value.wrappedValue) },
            set: { value.wrappedValue = V($0) }
        )
        
        let newBounds = Float(bounds.lowerBound)...Float(bounds.upperBound)
        
        self.configuration = SliderStyleConfiguration(label: sliderLabel,
                                                      projectedValue: projectedValue,
                                                      minimumValueLabel: minimumLabel,
                                                      maximumValueLabel: maximumLabel,
                                                      bounds: newBounds,
                                                      step: Float(step),
                                                      onEditingChanged: onEditingChanged)
    }
    
    public var body: some View {
        return style.makeBody(configuration: self.configuration)
    }
}

extension MorphSlider where ValueLabel == EmptyView {
    
    /// Creates an instance that selects a value from within a range.
    ///
    /// - Parameters:
    ///     - value: The selected value within `bounds`.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - onEditingChanged: A callback for when editing begins and ends.
    ///     - label: A `View` that describes the purpose of the instance.
    ///
    /// The `value` of the created instance will be equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// `onEditingChanged` will be called when editing begins and ends. For
    /// example, on iOS, a `Slider` is considered to be actively editing while
    /// the user is touching the knob and sliding it around the track.
    @available(tvOS, unavailable)
    public init<V: BinaryFloatingPoint>(value: Binding<V>, in bounds: ClosedRange<V> = 0...1, onEditingChanged: @escaping (Bool) -> Void = { _ in }, @ViewBuilder label: () -> Label) where V.Stride : BinaryFloatingPoint {
        self = MorphSlider(value: value,
                        in: bounds,
                        step: 0.01,
                        onEditingChanged: onEditingChanged,
                        minimumValueLabel: EmptyView(),
                        maximumValueLabel: EmptyView(),
                        label: label)
    }
    
    /// Creates an instance that selects a value from within a range.
    ///
    /// - Parameters:
    ///     - value: The selected value within `bounds`.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - step: The distance between each valid value.
    ///     - onEditingChanged: A callback for when editing begins and ends.
    ///     - label: A `View` that describes the purpose of the instance.
    ///
    /// The `value` of the created instance will be equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// `onEditingChanged` will be called when editing begins and ends. For
    /// example, on iOS, a `Slider` is considered to be actively editing while
    /// the user is touching the knob and sliding it around the track.
    @available(tvOS, unavailable)
    public init<V: BinaryFloatingPoint>(value: Binding<V>,
                in bounds: ClosedRange<V>,
                step: V.Stride = 1,
                onEditingChanged: @escaping (Bool) -> Void = { _ in },
                @ViewBuilder label: () -> Label
    ) where V.Stride : BinaryFloatingPoint {
        self = MorphSlider(value: value,
                        in: bounds,
                        step: step,
                        onEditingChanged: onEditingChanged,
                        minimumValueLabel: EmptyView(),
                        maximumValueLabel: EmptyView(),
                        label: label)
    }
}

@available(iOS 13.0, OSX 10.15, watchOS 6.0, *)
@available(tvOS, unavailable)
extension MorphSlider where Label == EmptyView, ValueLabel == EmptyView {
    
    /// Creates an instance that selects a value from within a range.
    ///
    /// - Parameters:
    ///     - value: The selected value within `bounds`.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance will be equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// `onEditingChanged` will be called when editing begins and ends. For
    /// example, on iOS, a `Slider` is considered to be actively editing while
    /// the user is touching the knob and sliding it around the track.
    @available(tvOS, unavailable)
    public init<V: BinaryFloatingPoint>(value: Binding<V>,
                in bounds: ClosedRange<V> = 0...1,
                onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V.Stride : BinaryFloatingPoint {
        self = MorphSlider(value: value,
                        in: bounds,
                        step: 0.01,
                        onEditingChanged: onEditingChanged,
                        minimumValueLabel: EmptyView(),
                        maximumValueLabel: EmptyView(),
                        label: { EmptyView() })
    }
    
    /// Creates an instance that selects a value from within a range.
    ///
    /// - Parameters:
    ///     - value: The selected value within `bounds`.
    ///     - bounds: The range of the valid values. Defaults to `0...1`.
    ///     - step: The distance between each valid value.
    ///     - onEditingChanged: A callback for when editing begins and ends.
    ///
    /// The `value` of the created instance will be equal to the position of
    /// the given value within `bounds`, mapped into `0...1`.
    ///
    /// `onEditingChanged` will be called when editing begins and ends. For
    /// example, on iOS, a `Slider` is considered to be actively editing while
    /// the user is touching the knob and sliding it around the track.
    @available(tvOS, unavailable)
    public init<V: BinaryFloatingPoint>(value: Binding<V>,
                in bounds: ClosedRange<V>,
                step: V.Stride = 1,
                onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where V.Stride : BinaryFloatingPoint {
        self = MorphSlider(value: value,
                        in: bounds,
                        step: step,
                        onEditingChanged: onEditingChanged,
                        minimumValueLabel: EmptyView(),
                        maximumValueLabel: EmptyView(),
                        label: { EmptyView() })
    }
}
