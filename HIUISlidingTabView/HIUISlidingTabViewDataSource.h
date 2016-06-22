//
//  HIUISlidingTabViewDataSource.h
//  HIDevKit
//
//  Created by Sunhong Kim on 2014. 9. 29..
//  Copyright (c) 2014년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HIUISlidingTabViewContentView.h"

@class HIUISlidingTabView, HIUIBarButtonItem;
@protocol HIUISlidingTabViewDataSource <NSObject>

- (NSUInteger)numberOfContentsInSlidingTabView:(HIUISlidingTabView*)view;
- (HIUIBarButtonItem*)slidingTabView:(HIUISlidingTabView*)view barButtonItemAtIndex:(NSUInteger)index;
- (UIView<HIUISlidingTabViewContentView>*)slidingTabView:(HIUISlidingTabView*)view contentViewAtIndex:(NSUInteger)index;

@optional
- (UIView*)focusBarViewInSlidingTabView:(HIUISlidingTabView*)view;

@end
