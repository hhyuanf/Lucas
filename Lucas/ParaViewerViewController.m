//
//  ParaViewerViewController.m
//  Lucas
//
//  Created by xiangyuh on 13-8-23.
//  Copyright (c) 2013年 xiangyuh. All rights reserved.
//

#import "ParaViewerViewController.h"
#import "IIViewDeckController.h"
#import "IISideController.h"
#import "MCSwipeTableViewCell.h"
#import "ReaderDocument.h"
#import "ReaderThumbView.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbRequest.h"

#define DEMO_VIEW_CONTROLLER_PUSH FALSE
#define TOOLBAR_HEIGHT 50
static NSUInteger const kMCNumItems = 8;

@implementation Color
@synthesize color = _color,
name = _name;

+ (id)createColor:(UIColor *)color withName:(NSString *)name {
    Color *temp = [[Color alloc] init];
    temp.color = color;
    temp.name = name;
    return temp;
}

@end

@interface ParaViewerViewController () <ReaderViewControllerDelegate, MCSwipeTableViewCellDelegate,UITableViewDataSource,UITableViewDelegate, IIViewDeckControllerDelegate> {

    NSArray *_bgColors;
    NSArray *_groups;
    NSString *_selectedBg;
    NSString *_selectedAccent;
    NSString *_selectedGroup;
    IIViewDeckController *controller;
    UIToolbar *_toolbar;
    UILabel *label;
    UIBarButtonItem *refreshButton;
    UIBarButtonItem *settingButton;
    UIBarButtonItem *dropboxButton;
    NSIndexPath *_currentIndexPath;
}
@end


@implementation ParaViewerViewController

@synthesize leftScopeViewController = _leftScopeViewController;
@synthesize nbItems = _nbItems;
@synthesize tableView = _tableView;
@synthesize bookInfoArray = _bookInfoArray;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _bookInfoArray = [[NSBundle bundleWithPath:[ReaderDocument documentsPath]] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    NSString *book;
    for (book in _bookInfoArray) {
        [ReaderDocument withDocumentFilePath:book password:nil];
    }
    
    self.title = @"All Documents";
    
	CGRect viewBounds = self.view.bounds;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(viewBounds.origin.x, viewBounds.origin.y, [self referenceBounds].size.width, viewBounds.size.height)];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = YES;
    
    _toolbar = [[UIToolbar alloc] init];
    _toolbar.frame = CGRectMake(0, [self referenceBounds].size.height - TOOLBAR_HEIGHT, [self referenceBounds].size.width, TOOLBAR_HEIGHT);
    refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"update-25.png"] style:UIBarButtonItemStylePlain  target:self action:Nil];
    settingButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"settings-25.png"] style:UIBarButtonItemStylePlain  target:self action:nil];
    dropboxButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark-25.png"] style:(UIBarButtonItemStylePlain) target:self action:@selector(buttonPressed:)];
    [self fillToolBar];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 150, _toolbar.frame.size.height - 5 * 2)];
    label.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [label setFont:[UIFont fontWithName:@"Chalkduster" size:24]];
    label.text = @"Pamphlet";
    label.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:_toolbar];
    [_toolbar addSubview:label];
    
    [self setExtraCellLineHidden:_tableView];
}

- (IBAction)buttonPressed:(UIButton *)button
{
    DropboxBrowserViewController *dropboxBrowser = [[DropboxBrowserViewController alloc] init];
    [self.navigationController pushViewController:dropboxBrowser animated:YES];
//     dropboxBrowser.allowedFileTypes = @[@"doc", @"pdf"];// Uncomment to filter file types. Create an array of allowed types. To allow all file types simply don't set the property
    dropboxBrowser.allowedFileTypes = @[@"pdf"];
    // dropboxBrowser.tableCellID = @"DropboxBrowserCell"; // Uncomment to use a custom UITableViewCell ID. This property is not required
    
    // When a file is downloaded (either successfully or unsuccessfully) you can have DBBrowser notify the user with Notification Center. Default property is NO.
    dropboxBrowser.deliverDownloadNotifications = YES;
    
    // Dropbox Browser can display a UISearchBar to allow the user to search their Dropbox for a file or folder. Default property is NO.
    dropboxBrowser.shouldDisplaySearchBar = YES;
    
    // Set the delegate property to recieve delegate method calls
    dropboxBrowser.rootViewDelegate = self;

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (CGRect) referenceBounds {
    CGRect bounds = [[UIScreen mainScreen] bounds]; // portrait bounds
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    }
    return bounds;
}

- (void) fillToolBar
{
    UIBarButtonItem *marginSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:Nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:Nil];
    fixedSpace.width = 50.0f;
    marginSpace.width = [self referenceBounds].size.width - 7 * fixedSpace.width;
    NSArray *buttonItems = [NSArray arrayWithObjects: marginSpace, dropboxButton, fixedSpace, refreshButton, fixedSpace, settingButton, nil];
    [_toolbar setItems:buttonItems];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {}

- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    _toolbar.frame = CGRectMake(0, [self referenceBounds].size.height - TOOLBAR_HEIGHT, [self referenceBounds].size.width, TOOLBAR_HEIGHT);
    [self fillToolBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleSwipe:(NSIndexPath *)indexPath
{
	NSString *filePath = [NSString stringWithFormat:@"%@/%@", [NSBundle bundleWithPath:[ReaderDocument documentsPath]], _bookInfoArray[indexPath.row]];
    NSString *phrase = nil;
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document delegate:self];
        readerViewController.view.backgroundColor = [UIColor darkGrayColor];
        
        if ([readerViewController.navigationItem respondsToSelector:@selector(leftBarButtonItems)]) {
            readerViewController.delegate = self; // Set the ReaderViewController delegate to self
            
            _leftScopeViewController = [[LeftScopeViewController alloc] initWithNibName:@"LeftScopeViewController" bundle:nil];
            _leftScopeViewController = [_leftScopeViewController initWithReaderDocument:document];
            _leftScopeViewController.delegate = (id)readerViewController;
            readerViewController.thumbViewDelegate = (id)_leftScopeViewController;
            IISideController *leftSideController = [[IISideController alloc] initWithViewController:(UIViewController *) _leftScopeViewController constrained:200.0f];
            
            controller = [[IIViewDeckController alloc] initWithCenterViewController:readerViewController];
            controller.delegate = (id)self;
            controller.navigationControllerBehavior = IIViewDeckNavigationControllerContained;

            controller.rightController = leftSideController;
            [controller setSizeMode:IIViewDeckViewSizeMode];
            [controller setRightSize:200.0f];
            
            UIBarButtonItem *rightScopeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"generic_sorting-25.png"] style:UIBarButtonItemStylePlain  target:self action:@selector(leftScopeButtonClicked:)];
            UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:Nil action:Nil];
            fixedSpace.width = 20.0f;
            UIBarButtonItem *bookMarkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark-25.png"] style:UIBarButtonItemStylePlain  target:readerViewController action:@selector(bookMarkClicked)];
            UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share-25.png"] style:UIBarButtonItemStylePlain  target:self action:Nil];
            
            controller.navigationItem.rightBarButtonItems = @[rightScopeButton, fixedSpace, bookMarkButton, fixedSpace];
            controller.navigationItem.leftItemsSupplementBackButton = YES;
            controller.navigationItem.leftBarButtonItems = @[fixedSpace, shareButton];
            
            [_leftScopeViewController.view setNeedsDisplay];
            readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.navigationController pushViewController:controller animated:YES
             ];
        }
    }
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
    [self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
    
    controller.rightController = nil;
}

- (void)leftScopeButtonClicked:(UIButton *)button
{
    [controller toggleRightView];
}

- (void)setNeedsResume
{
    [controller closeRightView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_bookInfoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    MCSwipeTableViewCell *cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [cell setDelegate:self];
    [cell setFirstStateIconName:@"check.png"
                     firstColor:[UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
                  thirdIconName:@"clock.png"
                     thirdColor:[UIColor colorWithRed:254.0 / 255.0 green:217.0 / 255.0 blue:56.0 / 255.0 alpha:1.0]
                 fourthIconName:@"list.png"
                    fourthColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]];
    
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
    
    // Setting the default inactive state color to the tableView background color
    [cell setDefaultColor:self.tableView.backgroundView.backgroundColor];
    
    //
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    NSString *sBookItem = _bookInfoArray[indexPath.row];
    ReaderDocument *doc = [ReaderDocument unarchiveFromFileName:sBookItem password:false];
    cell.titleLabel.text = doc.fileTitle;
    cell.authorLabel.text = [[NSString alloc] initWithFormat:@"- %@", doc.authorName ];
    cell.thumbView.image = doc.thumbImg;
    [cell.thumbView.layer setBorderColor: [[UIColor lightGrayColor] CGColor]];
    [cell.thumbView.layer setBorderWidth: 1.5];
    [cell setProgressBarTotal:doc.pageCount nowHave:doc.pageNumber];
    
    [cell setFirstStateIconName:@"list.png"
                     firstColor:[UIColor colorWithRed:206.0 / 255.0 green:149.0 / 255.0 blue:98.0 / 255.0 alpha:1.0]
            secondStateIconName:@"cross.png"
                    secondColor:[UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0]
                  thirdIconName:nil
                     thirdColor:nil
                 fourthIconName:nil
                    fourthColor:nil];
    cell.firstTrigger = 0.1;
    cell.secondTrigger = 0.5;
    cell.shouldAnimatesIcons = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    ParaViewerViewController *tableViewController = [[ParaViewerViewController alloc] init];
//    [self.navigationController pushViewController:tableViewController animated:YES];
    _currentIndexPath = indexPath;
    [self handleSingleSwipe:indexPath];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - MCSwipeTableViewCellDelegate

// When the user starts swiping the cell this method is called
- (void)swipeTableViewCellDidStartSwiping:(MCSwipeTableViewCell *)cell {
    NSLog(@"Did start swiping the cell!");
}

// When the user ends swiping the cell this method is called
- (void)swipeTableViewCellDidEndSwiping:(MCSwipeTableViewCell *)cell {
    NSLog(@"Did end swiping the cell!");
}

/*
 // When the user is dragging, this method is called and return the dragged percentage from the border
 - (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didSwipWithPercentage:(CGFloat)percentage {
 NSLog(@"Did swipe with percentage : %f", percentage);
 }
 */

- (void)swipeTableViewCell:(MCSwipeTableViewCell *)cell didEndSwipingSwipingWithState:(MCSwipeTableViewCellState)state mode:(MCSwipeTableViewCellMode)mode {
    NSLog(@"Did end swipping with IndexPath : %@ - MCSwipeTableViewCellState : %d - MCSwipeTableViewCellMode : %d", [self.tableView indexPathForCell:cell], state, mode);
    
    if (mode == MCSwipeTableViewCellModeExit) {
        _nbItems--;
        [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)reloadTableViewCell
{
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:_currentIndexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - Dropbox
- (void)dropboxBrowser:(DropboxBrowserViewController *)browser didDownloadFile:(NSString *)fileName didOverwriteFile:(BOOL)isLocalFileOverwritten {
    if (isLocalFileOverwritten == YES) {
        NSLog(@"Downloaded %@ by overwriting local file", fileName);
    } else {
        NSLog(@"Downloaded %@ without overwriting", fileName);
    }
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser didFailToDownloadFile:(NSString *)fileName {
    NSLog(@"Failed to download %@", fileName);
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser fileConflictWithLocalFile:(NSURL *)localFileURL withDropboxFile:(DBMetadata *)dropboxFile withError:(NSError *)error {
    NSLog(@"File conflict between %@ and %@\n%@ last modified on %@\nError: %@", localFileURL.lastPathComponent, dropboxFile.filename, dropboxFile.filename, dropboxFile.lastModifiedDate, error);
}

- (void)dropboxBrowserDismissed:(DropboxBrowserViewController *)browser {
    // This method is called after Dropbox Browser is dismissed. Do NOT dismiss DropboxBrowser from this method
    // Perform any UI updates here to display any new data from Dropbox Browser
    // ex. Update a UITableView that shows downloaded files or get the name of the most recently selected file:
    //     NSString *fileName = [DropboxBrowserViewController currentFileName];
    [self.view setNeedsDisplay];
}

- (void)dropboxBrowser:(DropboxBrowserViewController *)browser deliveredFileDownloadNotification:(UILocalNotification *)notification {
    long badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber]+1;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}

#pragma mark -

- (void)reload:(id)sender {
    _nbItems++;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
