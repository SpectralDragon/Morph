//
//  ActionSheetStyle.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

/// Defines the implementation of all `ActionSheet` instances within a view
/// hierarchy.
///
/// To configure the current `ActionSheetStyle` for a view hiearchy, use the
/// `.actionSheetStyle()` modifier.
public protocol ActionSheetStyle {
    
    associatedtype Body: View
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = ActionSheetStyleConfiguration
    
}

public struct ActionSheetStyleConfiguration {
    
    public struct Content: View {
        init<Content: View>(_ content: Content) {
            self.body = AnyView(content)
        }
        
        public var body: AnyView
    }
    
    public struct ActionSheet {
        
        public typealias Button = AlertStyleConfiguration.Alert.Button
        
        public let title: Text
        
        public let message: Text?
        
        public let buttons: [Button]
        
        init(_ alert: SwiftUI.ActionSheet) {
            let mirror = Mirror(reflecting: alert)
            
            var dict: [String: Any] = [:]
            
            for child in mirror.children {
                dict[child.label ?? ""] = child.value
            }
            
            guard let title = dict["title"] as? Text else {
                fatalError("Can't get value for key title")
            }
            
            self.title = title
            
            self.message = dict["message"] as? Text
            var buttons = (dict["buttons"] as? [SwiftUI.ActionSheet.Button])?.compactMap(Button.init) ?? []
            
            if buttons.filter({ $0.style == .cancel }).count > 1 {
                fatalError("UIAlertController can only have one action with a style of UIAlertActionStyleCancel")
            }
            
            if let cancelIndex = buttons.firstIndex(where: { $0.style == .cancel }) {
                let element = buttons.remove(at: cancelIndex)
                
                buttons.append(element)
            }
            
            self.buttons = buttons
        }
    }
    
    init(content: Content, actionSheet: SwiftUI.ActionSheet, isPresented: Binding<Bool>) {
        self.content = content
        self.actionSheet = ActionSheet(actionSheet)
        self.rawActionSheet = actionSheet
        self._isPresented = isPresented
    }
    
    public let content: Content
    
    public let actionSheet: ActionSheet
    
    let rawActionSheet: SwiftUI.ActionSheet
    
    @Binding public var isPresented: Bool
    
}

// MARK: - Environment Key
extension EnvironmentValues {
    var actionSheetStyle: AnyActionSheetStyle {
        get {
            return self[ActionSheetStyleKey.self]
        }
        set {
            self[ActionSheetStyleKey.self] = newValue
        }
    }
}

extension ActionSheetStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

public struct ActionSheetStyleKey: EnvironmentKey {
    public static let defaultValue: AnyActionSheetStyle = AnyActionSheetStyle(DefaultActionSheetStyle())
}

public struct AnyActionSheetStyle: ActionSheetStyle {
    private let _makeBody: (ActionSheetStyle.Configuration) -> AnyView
    
    init<ST: ActionSheetStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }
    
    public func makeBody(configuration: ActionSheetStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

public extension View {
    func actionSheetStyle<S: ActionSheetStyle>(_ style: S) -> some View {
        self.environment(\.actionSheetStyle, AnyActionSheetStyle(style))
    }
}

struct DefaultActionSheetStyle: ActionSheetStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.content
            .actionSheet(isPresented: configuration.$isPresented, content: { configuration.rawActionSheet })
    }
}
