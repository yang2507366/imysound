//
//  ViewTextViewController.m
//  imysound
//
//  Created by gewara on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewTextViewController.h"
#import "KeyValueManagerFactory.h"

@interface ViewTextViewController () <UITextViewDelegate>

@property(nonatomic, copy)NSString *textFilePath;
@property(nonatomic, retain)id<KeyValueManager> keyValueMgr;

@property(nonatomic, retain)UITextView *textView;

@end

@implementation ViewTextViewController

@synthesize textFilePath = _textFilePath;
@synthesize keyValueMgr = _keyValueMgr;

@synthesize textView = _textView;

- (void)dealloc
{
    [_textFilePath release];
    [_keyValueMgr release];
    
    [_textView release];
    [super dealloc];
}

- (id)initWithTextFilePath:(NSString *)filePath
{
    self = [super init];
    
    self.textFilePath = filePath;
    self.keyValueMgr = [KeyValueManagerFactory createLocalDBKeyValueManagerWithName:@"text_position_"];
    
    self.title = [self.textFilePath lastPathComponent];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height -= self.navigationController.navigationBar.frame.size.height;
    self.textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    [self.view addSubview:self.textView];
    self.textView.editable = NO;
    self.textView.font = [UIFont systemFontOfSize:14.0f];
    
    self.textView.text = [NSString stringWithContentsOfFile:self.textFilePath encoding:NSUTF8StringEncoding error:nil];
    self.textView.delegate = self;
    
    CGFloat positionY = [[self.keyValueMgr valueForKey:self.textFilePath] floatValue];
    [self.textView scrollRectToVisible:CGRectMake(0, positionY, self.textView.bounds.size.width, self.textView.bounds.size.height) 
                              animated:NO];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - UITextViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.keyValueMgr setValue:[NSString stringWithFormat:@"%f", scrollView.contentOffset.y] forKey:self.textFilePath];
}

@end
