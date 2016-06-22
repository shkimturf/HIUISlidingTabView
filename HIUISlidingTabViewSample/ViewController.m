//
//  ViewController.m
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "ViewController.h"

#import "SampleLayoutManager.h"
#import "SampleTextBarButtonItem.h"
#import "SampleContentView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _slidingTabView = [[HIUISlidingTabView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame)) layoutManager:[[SampleLayoutManager alloc] init]];
    _slidingTabView.dataSource = self;
    _slidingTabView.delegate = self;
    _slidingTabView.backgroundColor = [UIColor clearColor];
    _slidingTabView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.view addSubview:_slidingTabView];
}

#pragma mark - HIUISlidingTabView dataSource

- (NSUInteger)numberOfContentsInSlidingTabView:(HIUISlidingTabView *)view {
    return 3;
}

- (HIUIBarButtonItem *)slidingTabView:(HIUISlidingTabView *)view barButtonItemAtIndex:(NSUInteger)index {
    NSString* title = [NSString stringWithFormat:@"%d", index];
    
    SampleTextBarButtonItem* item = [SampleTextBarButtonItem buttonItemWithTitle:title];
    item.button.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.view.bounds) / [self numberOfContentsInSlidingTabView:view], view.layoutManager.menuHeight - view.layoutManager.focusBarHeight);
    return item;
}

- (UIView *)focusBarViewInSlidingTabView:(HIUISlidingTabView *)view {
    CGFloat height = 2.f;
    
    UIView* focusBar = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(_slidingTabView.bounds) / [self numberOfContentsInSlidingTabView:_slidingTabView], height)];
    focusBar.backgroundColor = [UIColor redColor];
    
    return focusBar;
}

- (UIView<HIUISlidingTabViewContentView>*)slidingTabView:(HIUISlidingTabView *)view contentViewAtIndex:(NSUInteger)index {
    SampleContentView* contentView = [[SampleContentView alloc] initWithFrame:CGRectZero];
    contentView.label.text = [NSString stringWithFormat:@"%d", index];
    return contentView;
}

@end
