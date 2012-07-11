//
//  SoundSubEditViewController.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubEditViewController.h"
#import "PlayerControlView.h"

@interface SoundSubEditViewController ()

@property(nonatomic, copy)NSString *soundFilePath;

@property(nonatomic, retain)PlayerControlView *playerControlView;

@end

@implementation SoundSubEditViewController

@synthesize soundFilePath = _soundFilePath;

@synthesize playerControlView = _playerControlView;

- (void)dealloc
{
    [_soundFilePath release];
    
    [_playerControlView release];
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
    
    self.playerControlView = [[[PlayerControlView alloc] init] autorelease];
    [self.view addSubview:self.playerControlView];
    self.playerControlView.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
}

#pragma mark - instance methods
- (void)onDoneBtnTapped
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
