//
//  ViewTextViewController.m
//  imysound
//
//  Created by gewara on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewTextViewController.h"
#import "KeyValueManagerFactory.h"
#import "Player.h"
#import "PlayViewController.h"
#import "UITools.h"
#import "TextBookmarkViewController.h"
#import "TextBookmark.h"
#import "CommonUtils.h"
#import "DictionaryViewController.h"
#import "DBGlossaryManager.h"
#import "GlossaryLibraryViewController.h"

@interface ViewTextViewController () <UITextViewDelegate, TextBookmarkViewControllerDelegate, DictionaryViewControllerDelegate>

@property(nonatomic, copy)NSString *textFilePath;
@property(nonatomic, retain)id<KeyValueManager> keyValueMgr;
@property(nonatomic, retain)id<TextBookmarkManager> bookmarkMgr;
@property(nonatomic, retain)id<GlossaryManager> glossaryMgr;

@property(nonatomic, retain)UITextView *textView;
@property(nonatomic, retain)UIBarButtonItem *nowPlayingBtn;

- (void)scrollTextViewToY:(CGFloat)y animated:(BOOL)animated;
- (void)configureDictionaryMenuItem;

@end

@implementation ViewTextViewController

@synthesize textFilePath = _textFilePath;
@synthesize keyValueMgr = _keyValueMgr;
@synthesize bookmarkMgr = _bookmarkMgr;
@synthesize glossaryMgr = _glossaryMgr;

@synthesize textView = _textView;
@synthesize nowPlayingBtn = _nowPlayingBtn;

- (void)dealloc
{
    [_textFilePath release];
    [_keyValueMgr release];
    [_bookmarkMgr release];
    [_glossaryMgr release];
    
    [_textView release];
    [_nowPlayingBtn release];
    [super dealloc];
}

- (id)initWithTextFilePath:(NSString *)filePath
{
    self = [super init];
    
    self.textFilePath = filePath;
    self.keyValueMgr = [KeyValueManagerFactory createLocalDBKeyValueManagerWithName:@"text_position_"];
    self.bookmarkMgr = [TextBookmarkManager createManager];
    self.glossaryMgr = [[[DBGlossaryManager alloc] initWithIdentifier:[filePath lastPathComponent]] autorelease];
    
    self.title = [self.textFilePath lastPathComponent];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= self.navigationController.navigationBar.frame.size.height;
    self.textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:self.textView];
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:14.0f];
    
    self.textView.text = [NSString stringWithContentsOfFile:self.textFilePath encoding:NSASCIIStringEncoding error:nil];
    self.textView.delegate = self;
    
    [self scrollTextViewToY:[[self.keyValueMgr valueForKey:self.textFilePath] floatValue] animated:NO];
    
    self.nowPlayingBtn = [[[UIBarButtonItem alloc] init] autorelease];
    self.nowPlayingBtn.title = NSLocalizedString(@"now_playing", nil);
    self.nowPlayingBtn.style = UIBarButtonItemStyleDone;
    self.nowPlayingBtn.target = self;
    self.nowPlayingBtn.action = @selector(onNowPlayingBtnTapped);
    if([Player sharedInstance].playing){
        self.navigationItem.rightBarButtonItem = self.nowPlayingBtn;
    }
    
    CGFloat tmpY = self.view.bounds.size.height - self.navigationController.navigationBar.frame.size.height - 44.0f;
    UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:
                           CGRectMake(0, tmpY, self.view.bounds.size.width, 44.0f)] autorelease];
    [self.view addSubview:toolbar];
    toolbar.barStyle = UIBarStyleBlack;
    
    NSMutableArray *toolbarItems = [NSMutableArray array];
    
    [toolbarItems addObject:[UITools createFlexibleSpaceBarButtonItem]];
    UIBarButtonItem *bookmarkBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks 
                                                                                 target:self 
                                                                                 action:@selector(onBookmarkBtnTapped)] autorelease];
    [toolbarItems addObject:bookmarkBtn];
    [toolbarItems addObject:[UITools createFlexibleSpaceBarButtonItem]];
    
    [toolbarItems addObject:[UITools createFlexibleSpaceBarButtonItem]];
    UIBarButtonItem *glossaryBtn = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch 
                                                                                 target:self 
                                                                                 action:@selector(onGlossaryBtnTapped)] autorelease];
    [toolbarItems addObject:glossaryBtn];
    [toolbarItems addObject:[UITools createFlexibleSpaceBarButtonItem]];
    
    toolbar.items = toolbarItems;
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onPlayerDidStartPlayNotification:) 
                                                 name:kPlayerDidStartPlayNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onPlayerDidStopNotification:) 
                                                 name:kPlayerDidStopNotification 
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onPlayerDidStopNotification:) 
                                                 name:kPlayQueueDidPlayCompletely 
                                               object:nil];
    
    [self configureDictionaryMenuItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - TextBookmarkViewControllerDelegate
- (CGFloat)scrollPositionForTextBookmarkViewControllerToAddNewBookmark:(TextBookmarkViewController *)vc
{
    return self.textView.contentOffset.y;
}

- (void)textBookmarkViewControllerDidSelectTextBookmark:(TextBookmark *)bookmark
{
    [self scrollTextViewToY:bookmark.scrollPosition animated:YES];
}

#pragma mark - private methods
- (void)scrollTextViewToY:(CGFloat)y animated:(BOOL)animated
{
    [self.textView scrollRectToVisible:CGRectMake(0, y, self.textView.bounds.size.width, self.textView.bounds.size.height) 
                              animated:animated];
}

- (void)configureDictionaryMenuItem
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    NSMutableArray *menuItems = [NSMutableArray arrayWithArray:menuController.menuItems];
    BOOL dictMenuItemExists = NO;
    for(UIMenuItem *menuItem in menuItems){
        if([menuItem.title isEqualToString:NSLocalizedString(@"Dictionary", nil)]){
            dictMenuItemExists = YES;
            break;
        }
    }
    if(!dictMenuItemExists){
        UIMenuItem *dictMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Dictionary", nil) 
                                                              action:@selector(onDictMenuItemTapped)];
        [menuItems addObject:dictMenuItem];
        [dictMenuItem release];
        menuController.menuItems = menuItems;
    }
}

#pragma mark - events
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if(action == @selector(onDictMenuItemTapped)){
        NSString *selectedText = [self.textView.text substringWithRange:self.textView.selectedRange];
        if([selectedText length] != 0){
            return ![CommonUtils stringContainsChinese:selectedText];
        }
    }
    return [super canPerformAction:action withSender:sender];
}

- (void)onGlossaryBtnTapped
{
    GlossaryLibraryViewController *vc = [[GlossaryLibraryViewController alloc] initWithGlossaryManager:self.glossaryMgr];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onDictMenuItemTapped
{
    [self presentModalViewController:[DictionaryViewController sharedInstance] animated:YES];
    [[DictionaryViewController sharedInstance] query:[self.textView.text substringWithRange:self.textView.selectedRange]];
    [DictionaryViewController sharedInstance].dictionaryViewControllerDelegate = self;
}

- (void)onNowPlayingBtnTapped
{
    [self.navigationController pushViewController:[PlayViewController sharedInstance] animated:YES];
}

- (void)onBookmarkBtnTapped
{
    [self scrollTextViewToY:self.textView.contentOffset.y animated:NO];
    TextBookmarkViewController *vc = [[TextBookmarkViewController alloc] initWithIdentifier:self.textFilePath];
    vc.delegate = self;
    UINavigationController *nc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    nc.navigationBar.barStyle = self.navigationController.navigationBar.barStyle;
    [self presentModalViewController:nc animated:YES];
    [vc release];
}

- (void)onPlayerDidStartPlayNotification:(NSNotification *)n
{
    self.navigationItem.rightBarButtonItem = self.nowPlayingBtn;
}

- (void)onPlayerDidStopNotification:(NSNotification *)n
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - DictionaryViewControllerDelegate
- (BOOL)dictionaryViewController:(DictionaryViewController *)dictVC bookmarkWord:(NSString *)word
{
    [self.glossaryMgr addWord:word];
    return YES;
}

#pragma mark - UITextViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.keyValueMgr setValue:[NSString stringWithFormat:@"%f", scrollView.contentOffset.y] forKey:self.textFilePath];
}

@end
