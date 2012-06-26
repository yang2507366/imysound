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

@interface SoundListViewController () <PopOutTableViewDelegate>

@property(nonatomic, retain)PopOutTableView *tableView;
@property(nonatomic, retain)NSArray *soundFileList;

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
