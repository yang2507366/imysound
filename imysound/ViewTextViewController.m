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

@interface ViewTextViewController () <UITextViewDelegate>

@property(nonatomic, copy)NSString *textFilePath;
@property(nonatomic, retain)id<KeyValueManager> keyValueMgr;

@property(nonatomic, retain)UITextView *textView;
@property(nonatomic, retain)UIBarButtonItem *nowPlayingBtn;

@end

@implementation ViewTextViewController

@synthesize textFilePath = _textFilePath;
@synthesize keyValueMgr = _keyValueMgr;

@synthesize textView = _textView;
@synthesize nowPlayingBtn = _nowPlayingBtn;

- (void)dealloc
{
    [_textFilePath release];
    [_keyValueMgr release];
    
    [_textView release];
    [_nowPlayingBtn release];
    [super dealloc];
}

- (id)initWithTextFilePath:(NSString *)filePath
{
    self = [super init];
    
    self.textFilePath = filePath;
    self.keyValueMgr = [KeyValueManagerFactory createLocalDBKeyValueManagerWithName:@"text_position_"];
    
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
    
    CGFloat positionY = [[self.keyValueMgr valueForKey:self.textFilePath] floatValue];
    [self.textView scrollRectToVisible:CGRectMake(0, positionY, self.textView.bounds.size.width, self.textView.bounds.size.height) 
                              animated:NO];
    
    self.nowPlayingBtn = [[[UIBarButtonItem alloc] init] autorelease];
    self.nowPlayingBtn.title = NSLocalizedString(@"now_playing", nil);
    self.nowPlayingBtn.style = UIBarButtonItemStyleDone;
    self.nowPlayingBtn.target = self;
    self.nowPlayingBtn.action = @selector(onNowPlayingBtnTapped);
    if([Player sharedInstance].playing){
        self.navigationItem.rightBarButtonItem = self.nowPlayingBtn;
    }
    
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - events
- (void)onNowPlayingBtnTapped
{
    [self.navigationController pushViewController:[PlayViewController sharedInstance] animated:YES];
}

- (void)onPlayerDidStartPlayNotification:(NSNotification *)n
{
    self.navigationItem.rightBarButtonItem = self.nowPlayingBtn;
}

- (void)onPlayerDidStopNotification:(NSNotification *)n
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - UITextViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.keyValueMgr setValue:[NSString stringWithFormat:@"%f", scrollView.contentOffset.y] forKey:self.textFilePath];
}

@end
