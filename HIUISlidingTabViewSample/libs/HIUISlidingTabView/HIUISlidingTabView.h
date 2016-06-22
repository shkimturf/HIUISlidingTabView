//
//  HIUISlidingTabView.h
//  HIDevKit
//
//  Created by Sunhong Kim on 2014. 9. 29..
//  Copyright (c) 2014년 Sunhong Kim. All rights reserved.
//

#import "HIUISlidingTabViewDataSource.h"
#import "HIUISlidingTabViewDelegate.h"
#import "HIUISlidingTabViewLayoutManager.h"

@interface HIUISlidingTabView : UIView <UIScrollViewDelegate>
{
    UIToolbar* _menuToolBar;
    
    UIScrollView* _focusBarScrollView;
    UIView* _focusBar;
    CGPoint _focusBarPoint;
    
    UIScrollView* _contentScrollView;
    
    BOOL _shouldConstructItemViews;
}

@property (nonatomic, assign) id<HIUISlidingTabViewDataSource> dataSource;
@property (nonatomic, assign) id<HIUISlidingTabViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIToolbar* menuToolBar;
@property (nonatomic, strong, readonly) UIScrollView* focusBarScrollView;
@property (nonatomic, strong, readonly) UIScrollView* contentScrollView;

@property (nonatomic, strong, readonly) id<HIUISlidingTabViewLayoutManager> layoutManager;
@property (nonatomic, strong, readonly) NSArray* contentViews;

@property (nonatomic, assign) NSInteger selectedItemIndex;

- (id)initWithFrame:(CGRect)frame layoutManager:(id<HIUISlidingTabViewLayoutManager>)layoutManager;
- (void)reloadData;

- (void)resetContentViews;
- (void)resetContentViewAtIndex:(NSUInteger)index;

@end
