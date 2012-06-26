//
//  PopOutTableView.m
//  imyvoa
//
//  Created by yzx on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopOutTableView.h"

@interface PopOutTableView () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic)NSInteger insertedIndex;
@property(nonatomic, readonly)UITableViewCell *popOutCell;

@end

@implementation PopOutTableView

@synthesize delegate = _delegate;

@synthesize tableView = _tableView;
@synthesize insertedIndex = _insertedIndex;
@synthesize popOutCell = _popOutCell;

- (void)dealloc
{
    [_tableView release];
    [_popOutCell release];
    [super dealloc];
}

- (id)init
{
    self = [self initWithFrame:CGRectZero];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.insertedIndex = -1;
    _tappingIndex = -1;
    
    _popOutCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                         reuseIdentifier:@"popout"];
    self.popOutCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];
    
    return self;
}

- (void)layoutSubviews
{
    self.tableView.frame = self.bounds;
    [self.tableView reloadData];
}

#pragma mark - private methods
- (void)scrollToBottom
{
    NSInteger lastRow = [self tableView:self.tableView numberOfRowsInSection:0] - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath 
                          atScrollPosition:UITableViewScrollPositionTop 
                                  animated:YES];
}

- (void)popOutViewWillShow
{
//    CGFloat maxHeight = self.popOutCell.frame.size.height;
//    for(UIView *subview in [self.popOutCell.contentView subviews]){
//        if(subview.frame.origin.y + subview.frame.size.height > maxHeight){
//            maxHeight = subview.frame.origin.y + subview.frame.size.height;
//        }
//    }
//    CGRect frame = self.popOutCell.frame;
//    frame.size.height = maxHeight;
//    self.popOutCell.frame = frame;
    
    if([self.delegate respondsToSelector:@selector(popOutCellWillShowAtPopOutTableView:)]){
        [self.delegate popOutCellWillShowAtPopOutTableView:self];
    }
}

- (void)hidePopOutCell
{
    [self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.23f];
    NSIndexPath *deleteIndexPath = [NSIndexPath indexPathForRow:self.insertedIndex inSection:0];
    self.insertedIndex = -1;
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:deleteIndexPath] 
                          withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

#pragma mark - instance methods
- (NSInteger)selectedCellIndex
{
    if(self.insertedIndex == -1){
        return -1;
    }
    return self.insertedIndex - 1;
}

- (NSInteger)tappingIndex
{
    return _tappingIndex;
}

- (void)addSubviewToPopOutCell:(UIView *)view
{
    [self.popOutCell addSubview:view];
    CGRect frame = self.popOutCell.frame;
    if(frame.size.height < view.frame.size.height + view.frame.origin.y){
        frame.size.height = view.frame.size.height + view.frame.origin.y;
    }
    self.popOutCell.frame = frame;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger targetRow = indexPath.row;
    if(self.insertedIndex != -1){
        if(indexPath.row == self.insertedIndex){
            return self.popOutCell.frame.size.height;
        }else if(indexPath.row > self.insertedIndex){
            --targetRow;
        }
    }
    if([self.delegate respondsToSelector:@selector(popOutTableView:heightForRowAtIndex:)]){
        return [self.delegate popOutTableView:self heightForRowAtIndex:targetRow];
    }
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.insertedIndex == -1){
        if(indexPath.row + 1 > [self tableView:tableView numberOfRowsInSection:0] - 2){
            [self performSelector:@selector(scrollToBottom) withObject:nil afterDelay:0.01f];
        }
        _tappingIndex = indexPath.row;
        [self.tableView reloadData];
        
        self.insertedIndex = indexPath.row + 1;
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.insertedIndex inSection:0];
        [self popOutViewWillShow];
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }else if(self.insertedIndex == indexPath.row){
        
    }else{
        if(self.insertedIndex - 1 != indexPath.row){
            NSInteger newSelectIndex = indexPath.row;
            if(newSelectIndex > self.insertedIndex){
                --newSelectIndex;
            }
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:newSelectIndex inSection:0];
            
            _tappingIndex = -1;
            self.insertedIndex = -1;
            [tableView reloadData];
            
            [self tableView:tableView didSelectRowAtIndexPath:newIndexPath];
        }else{
            _tappingIndex = -1;
            [self.tableView reloadData];
            [self performSelector:@selector(hidePopOutCell) withObject:nil afterDelay:0.02];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger nums = 0;
    if([self.delegate respondsToSelector:@selector(numberOfRowsInPopOutTableView:)]){
        nums = [self.delegate numberOfRowsInPopOutTableView:self];
    }
    if(nums == 0){
        return 0;
    }
    if(self.insertedIndex != -1){
        nums += 1;
    }
    return nums;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger targetRow = indexPath.row;
    if(self.insertedIndex != -1){
        if(indexPath.row == self.insertedIndex){
            return self.popOutCell;
        }else if(indexPath.row > self.insertedIndex){
            --targetRow;
        }
    }
    UITableViewCell *cell = [self.delegate popOutTableView:self cellForRowAtIndex:targetRow];
    
    return cell;
}


@end
