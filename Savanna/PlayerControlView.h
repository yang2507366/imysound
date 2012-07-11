//
//  PlayerControlView.h
//  imysound
//
//  Created by gewara on 12-7-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerControlView : UIView {
    UIView *_topBlackBar;
    UIView *_bottomLine;
    UILabel *_currentTimeLabel;
    UILabel *_totalTimeLabel;
    UISlider *_positionSilder;
    
    BOOL _positionSilderTouching;
}

@end
