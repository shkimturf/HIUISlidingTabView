//
//  HIUISlidingTabViewLayoutManager.h
//  HIDevKit
//
//  Created by Sunhong Kim on 2014. 9. 29..
//  Copyright (c) 2014년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    HIUISlidingTabMenuPositionTop = 0,
    HIUISlidingTabMenuPositionBottom,
};
typedef NSInteger HIUISlidingTabMenuPosition;

@protocol HIUISlidingTabViewLayoutManager <NSObject>

@property (nonatomic, assign, readonly) CGFloat menuHeight;
@property (nonatomic, assign, readonly) HIUISlidingTabMenuPosition menuPosition;
@property (nonatomic, assign, readonly) BOOL useFocusBar;

@optional
@property (nonatomic, assign, readonly) CGFloat focusBarHeight;
@property (nonatomic, strong, readonly) UIColor* focusBarColor;

@end
