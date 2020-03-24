//
//  AlertStyle.swift
//  
//
//  Created by v.prusakov on 3/25/20.
//

import SwiftUI

/// Defines the implementation of all `Alert` instances within a view
/// hierarchy.
///
/// To configure the current `AlertStyle` for a view hiearchy, use the
/// `.alertStyle()` modifier.
public protocol AlertStyle {
    
    associatedtype Body: View
    
    func makeBody(configuration: Self.Configuration) -> Self.Body
    
    typealias Configuration = AlertStyleConfiguration
    
}

public struct AlertStyleConfiguration {
    
    public struct Content: View {
        init<Content: View>(_ content: Content) {
            self.body = AnyView(content)
        }
        
        public var body: AnyView
    }
    
    public struct Alert {
        
        public struct Button: Identifiable {
            
            public enum Style: String {
                case cancel
                case destructive
                case `default`
            }
            
            public let id: String
            
            public let style: Style
            public let label: Text
            public let action: (() -> Void)
            
            init?(_ button: SwiftUI.Alert.Button) {
                let mirror = Mirror(reflecting: button)

                var dict: [String: Any] = [:]
                
                for child in mirror.children {
                    dict[child.label ?? ""] = child.value
                }
                
                guard let label = dict["label"] as? Text else { return nil }
                guard let action = dict["action"] as? () -> Void else { return nil }
                guard let internalStyle = dict["style"] else { return nil }
                
                let rawStyle = String(describing: internalStyle)
                
                self.id = UUID().uuidString
                self.label = label
                self.action = action
                self.style = Style(rawValue: rawStyle) ?? .cancel
            }
        }
        
        public let title: Text
        
        public let message: Text?
        
        public let primaryButton: Button?
        
        public let secondaryButton: Button?
        
        public let isSideBySide: Bool
        
        init(_ alert: SwiftUI.Alert) {
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
            let primaryButton = (dict["primaryButton"] as? SwiftUI.Alert.Button).flatMap(Button.init)
            let secondaryButton = (dict["secondaryButton"] as? SwiftUI.Alert.Button).flatMap(Button.init)
            
            self.primaryButton = primaryButton
            self.secondaryButton = secondaryButton
            
            self.isSideBySide = dict["isSideBySide"] as? Bool ?? false
        }
    }
    
    init(content: Content, alert: SwiftUI.Alert, isPresented: Binding<Bool>) {
        self.content = content
        self.alert = Alert(alert)
        self.rawAlert = alert
        self._isPresented = isPresented
    }
    
    public let content: Content
    
    public let alert: Alert
    
    let rawAlert: SwiftUI.Alert
    
    @Binding public var isPresented: Bool
    
}

// MARK: - Environment Key
extension EnvironmentValues {
    var alertStyle: AnyAlertStyle {
        get {
            return self[AlertStyleKey.self]
        }
        set {
            self[AlertStyleKey.self] = newValue
        }
    }
}

extension AlertStyle {
    func makeBodyTypeErased(configuration: Self.Configuration) -> AnyView {
        AnyView(self.makeBody(configuration: configuration))
    }
}

public struct AlertStyleKey: EnvironmentKey {
    public static let defaultValue: AnyAlertStyle = AnyAlertStyle(DefaultAlertStyle())
}

public struct AnyAlertStyle: AlertStyle {
    private let _makeBody: (AlertStyle.Configuration) -> AnyView
    
    init<ST: AlertStyle>(_ style: ST) {
        self._makeBody = style.makeBodyTypeErased
    }
    
    public func makeBody(configuration: AlertStyle.Configuration) -> AnyView {
        return self._makeBody(configuration)
    }
}

public extension View {
    func alertStyle<S: AlertStyle>(_ style: S) -> some View {
        self.environment(\.alertStyle, AnyAlertStyle(style))
    }
}

struct DefaultAlertStyle: AlertStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.content
            .alert(isPresented: configuration.$isPresented, content: { configuration.rawAlert })
    }
}


