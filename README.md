# Morph

A missed styles support for your SwiftUI views. 

## Features

- [x] NavigationView
- [x] SliderStyle
- [x] AlertStyle
- [x] ActionSheetStyle
- [ ] Full Navigation View methods supports
- [ ] List supports
- [ ] Send your ideas to `Issues` section

# Usage

## NavigationView

If you need implement your own navigation view, but you don't wanna create `NavigationStack` and other boilerplate, just use `Morph.NavigationViewStyle` and pass to environment for `MorphNavigationView`. `MorphNavigationView` is SwiftUI replica of default `UINavigationViewController`.

Example:

Custom implementation of SwiftUI.NavigationViewStyle
```swift
public struct CustomNavigationViewStyle: SwiftUI.NavigationViewStyle, Moprh.NavigationViewStyle {
    public func _body(configuration: _NavigationViewStyleConfiguration) -> some View {
        MorphNavigationView {
            configuration.content
        }
        .environment(\.navigationViewStyle, AnyNavigationViewStyle(self))
    }

    public func makeBody(configuration: NavigationViewStyleConfiguration) -> some View { 
        // Your custom view implementation (Navigation bar and etc.)
    }
}
```

Usage in code
```swift

var body: some View {
    NavigationView {
        Text("Hello Morph")
    }
    .navigationViewStyle(CustomNavigationViewStyle())
}

```

### Additional functions

1) Navigation Bar Items

Because, we don't have access to passed parameters from default methods like `navigationBarItems(leading: L, trailing: T)` and etc, we implemented our own methids.

If you need set a navigation bar items, to your view, please use `navigationBarButtonItems(leading:trailing:)` instead of `navigationBarItems(leading:trailing:)`. It's works for both styles, for yours and default implementations.

```swift

var body: some View {
    NavigationView {
        Text("Hello Morph")
        .navigationBarButtonItems(leading: EditButton())
    }
    .navigationViewStyle(CustomNavigationViewStyle())
}

```

2) Navigation Bar Title

If you need set a navigation bar title, using `navigationBarTitle(_ string: String)`. 

```swift

var body: some View {
    NavigationView {
        Text("Hello Morph")
        .navigationBarButtonItems(leading: EditButton())
        .navigationBarTitle("Greeting")
    }
    .navigationViewStyle(CustomNavigationViewStyle())
}

```

3) Navigation Bar Tint

Also, you can control you navigaiton tint color for you own navigation bar, using `navigationBarTintColor(_ color: Color)` method.

4) Navigation Bar Background

To set custom background view, call `navigationBarBackground<V: View>(_ view: V)`

## Alert

We also support Alert Styles. To change your alert style, using methods `.alertStyle(_ style: AlertStyle)` and call method `.alertWithStyle()` instead of `.alert()`.
To create your own alert style, implement `AlertStyle` protocol

## ActionSheet

ActionSheet also can be styled, using `ActionSheetStyle` protocol. To change your action sheet style, using method `.actionSheetStyle(_ style: ActionSheetStyle)` and call method `.actionSheetWithStyle()` instead of `.actionSheet()`

## Slider

Because Apple doesn't support `SliderStyle` by default, but have documentation for it, we implemented our own Slider with style support.
Use styles for slider, use `MorphSlider` or `Morph.Slider` instead of `SwiftUI.Slider`. To change style for `MorphSlider` use `.sliderStyle(_ style: SliderStyle)` method.