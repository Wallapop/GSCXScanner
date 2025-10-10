//
// Copyright 2020 Google Inc.
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

#import "GSCXContinuousScannerListTabBarViewController.h"

#import "GSCXContinuousScannerListViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GSCXContinuousScannerListTabBarViewController ()

/**
 * The data to display in the list views, in the same order as the list views are displayed in the
 * tab bar.
 */
@property(copy, nonatomic) NSArray<GSCXContinuousScannerListTabBarItem *> *items;

@end

@implementation GSCXContinuousScannerListTabBarViewController

- (instancetype)initWithItems:(NSArray<GSCXContinuousScannerListTabBarItem *> *)items {
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    _items = [items copy];
    self.viewControllers = [self gscx_viewControllersFromItems:self.items];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  // The tab bar needs to be opaque, otherwise the list view is displayed under it on iOS 10. The
  // content inset is not set correctly in this case, so some of the list cannot be scrolled into
  // view.
  self.tabBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  // Configure navigation bar with blue background and white text
  // Do this in viewWillAppear to ensure navigation controller is available
  if (@available(iOS 13.0, *)) {
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [UIColor systemBlueColor];
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    appearance.largeTitleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};

    // Apply to both navigation item and navigation bar
    self.navigationItem.standardAppearance = appearance;
    self.navigationItem.scrollEdgeAppearance = appearance;

    if (self.navigationController) {
      self.navigationController.navigationBar.standardAppearance = appearance;
      self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
      self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
  }
}

#pragma mark - Private

/**
 * Converts an array of @c GSCXContinuousScannerListTabBarItem instances to an array of view
 * controllers. Each view controller displays the data in the corresponding
 * @c GSCXContinuousScannerListTabBarItem instance.
 *
 * @param items Contains the sections to display in the view controllers.
 * @return An array of view controllers displaying the data in @c items, in order.
 */
- (NSArray<UIViewController *> *)gscx_viewControllersFromItems:
    (NSArray<GSCXContinuousScannerListTabBarItem *> *)items {
  NSMutableArray<UIViewController *> *viewControllers = [[NSMutableArray alloc] init];
  NSInteger tag = 0;
  for (GSCXContinuousScannerListTabBarItem *item in items) {
    GSCXContinuousScannerListViewController *viewController =
        [[GSCXContinuousScannerListViewController alloc] initWithSections:item.sections];

    // Add SF Symbols icons for tab bar items (iOS 13+)
    UIImage *tabIcon = nil;
    if (@available(iOS 13.0, *)) {
      if (tag == 0) {
        // "By Scan" tab - use photo icon
        tabIcon = [UIImage systemImageNamed:@"photo.on.rectangle"];
      } else if (tag == 1) {
        // "By Check" tab - use checkmark list icon
        tabIcon = [UIImage systemImageNamed:@"checklist"];
      }
    }

    viewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:item.title image:tabIcon tag:tag];
    tag++;
    [viewControllers addObject:viewController];
  }
  return viewControllers;
}

@end

NS_ASSUME_NONNULL_END
