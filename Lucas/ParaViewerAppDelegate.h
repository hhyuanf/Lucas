//
//  ParaViewerAppDelegate.h
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "LeftScopeViewController.h"
@class ParaViewerViewController;
@class IIViewDeckController;
@interface ParaViewerAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ParaViewerViewController *viewController;
@property (strong, nonatomic) UIViewController *centerController;
@property (strong, nonatomic) LeftScopeViewController *leftScopeViewController;

@end
