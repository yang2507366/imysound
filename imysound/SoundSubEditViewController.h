//
//  SoundSubEditViewController.h
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface SoundSubEditViewController : BaseViewController {
    NSString *_soundFilePath;
    
    UIView *_topControlView;
    UILabel *_currentTimeLabel;
    UILabel *_totalTimeLabel;
    UISlider *_positionSilder;
    
    BOOL _positionSilderTouching;
}

- (id)initWithSoundFilePath:(NSString *)soundFilePath;

@end
