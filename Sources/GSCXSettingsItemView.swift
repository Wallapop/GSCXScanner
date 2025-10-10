//
// Copyright 2018 Google Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI

/// SwiftUI view for displaying a single settings item row
@available(iOS 13.0, *)
struct GSCXSettingsItemView: View {
    @Environment(\.colorScheme) var colorScheme

    let item: GSCXSettingsItemModel

    var body: some View {
        Group {
            switch item {
            case .button(let title, let action, let identifier):
                ButtonRow(title: title, action: action, accessibilityIdentifier: identifier)
            case .toggle(let label, let isOn, let onChange, let identifier):
                ToggleRow(label: label, isOn: isOn, onChange: onChange, accessibilityIdentifier: identifier)
            case .text(let content):
                TextRow(content: content)
            }
        }
        .listRowBackground(Color.clear)
        .modifier(SeparatorTintModifier(color: separatorColor))
    }

    private var separatorColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.2) : Color.black.opacity(0.125)
    }
}

// MARK: - View Modifiers for iOS Version Compatibility

@available(iOS 13.0, *)
private struct SeparatorTintModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        if #available(iOS 15.0, *) {
            content.listRowSeparatorTint(color)
        } else {
            content
        }
    }
}

@available(iOS 13.0, *)
private struct AccessibilityIdentifierModifier: ViewModifier {
    let identifier: String

    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.accessibilityIdentifier(identifier)
        } else {
            content
        }
    }
}

@available(iOS 13.0, *)
private struct OnChangeModifier: ViewModifier {
    let value: Bool
    let action: (Bool) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 14.0, *) {
            content.onChange(of: value, perform: action)
        } else {
            content
        }
    }
}

// MARK: - Button Row

@available(iOS 13.0, *)
private struct ButtonRow: View {
    @Environment(\.colorScheme) var colorScheme

    let title: String
    let action: () -> Void
    let accessibilityIdentifier: String?

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundColor(textColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .modifier(AccessibilityIdentifierModifier(identifier: accessibilityIdentifier ?? ""))
        .frame(minHeight: 48)
        .padding(.vertical, 8)
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Toggle Row

@available(iOS 13.0, *)
private struct ToggleRow: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var toggleValue: Bool

    let label: String
    let onChange: (Bool) -> Void
    let accessibilityIdentifier: String?

    init(label: String, isOn: Bool, onChange: @escaping (Bool) -> Void, accessibilityIdentifier: String?) {
        self.label = label
        self._toggleValue = State(initialValue: isOn)
        self.onChange = onChange
        self.accessibilityIdentifier = accessibilityIdentifier
    }

    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)

            Toggle("", isOn: $toggleValue)
                .labelsHidden()
                .modifier(OnChangeModifier(value: toggleValue, action: onChange))
                .modifier(AccessibilityIdentifierModifier(identifier: accessibilityIdentifier ?? ""))
        }
        .frame(minHeight: 48)
        .padding(.vertical, 8)
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Text Row

@available(iOS 13.0, *)
private struct TextRow: View {
    @Environment(\.colorScheme) var colorScheme

    let content: String

    var body: some View {
        HStack {
            Text(content)
                .font(.body)
                .foregroundColor(textColor)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(minHeight: 48)
        .padding(.vertical, 8)
    }

    private var textColor: Color {
        colorScheme == .dark ? .white : .black
    }
}

// MARK: - Previews

#if DEBUG
@available(iOS 14.0, *)
struct GSCXSettingsItemView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            GSCXSettingsItemView(item: .buttonItem(title: "Scan Current Screen", action: {}))
            GSCXSettingsItemView(item: .buttonItem(title: "Start Continuous Scanning", action: {}))
            GSCXSettingsItemView(item: .toggleItem(label: "Enable Feature", isOn: true, onChange: { _ in }))
            GSCXSettingsItemView(item: .textItem(content: "No issues found"))
            GSCXSettingsItemView(item: .buttonItem(title: "Dismiss", action: {}))
        }
        .listStyle(.plain)
        .previewDisplayName("Light Mode")

        List {
            GSCXSettingsItemView(item: .buttonItem(title: "Scan Current Screen", action: {}))
            GSCXSettingsItemView(item: .buttonItem(title: "Start Continuous Scanning", action: {}))
            GSCXSettingsItemView(item: .toggleItem(label: "Enable Feature", isOn: true, onChange: { _ in }))
            GSCXSettingsItemView(item: .textItem(content: "No issues found"))
            GSCXSettingsItemView(item: .buttonItem(title: "Dismiss", action: {}))
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
        .previewDisplayName("Dark Mode")
    }
}
#endif
