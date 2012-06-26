//
//  BaseViewController.m
//  imysound
//
//  Created by yzx on 12-6-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaseViewController.h"

@implementation BaseViewController

- (CGRect)fullBounds
{
    CGRect frame = self.view.bounds;
    frame.size.height -= self.navigationController.navigationBar.frame.size.height;
    frame.size.height -= self.tabBarController.tabBar.frame.size.height;
    
    return frame;
}

@end
