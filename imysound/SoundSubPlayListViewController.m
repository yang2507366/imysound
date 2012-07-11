//
//  SoundSubPlayListViewController.m
//  imysound
//
//  Created by gewara on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SoundSubPlayListViewController.h"
#import "SoundSub.h"
#import "SoundSubManager.h"
#import "CommonUtils.h"

@interface SoundSubPlayListViewController ()

@property(nonatomic, retain)NSString *soundFilePath;
@property(nonatomic, retain)NSArray *soundSubList;

@end

@implementation SoundSubPlayListViewController

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
    
    self.soundFilePath = soundFilePath;
    self.title = [self.soundFilePath lastPathComponent];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.soundSubList = [[SoundSubManager sharedInstance] subListForIdentifier:self.soundFilePath];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soundSubList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle 
                                       reuseIdentifier:identifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    SoundSub *sub = [self.soundSubList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = sub.title;
    
    NSInteger minute = sub.beginTime / 60;
    NSInteger second = (NSInteger)sub.beginTime % 60;
    NSString *beginTime = [NSString stringWithFormat:@"%@:%@", [CommonUtils formatTimeNumber:minute], [CommonUtils formatTimeNumber:second]];
    
    minute = sub.endTime / 60;
    second = (NSInteger)sub.endTime % 60;
    NSString *endTime = [NSString stringWithFormat:@"%@:%@", [CommonUtils formatTimeNumber:minute], [CommonUtils formatTimeNumber:second]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@", beginTime, endTime];
    
    return cell;
}

@end
