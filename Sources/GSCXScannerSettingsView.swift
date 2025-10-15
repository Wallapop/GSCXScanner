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

/// Main SwiftUI view for the scanner settings modal
@available(iOS 13.0, *)
public struct GSCXScannerSettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.accessibilityReduceMotion) var reduceMotion

    let items: [GSCXSettingsItemModel]
    let onDismiss: () -> Void

    public init(items: [GSCXSettingsItemModel], onDismiss: @escaping () -> Void) {
        self.items = items
        self.onDismiss = onDismiss
    }

    public var body: some View {
        if #available(iOS 14.0, *) {
            NavigationView {
                List {
                    ForEach(filteredItems) { item in
                        GSCXSettingsItemView(item: item)
                    }
                }
                .listStyle(.insetGrouped)
                .navigationTitle("Scanner Options")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: onDismiss) {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .accessibilityLabel("Close")
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: onDismiss) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .accessibilityLabel("Done")
                        }
                    }
                }
            }
            .colorScheme(.light)
            .accessibilityAction(.escape) {
                onDismiss()
            }
        } else {
            NavigationView {
                List {
                    ForEach(filteredItems) { item in
                        GSCXSettingsItemView(item: item)
                    }
                }
                .listStyle(.grouped)
                .navigationBarTitle("Scanner Options", displayMode: .inline)
                .navigationBarItems(
                    leading: Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .accessibility(label: Text("Close"))
                    },
                    trailing: Button(action: onDismiss) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                            .accessibility(label: Text("Done"))
                    }
                )
            }
            .accessibilityAction(.escape) {
                onDismiss()
            }
        }
    }

    /// Configures the navigation bar appearance with white text
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBlue
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }

    /// Filters out the dismiss button from the items list
    private var filteredItems: [GSCXSettingsItemModel] {
        items.filter { item in
            // Filter out dismiss button items based on accessibility identifier
            if case let .button(_, _, identifier) = item,
               identifier == "kGSCXDismissSettingsAccessibilityIdentifier"
            {
                return false
            }
            return true
        }
    }

    @ViewBuilder
    private var blurBackground: some View {
        if #available(iOS 15.0, *) {
            // Use material for iOS 15+
            if colorScheme == .dark {
                Color.clear.background(.regularMaterial)
            } else {
                Color.clear.background(.regularMaterial)
            }
        } else {
            // Fallback for iOS 13-14
            VisualEffectBlur(blurStyle: colorScheme == .dark ? .dark : .light)
        }
    }
}

// MARK: - Visual Effect Blur (iOS 13-14 Fallback)

var globalLook: NavigationBarAppearanceSnapshot?
@available(iOS 13.0, *)
public struct NavigationBarAppearanceSnapshot {
    let standard: UINavigationBarAppearance
    let scrollEdge: UINavigationBarAppearance?
    let compact: UINavigationBarAppearance?
    let tintColor: UIColor?

    static func capture() -> NavigationBarAppearanceSnapshot {
        let navigationBar = UINavigationBar.appearance()
        return NavigationBarAppearanceSnapshot(
            standard: navigationBar.standardAppearance,
            scrollEdge: navigationBar.scrollEdgeAppearance,
            compact: navigationBar.compactAppearance,
            tintColor: navigationBar.tintColor
        )
    }

    public func restore() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.standardAppearance = standard
        navigationBar.scrollEdgeAppearance = scrollEdge
        navigationBar.compactAppearance = compact
        navigationBar.tintColor = tintColor
    }
}

@available(iOS 13.0, *)
private struct VisualEffectBlur: UIViewRepresentable {
    let blurStyle: UIBlurEffect.Style

    func makeUIView(context _: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

// MARK: - View Modifiers for iOS Version Compatibility

@available(iOS 13.0, *)
private struct ScrollContentBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content.scrollContentBackground(.hidden)
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

// MARK: - Previews

#if DEBUG
    @available(iOS 14.0, *)
    struct GSCXScannerSettingsView_Previews: PreviewProvider {
        static var previews: some View {
            ZStack {
                // Simulated app background
                Color.blue
                    .ignoresSafeArea()

                GSCXScannerSettingsView(
                    items: [
                        .buttonItem(
                            title: "Scan Current Screen",
                            accessibilityIdentifier: "kGSCXPerformScanAccessibilityIdentifier",
                            action: { print("Scan") }
                        ),
                        .buttonItem(
                            title: "Start Continuous Scanning",
                            accessibilityIdentifier: "kGSCXSettingsContinuousScanButtonAccessibilityIdentifier",
                            action: { print("Start continuous") }
                        ),
                        .toggleItem(
                            label: "Enable Feature",
                            isOn: true,
                            onChange: { _ in print("Toggle changed") }
                        ),
                        .textItem(content: "No issues found"),
                        .buttonItem(
                            title: "Dismiss",
                            accessibilityIdentifier: "kGSCXDismissSettingsAccessibilityIdentifier",
                            action: { print("Dismiss") }
                        ),
                    ],
                    onDismiss: { print("Dismissed") }
                )
            }
            .previewDisplayName("Light Mode")

            ZStack {
                // Simulated app background
                Color.blue
                    .ignoresSafeArea()

                GSCXScannerSettingsView(
                    items: [
                        .buttonItem(
                            title: "Scan Current Screen",
                            action: { print("Scan") }
                        ),
                        .buttonItem(
                            title: "Start Continuous Scanning",
                            action: { print("Start continuous") }
                        ),
                        .textItem(content: "Continuous Scan Report Empty."),
                        .buttonItem(
                            title: "Dismiss",
                            action: { print("Dismiss") }
                        ),
                    ],
                    onDismiss: { print("Dismissed") }
                )
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
#endif
