//
//  ViewTextViewController.h
//  imysound
//
//  Created by gewara on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"
#import "KeyValueManager.h"

@interface ViewTextViewController : BaseViewController {
    NSString *_textFilePath;
    id<KeyValueManager> _keyValueMgr;
    
    UITextView *_textView;
    UIBarButtonItem *_nowPlayingBtn;
}

- (id)initWithTextFilePath:(NSString *)filePath;

@end
