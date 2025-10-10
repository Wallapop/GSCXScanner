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
import UIKit

/// UIKit hosting controller for the SwiftUI scanner settings view
@available(iOS 13.0, *)
@objc public class GSCXScannerSettingsHostingController: UIViewController, GSCXScannerSettingsViewDelegate {

    // MARK: - Properties

    private var hostingController: UIHostingController<GSCXScannerSettingsView>?
    private var items: [GSCXSettingsItemModel]
    private var initialFrame: CGRect
    private var isAnimatingIn: Bool = false
    private var isAnimatingOut: Bool = false

    /// A handler called when this view controller dismisses itself
    @objc public var dismissBlock: ((GSCXScannerSettingsHostingController) -> Void)?

    // MARK: - Initialization

    /// Initializes the hosting controller with settings items and initial frame
    /// - Parameters:
    ///   - items: Array of settings item models
    ///   - initialFrame: The initial frame for the settings view (for animation)
    public init(items: [GSCXSettingsItemModel], initialFrame: CGRect) {
        self.items = items
        self.initialFrame = initialFrame
        super.init(nibName: nil, bundle: nil)

        modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {
            // Allows user to dismiss by swiping down
            if let sheet = sheetPresentationController {
                sheet.detents = [.medium(), .large()]
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 16
            }
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupSwiftUIView()
    }

    // MARK: - Public Methods

    /// Dismisses the view controller (for Objective-C compatibility)
    /// - Parameter completion: Optional completion handler
    @objc(dismissWithCompletion:)
    public func dismissSettings(completion: ((Bool) -> Void)? = nil) {
        dismiss(animated: true) {
            completion?(true)
        }
    }

    // MARK: - GSCXScannerSettingsViewDelegate

    public func settingsViewDidRequestDismiss() {
        dismissBlock?(self)
    }

    // MARK: - Accessibility

    public override func accessibilityPerformEscape() -> Bool {
        dismissBlock?(self)
        return true
    }

    // MARK: - Private Methods

    private func setupSwiftUIView() {
        let settingsView = GSCXScannerSettingsView(
            items: items,
            onDismiss: { [weak self] in
                guard let self = self else { return }
                self.dismissBlock?(self)
            }
        )

        let hosting = UIHostingController(rootView: settingsView)
        hosting.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)

        NSLayoutConstraint.activate([
            hosting.view.topAnchor.constraint(equalTo: view.topAnchor),
            hosting.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hosting.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hosting.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController = hosting
    }
}

// MARK: - Objective-C Bridge

@available(iOS 13.0, *)
extension GSCXScannerSettingsHostingController {
    /// Creates settings items from Objective-C style configuration
    /// - Parameters:
    ///   - items: Array of settings items (can be passed from Objective-C)
    ///   - initialFrame: Initial frame for animation
    ///   - performScanAction: Action for perform scan button
    ///   - startContinuousScanAction: Action for start continuous scanning button
    ///   - dismissAction: Action for dismiss button
    /// - Returns: Configured hosting controller
    @objc public static func createWithActions(
        initialFrame: CGRect,
        performScanAction: @escaping () -> Void,
        startContinuousScanAction: @escaping () -> Void,
        dismissAction: @escaping () -> Void
    ) -> GSCXScannerSettingsHostingController {
        let items: [GSCXSettingsItemModel] = [
            .buttonItem(
                title: "Scan Current Screen",
                accessibilityIdentifier: "kGSCXPerformScanAccessibilityIdentifier",
                action: performScanAction
            ),
            .buttonItem(
                title: "Start Continuous Scanning",
                accessibilityIdentifier: "kGSCXSettingsContinuousScanButtonAccessibilityIdentifier",
                action: startContinuousScanAction
            ),
            .buttonItem(
                title: "Dismiss",
                accessibilityIdentifier: "kGSCXDismissSettingsAccessibilityIdentifier",
                action: dismissAction
            ),
        ]

        return GSCXScannerSettingsHostingController(items: items, initialFrame: initialFrame)
    }
}
