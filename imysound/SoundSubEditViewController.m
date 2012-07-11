//
//  SoundSubEditViewController.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubEditViewController.h"
#import "PlayerStatusView.h"

@interface SoundSubEditViewController () <PlayerControlViewDelegate>

@property(nonatomic, copy)NSString *soundFilePath;

@property(nonatomic, retain)PlayerStatusView *playerStatusView;

@end

@implementation SoundSubEditViewController

@synthesize soundFilePath = _soundFilePath;

@synthesize playerStatusView = _playerStatusView;

- (void)dealloc
{
    [_soundFilePath release];
    
    [_playerStatusView release];
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
    
    self.playerStatusView = [[[PlayerStatusView alloc] init] autorelease];
    [self.view addSubview:self.playerStatusView];
    self.playerStatusView.delegate = self;
    self.playerStatusView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
}

#pragma mark - instance methods
- (void)onDoneBtnTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - PlayerControlViewDelegate
- (void)playerControlView:(PlayerStatusView *)playerStatusView didChangeToNewPosition:(float)value
{
    
}

@end
