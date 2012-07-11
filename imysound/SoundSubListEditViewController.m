//
//  SoundSubEditViewController.m
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubListEditViewController.h"
#import "SoundSubManager.h"
#import "SoundSub.h"
#import "SoundSubEditViewController.h"

@interface SoundSubListEditViewController ()

@property(nonatomic, copy)NSString *soundFilePath;
@property(nonatomic, retain)NSMutableArray *soundSubList;

@end

@implementation SoundSubListEditViewController

@synthesize soundFilePath = _soundFilePath;
@synthesize soundSubList = _soundSubList;

- (void)dealloc
{
    [_soundFilePath release];
    [_soundSubList release];
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
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)] autorelease];
    self.tableView.tableHeaderView = headerView;
    
    UILabel *titleLabel = [[[UILabel alloc] init] autorelease];
    [headerView addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    titleLabel.text = [self.soundFilePath lastPathComponent];
    titleLabel.frame = CGRectMake(10, 0, headerView.frame.size.width - 20, headerView.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSArray *existSoundSubList = [[SoundSubManager sharedInstance] subListForIdentifier:self.soundFilePath];
    if(existSoundSubList){
        self.soundSubList = [NSMutableArray arrayWithArray:existSoundSubList];
    }else{
        self.soundSubList = [NSMutableArray array];
    }
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == self.soundSubList.count){
        SoundSubEditViewController *vc = [[[SoundSubEditViewController alloc] 
                                           initWithSoundFilePath:self.soundFilePath] autorelease];
        UINavigationController *nc = [[[UINavigationController alloc] 
                                       initWithRootViewController:vc] autorelease];
        [self presentModalViewController:nc animated:YES];
    }
}

 - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soundSubList.count + 1;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.soundSubList removeObjectAtIndex:indexPath.row];
        [[SoundSubManager sharedInstance] setSubListWithArray:self.soundSubList forIdentifier:self.soundFilePath];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifierSoundSub = @"sound_sub";
    static NSString *cellIdentifierAddSoundBtn = @"add_sound_btn";
    
    UITableViewCell *cell = nil;
    if(indexPath.row == self.soundSubList.count){
        // add btn
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierAddSoundBtn];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:cellIdentifierAddSoundBtn] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        cell.textLabel.text = NSLocalizedString(@"add_sound_sub", nil);
    }else{
        // sound sub item
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifierSoundSub];
        if(!cell){
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:cellIdentifierSoundSub] autorelease];
            cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
        }
        SoundSub *sub = [self.soundSubList objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%d.%@", indexPath.row, [sub description]];
    }
    
    return cell;
}

@end
