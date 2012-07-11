//
//  SoundSubEditViewController.h
//  imysound
//
//  Created by yzx on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@class PlayerControlView;

@interface SoundSubEditViewController : BaseViewController {
    NSString *_soundFilePath;
    
    PlayerControlView *_playerControlView;
}

- (id)initWithSoundFilePath:(NSString *)soundFilePath;

@end
