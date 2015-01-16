//
//  ParaViewerViewController.h
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "LeftScopeViewController.h"
#import "IIViewDeckController.h"
#import "DropboxBrowserViewController.h"


@interface Color : NSObject

@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSString *name;

+ (id)createColor:(UIColor *)color withName:(NSString *)name;

@end

//@interface ParaViewerViewController : UITableViewController
@interface ParaViewerViewController : UIViewController <DropboxBrowserDelegate>

@property (nonatomic, strong) LeftScopeViewController *leftScopeViewController;
@property(nonatomic, assign) NSUInteger nbItems;
@property (nonatomic, strong) UITableView *tableView;
@property (strong, nonatomic) NSArray *bookInfoArray;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
@end
