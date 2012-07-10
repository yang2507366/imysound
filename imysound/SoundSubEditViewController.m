//
//  SoundSubEditViewController.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubEditViewController.h"

@interface SoundSubEditViewController ()

@property(nonatomic, copy)NSString *soundFilePath;

@property(nonatomic, retain)UIView *topControlView;
@property(nonatomic, retain)UILabel *currentTimeLabel;
@property(nonatomic, retain)UILabel *totalTimeLabel;
@property(nonatomic, retain)UISlider *positionSilder;

@property(nonatomic, assign)BOOL positionSilderTouching;

@end

@implementation SoundSubEditViewController

@synthesize soundFilePath = _soundFilePath;

@synthesize topControlView = _topControlView;
@synthesize currentTimeLabel = _currentTimeLabel;
@synthesize totalTimeLabel = _totalTimeLabel;
@synthesize positionSilder = _positionSilder;

@synthesize positionSilderTouching = _positionSilderTouching;

- (void)dealloc
{
    [_soundFilePath release];
    
    [_topControlView release];
    [_currentTimeLabel release];
    [_totalTimeLabel release];
    [_positionSilder release];
    [super dealloc];
}

- (id)initWithSoundFilePath:(NSString *)soundFilePath
{
    self = [super init];
    
    self.title = NSLocalizedString(@"edit_sound_sub", nil);
    
    self.soundFilePath = soundFilePath;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                                                             target:self 
                                                                             action:@selector(onDoneBtnTapped)];
    self.navigationItem.rightBarButtonItem = doneBtn;
    [doneBtn release];
    
    CGRect frame;
    
    // topControlView
    frame = self.view.bounds;
    frame.size.height = 44.0f;
    self.topControlView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:self.topControlView];
    self.topControlView.backgroundColor = [UIColor clearColor];
    
    // position slider
    frame = self.view.bounds;
    frame.size.height = 44.0f;
    UIView *topBlackBar = [[[UIView alloc] initWithFrame:frame] autorelease];
    [self.topControlView addSubview:topBlackBar];
    topBlackBar.backgroundColor = [UIColor blackColor];
    topBlackBar.alpha = 0.52f;
    
    frame.origin.y = topBlackBar.frame.origin.y + topBlackBar.frame.size.height;
    frame.origin.x = 0;
    frame.size.width = topBlackBar.frame.size.width;
    frame.size.height = 1;
    UIView *bottomLine = [[[UIView alloc] initWithFrame:frame] autorelease];
    [self.topControlView addSubview:bottomLine];
    bottomLine.backgroundColor = [UIColor blackColor];
    bottomLine.alpha = 0.67f;
    
    frame.origin.x = 47;
    frame.size.width = self.view.bounds.size.width - (frame.origin.x * 2);
    frame.size.height = 20.0f;
    frame.origin.y = topBlackBar.frame.origin.y + (topBlackBar.frame.size.height - frame.size.height) / 2;
    self.positionSilder = [[[UISlider alloc] initWithFrame:frame] autorelease];
    [self.positionSilder addTarget:self 
                            action:@selector(onPositionSilderDragEnter) 
                  forControlEvents:UIControlEventTouchDown];
    [self.positionSilder addTarget:self 
                            action:@selector(onPositionSilderDragExit) 
                  forControlEvents:UIControlEventTouchUpInside];
    [self.positionSilder addTarget:self 
                            action:@selector(onPositionSilderDragExit) 
                  forControlEvents:UIControlEventTouchUpOutside];
    [self.topControlView addSubview:self.positionSilder];
    
    // time labels
    UIFont *timeFont = [UIFont systemFontOfSize:12.0f];
    frame.size.width = [@"00:00" sizeWithFont:timeFont].width;
    frame.origin.x = self.positionSilder.frame.origin.x - frame.size.width - 2;
    frame.origin.y = self.positionSilder.frame.origin.y;
    frame.size.height = self.positionSilder.frame.size.height;
    self.currentTimeLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [self.topControlView addSubview:self.currentTimeLabel];
    self.currentTimeLabel.backgroundColor = [UIColor clearColor];
    self.currentTimeLabel.textColor = [UIColor whiteColor];
    self.currentTimeLabel.font = timeFont;
    self.currentTimeLabel.text = @"00:00";
    
    frame = self.currentTimeLabel.frame;
    frame.origin.x = self.positionSilder.frame.origin.x + self.positionSilder.frame.size.width + 2;
    self.totalTimeLabel = [[[UILabel alloc] initWithFrame:frame] autorelease];
    [self.topControlView addSubview:self.totalTimeLabel];
    self.totalTimeLabel.backgroundColor = [UIColor clearColor];
    self.totalTimeLabel.textColor = [UIColor whiteColor];
    self.totalTimeLabel.font = timeFont;
    self.totalTimeLabel.text = @"00:00";
}

#pragma mark - instance methods
- (void)onDoneBtnTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)onPositionSilderDragEnter
{
    self.positionSilderTouching = YES;
}

- (void)onPositionSilderDragExit
{
    self.positionSilderTouching = NO;
}

@end
