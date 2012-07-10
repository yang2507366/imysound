//
//  Player.h
//  imyvoa
//
//  Created by gewara on 12-6-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AVAudioPlayer;

OBJC_EXPORT NSString *kPlayerDidStartPlayNotification;
OBJC_EXPORT NSString *kPlayerDidPauseNotification;
OBJC_EXPORT NSString *kPlayerDidStopNotification;
OBJC_EXPORT NSString *kPlayerDidChangeSoundNotification;

@interface Player : NSObject {
@private
    AVAudioPlayer *_audioPlayer;
    
    NSString *_currentSoundFilePath;
}

@property(nonatomic, readonly)NSString *currentSoundFilePath;

+ (Player *)sharedInstance;

- (void)playSoundAtFilePath:(NSString *)soundFilePath;
- (void)pause;
- (void)resume;
- (void)stop;
- (BOOL)playing;
- (NSTimeInterval)duration;
- (NSTimeInterval)currentTime;
- (void)setCurrentTime:(NSTimeInterval)time;

@end
