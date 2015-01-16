//
//  ParaViewerAppDelegate.m
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import "ParaViewerAppDelegate.h"

#import "ParaViewerViewController.h"
#import "IIViewDeckController.h"
#import "LeftScopeViewController.h"
#import "IISideController.h"

@implementation ParaViewerAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize centerController = _centerController;
@synthesize leftScopeViewController = _leftScopeViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DBSession *dbSession = [[DBSession alloc] initWithAppKey:@"yg5r3pfdxp3nr2f" appSecret:@"a62s6w77cm5mu63" root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.rootViewController = (UIViewController *)[self generateControllerStack];
    
    [self.window makeKeyAndVisible];
    return YES;
}
- (CGRect) referenceBounds {
    CGRect bounds = [[UIScreen mainScreen] bounds]; // portrait bounds
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    }
    return bounds;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}
- (UIViewController *)generateControllerStack
{
    UIViewController *paraViewerViewController = [[ParaViewerViewController alloc] initWithNibName:Nil bundle:Nil];
    
    paraViewerViewController = [[UINavigationController alloc]
                                initWithRootViewController:paraViewerViewController];
    return paraViewerViewController;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
