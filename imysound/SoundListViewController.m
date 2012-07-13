//
//  SoundListViewController.m
//  imysound
//
//  Created by yzx on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundListViewController.h"
#import "PopOutTableView.h"
#import "CommonUtils.h"
#import "SoundSubListEditViewController.h"
#import "SoundSubPlayListViewController.h"
#import "ViewTextViewController.h"
#import "Player.h"
#import "PlayViewController.h"

@interface SoundListViewController () <PopOutTableViewDelegate>

@property(nonatomic, retain)PopOutTableView *tableView;
@property(nonatomic, retain)NSMutableArray *soundFileList;

@property(nonatomic, retain)UIView *soundFilePopOutView;
@property(nonatomic, retain)UIView *otherFilePopOutView;

@property(nonatomic, retain)UIBarButtonItem *nowPlayingBtn;

- (NSString *)soundFileAtIndex:(NSInteger)index;

- (void)reloadSoundList;

@end

@implementation SoundListViewController

@synthesize tableView = _tableView;
@synthesize soundFileList = _soundFileList;

@synthesize soundFilePopOutView = _soundFilePopOutView;
@synthesize otherFilePopOutView = _otherFilePopOutView;

@synthesize nowPlayingBtn = _nowPlayingBtn;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_tableView release];
    [_soundFileList release];
    
    [_soundFilePopOutView release];
    [_otherFilePopOutView release];
    
    [_nowPlayingBtn release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    
    self.title = NSLocalizedString(@"imysounds", nil);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[[PopOutTableView alloc] initWithFrame:self.fullBounds] autorelease];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.editable = YES;
    
    UIView *soundFilePopOutView = [[[UIView alloc] initWithFrame:
                           CGRectMake(0, 0, self.tableView.frame.size.width, 50)] autorelease];
    self.soundFilePopOutView = soundFilePopOutView;
    [self.tableView addSubviewToPopOutCell:soundFilePopOutView];
    
    UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [soundFilePopOutView addSubview:viewBtn];
    [viewBtn setTitle:NSLocalizedString(@"View", nil) forState:UIControlStateNormal];
    [viewBtn addTarget:self action:@selector(onViewBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    viewBtn.frame = CGRectMake(10, 5, (self.tableView.frame.size.width - 30) / 2, 40);
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [soundFilePopOutView addSubview:editBtn];
    [editBtn setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(onEditBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(10 + (self.tableView.frame.size.width - 30) / 2 + 10, 
                               5, 
                               (self.tableView.frame.size.width - 30) / 2, 
                               40);
    
    UIView *otherFilePopOutView = [[[UIView alloc] initWithFrame:
                                    CGRectMake(0, 0, self.tableView.frame.size.width, 60)] autorelease];
    self.otherFilePopOutView = otherFilePopOutView;
    
    UIButton *openBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [otherFilePopOutView addSubview:openBtn];
    [openBtn setTitle:NSLocalizedString(@"Open", nil) forState:UIControlStateNormal];
    [openBtn addTarget:self action:@selector(onOpenBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *editBtnItem = [[[UIBarButtonItem alloc] init] autorelease];
    editBtnItem.title = NSLocalizedString(@"Edit", nil);
    editBtnItem.target = self;
    editBtnItem.action = @selector(onEditBtnItemTapped:);
    editBtnItem.style = UIBarButtonItemStyleBordered;
    self.navigationItem.leftBarButtonItem = editBtnItem;
    
    self.nowPlayingBtn = [[[UIBarButtonItem alloc] init] autorelease];
    self.nowPlayingBtn.title = NSLocalizedString(@"now_playing", nil);
    self.nowPlayingBtn.style = UIBarButtonItemStyleDone;
    self.nowPlayingBtn.target = self;
    self.nowPlayingBtn.action = @selector(onNowPlayingBtnTapped);
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(onApplicationBecomeActiveNotification:) 
                                                 name:UIApplicationDidBecomeActiveNotification 
                                               object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadSoundList];
}

#pragma mark - private methods
- (NSString *)soundFileAtIndex:(NSInteger)index
{
    return [[CommonUtils documentPath] stringByAppendingPathComponent:[self.soundFileList objectAtIndex:index]];
}

- (void)reloadSoundList
{
    self.soundFileList = [NSMutableArray arrayWithArray:[CommonUtils fileNameListInDocumentPath]];
    [self.tableView.tableView reloadData];
}

#pragma mark - events
- (void)onEditBtnTapped
{
    NSString *soundFilePath = [self soundFileAtIndex:self.tableView.selectedCellIndex];
    SoundSubListEditViewController *vc = [[SoundSubListEditViewController alloc] initWithSoundFilePath:soundFilePath];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onNowPlayingBtnTapped
{
    [self.navigationController pushViewController:[PlayViewController sharedInstance] animated:YES];
}

- (void)onViewBtnTapped
{
    NSString *soundFilePath = [self soundFileAtIndex:self.tableView.selectedCellIndex];
    SoundSubPlayListViewController *vc = [[SoundSubPlayListViewController alloc] initWithSoundFilePath:soundFilePath];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onEditBtnItemTapped:(UIBarButtonItem *)editBtnItem
{
    editBtnItem.style = self.tableView.tableView.editing ? UIBarButtonItemStyleBordered : UIBarButtonItemStyleDone;
    editBtnItem.title = self.tableView.tableView.editing ? NSLocalizedString(@"Edit", nil) : NSLocalizedString(@"Done", nil);
    [self.tableView.tableView setEditing:!self.tableView.tableView.editing animated:YES];
}

- (void)onApplicationBecomeActiveNotification:(NSNotification *)n
{
    [self reloadSoundList];
}

- (void)onPlayerDidStartPlayNotification:(NSNotification *)n
{
    self.navigationItem.rightBarButtonItem = self.nowPlayingBtn;
}

- (void)onPlayerDidStopNotification:(NSNotification *)n
{
    self.navigationItem.rightBarButtonItem = nil;
}

#pragma mark - PopOutTableViewDelegate
- (BOOL)popOutTableView:(PopOutTableView *)tableView shouldShowPopOutCellAtIndex:(NSInteger)index
{
    NSString *soundFilePath = [self soundFileAtIndex:index];
    
    if(![[soundFilePath lowercaseString] hasSuffix:@".mp3"]){
        ViewTextViewController *vc = [[ViewTextViewController alloc] initWithTextFilePath:soundFilePath];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
        return NO;
    }
    return YES;
}

- (void)popOutTableView:(PopOutTableView *)popOutTableView deleteRowAtIndex:(NSInteger)index
{
    NSString *fileName = [self.soundFileList objectAtIndex:index];
    NSString *filePath = [[CommonUtils documentPath] stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
    [self.soundFileList removeObjectAtIndex:index];
    [popOutTableView.tableView beginUpdates];
    [popOutTableView.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] 
                                     withRowAnimation:UITableViewRowAnimationFade];
    [popOutTableView.tableView endUpdates];
}

- (void)popOutTableView:(PopOutTableView *)popOutTableView willBeginEditingAtIndex:(NSInteger)index
{
    if(index == self.tableView.selectedCellIndex){
        [self.tableView collapsePopOutCell];
    }
}

- (NSInteger)numberOfRowsInPopOutTableView:(PopOutTableView *)popOutTableView
{
    return self.soundFileList.count;
}

- (UITableViewCell *)popOutTableView:(PopOutTableView *)popOutTableView cellForRowAtIndex:(NSInteger)index
{
    static NSString *identifier = @"id";
    UITableViewCell *cell = [popOutTableView.tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                      reuseIdentifier:identifier] autorelease];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    cell.textLabel.text = [self.soundFileList objectAtIndex:index];
    
    return cell;
}

@end
