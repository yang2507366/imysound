//
//  PopOutTableView.h
//  imyvoa
//
//  Created by yzx on 12-6-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PopOutTableView;

@protocol PopOutTableViewDelegate <NSObject>

@required
- (NSInteger)numberOfRowsInPopOutTableView:(PopOutTableView *)popOutTableView;
- (UITableViewCell *)popOutTableView:(PopOutTableView *)popOutTableView cellForRowAtIndex:(NSInteger)index;

@optional
- (void)popOutCellWillShowAtPopOutTableView:(PopOutTableView *)tableView;
- (CGFloat)popOutTableView:(PopOutTableView *)popOutTableView heightForRowAtIndex:(NSInteger)index;

@end

@interface PopOutTableView : UIView {
@private
    id<PopOutTableViewDelegate> _delegate;
    
    UITableView *_tableView;
    NSInteger _insertedIndex;
    NSInteger _tappingIndex;
    
    UITableViewCell *_popOutCell;
    
}

@property(nonatomic, assign)id<PopOutTableViewDelegate> delegate;

@property(nonatomic, readonly)UITableView *tableView;

- (void)addSubviewToPopOutCell:(UIView *)view;

- (NSInteger)selectedCellIndex;
- (NSInteger)tappingIndex;

@end
