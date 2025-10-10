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

#import "GSCXAutoInstaller.h"

#import "GSCXInstaller.h"
#import "GTXiLib.h"
NS_ASSUME_NONNULL_BEGIN

#pragma mark - GSCXAutoInstaller Implementation

@implementation GSCXAutoInstaller

static UIWindow *gscx_overlayWindow = nil;

+ (BOOL)installScanner {
  static dispatch_once_t onceToken;
  __block BOOL wasInstalled = NO;
  dispatch_once(&onceToken, ^{
    if (gscx_overlayWindow == nil) {
      gscx_overlayWindow = [GSCXInstaller installScanner];
      wasInstalled = YES;
      [[GTXLogger defaultLogger] logWithLevel:GTXLogLevelDeveloper
                                       format:@"iOS Scanner installed successfully."];
    } else {
      [[GTXLogger defaultLogger] logWithLevel:GTXLogLevelDeveloper
                                       format:@"iOS Scanner was already installed."];
    }
  });
  return wasInstalled;
}

@end

NS_ASSUME_NONNULL_END
