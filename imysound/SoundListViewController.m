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

@interface SoundListViewController () <PopOutTableViewDelegate>

@property(nonatomic, retain)PopOutTableView *tableView;
@property(nonatomic, retain)NSArray *soundFileList;

- (NSString *)soundFileAtIndex:(NSInteger)index;

@end

@implementation SoundListViewController

@synthesize tableView = _tableView;
@synthesize soundFileList = _soundFileList;

- (void)dealloc
{
    [_tableView release];
    [_soundFileList release];
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
    
    self.soundFileList = [CommonUtils fileNameListInDocumentPath];
    
    self.tableView = [[[PopOutTableView alloc] initWithFrame:self.fullBounds] autorelease];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    
    UIView *popOutView = [[[UIView alloc] initWithFrame:
                           CGRectMake(0, 0, self.tableView.frame.size.width, 50)] autorelease];
    [self.tableView addSubviewToPopOutCell:popOutView];
    
    UIButton *viewBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popOutView addSubview:viewBtn];
    [viewBtn setTitle:NSLocalizedString(@"View", nil) forState:UIControlStateNormal];
    [viewBtn addTarget:self action:@selector(onViewBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    viewBtn.frame = CGRectMake(10, 5, (self.tableView.frame.size.width - 30) / 2, 40);
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [popOutView addSubview:editBtn];
    [editBtn setTitle:NSLocalizedString(@"Edit", nil) forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(onEditBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    editBtn.frame = CGRectMake(10 + (self.tableView.frame.size.width - 30) / 2 + 10, 
                               5, 
                               (self.tableView.frame.size.width - 30) / 2, 
                               40);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - private methods
- (NSString *)soundFileAtIndex:(NSInteger)index
{
    return [[CommonUtils documentPath] stringByAppendingPathComponent:[self.soundFileList objectAtIndex:index]];
}

#pragma mark - events
- (void)onEditBtnTapped
{
    NSString *soundFilePath = [self soundFileAtIndex:self.tableView.selectedCellIndex];
    SoundSubListEditViewController *vc = [[SoundSubListEditViewController alloc] initWithSoundFilePath:soundFilePath];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onViewBtnTapped
{
    NSString *soundFilePath = [self soundFileAtIndex:self.tableView.selectedCellIndex];
    SoundSubPlayListViewController *vc = [[SoundSubPlayListViewController alloc] initWithSoundFilePath:soundFilePath];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - PopOutTableViewDelegate
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
