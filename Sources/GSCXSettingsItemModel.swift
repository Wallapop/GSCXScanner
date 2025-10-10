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

import Foundation

/// Represents a settings item in the scanner settings view
@available(iOS 13.0, *)
public enum GSCXSettingsItemModel: Identifiable {
    case button(
        title: String,
        action: () -> Void,
        accessibilityIdentifier: String? = nil
    )
    case toggle(
        label: String,
        isOn: Bool,
        onChange: (Bool) -> Void,
        accessibilityIdentifier: String? = nil
    )
    case text(content: String)

    public var id: String {
        switch self {
        case .button(let title, _, let identifier):
            return identifier ?? "button_\(title)"
        case .toggle(let label, _, _, let identifier):
            return identifier ?? "toggle_\(label)"
        case .text(let content):
            return "text_\(content)"
        }
    }

    /// Factory method to create a button item
    public static func buttonItem(
        title: String,
        accessibilityIdentifier: String? = nil,
        action: @escaping () -> Void
    ) -> GSCXSettingsItemModel {
        return .button(
            title: title,
            action: action,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }

    /// Factory method to create a toggle item
    public static func toggleItem(
        label: String,
        isOn: Bool,
        accessibilityIdentifier: String? = nil,
        onChange: @escaping (Bool) -> Void
    ) -> GSCXSettingsItemModel {
        return .toggle(
            label: label,
            isOn: isOn,
            onChange: onChange,
            accessibilityIdentifier: accessibilityIdentifier
        )
    }

    /// Factory method to create a text item
    public static func textItem(content: String) -> GSCXSettingsItemModel {
        return .text(content: content)
    }
}
