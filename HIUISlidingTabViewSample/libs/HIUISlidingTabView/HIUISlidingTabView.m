//
//  HIUISlidingTabView.m
//  HIDevKit
//
//  Created by Sunhong Kim on 2014. 9. 29..
//  Copyright (c) 2014년 Sunhong Kim. All rights reserved.
//

#import "HIUISlidingTabView.h"

#import "HIUIBarButtonItem.h"

@interface HIUISlidingTabView ()
@property (nonatomic, strong) id<HIUISlidingTabViewLayoutManager> layoutManager;
@property (nonatomic, strong) UIView* focusBar;
@end

@implementation HIUISlidingTabView

- (instancetype)initWithFrame:(CGRect)frame {
    NSAssert(NO, @"Not supported use initWithFrame:layoutManager");
    return nil;
}

- (void)awakeFromNib {
    NSAssert(NO, @"Not supported use initWithFrame:layoutManager");
}

- (id)initWithFrame:(CGRect)frame layoutManager:(id<HIUISlidingTabViewLayoutManager>)layoutManager {
    self = [super initWithFrame:frame];
    if (self) {
        self.layoutManager = layoutManager;
        
        [self addSubview:self.menuToolBar];
        [self addSubview:self.contentScrollView];
        if ( self.layoutManager.useFocusBar ) {
            [self addSubview:self.focusBarScrollView];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        _shouldConstructItemViews = YES;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
}

#pragma mark - properties

- (NSInteger)selectedItemIndex {
    return (int)(self.contentScrollView.contentOffset.x / CGRectGetWidth(self.bounds));
}

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex {
    [self.contentScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.bounds) * selectedItemIndex, 0.f) animated:YES];

    if ( [self.delegate respondsToSelector:@selector(slidingTabView:didSelectMenuAtIndex:)] ) {
        [self.delegate slidingTabView:self didSelectMenuAtIndex:selectedItemIndex];
    }
    
    NSUInteger index = [self.contentScrollView.subviews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        if ( [obj conformsToProtocol:@protocol(HIUISlidingTabViewContentView) ] ) {
            UIView<HIUISlidingTabViewContentView>* contentView = obj;
            return (selectedItemIndex == contentView.tag);
        }
        
        return NO;
    }];
    NSAssert(NSNotFound != index, @"Cannot find content view at index %ld", (long)selectedItemIndex);
    
    UIView<HIUISlidingTabViewContentView>* contentView = [self.contentScrollView.subviews objectAtIndex:index];
    if ( [contentView respondsToSelector:@selector(loadContentsIfNotLoaded)] ) {
        [contentView loadContentsIfNotLoaded];
    }
    
    [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [obj conformsToProtocol:@protocol(HIUISlidingTabViewContentView) ] ) {
            UIView<HIUISlidingTabViewContentView>* contentView = obj;
            if ( [contentView respondsToSelector:@selector(setScrollsToTop:)] ) {
                [contentView setScrollsToTop:(selectedItemIndex == contentView.tag)];
            }
        }
    }];
    
    [self.menuToolBar.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [obj isKindOfClass:[HIUIBarButtonItem class]] ) {
            HIUIBarButtonItem* item = obj;
            item.selected = (selectedItemIndex == item.tag);
        }
    }];
    
    CGFloat position = (self.contentScrollView.contentOffset.x / CGRectGetWidth(self.bounds));
    _focusBarScrollView.contentOffset = CGPointMake(-position * CGRectGetWidth(_focusBar.frame), 0.f);
}

- (UIToolbar *)menuToolBar {
    if ( nil == _menuToolBar ) {
        _menuToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), self.layoutManager.menuHeight)];
    }
    
    return _menuToolBar;
}

- (UIScrollView *)focusBarScrollView {
    if ( NO == self.layoutManager.useFocusBar ) {
        return nil;
    }
    
    if ( nil == _focusBarScrollView ) {
        NSAssert([self.layoutManager respondsToSelector:@selector(focusBarHeight)], @"Should implement focusBarHeight");
        _focusBarScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), self.layoutManager.focusBarHeight)];
        _focusBarScrollView.backgroundColor = [UIColor clearColor];
        _focusBarScrollView.userInteractionEnabled = NO;
        _focusBarScrollView.scrollsToTop = NO;
    }
    
    return _focusBarScrollView;
}

- (UIScrollView *)contentScrollView {
    if ( nil == _contentScrollView ) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), 0.f)];
        _contentScrollView.delegate = self;
        _contentScrollView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.scrollsToTop = NO;
        [self addSubview:_contentScrollView];
    }
    
    return _contentScrollView;
}

- (void)setDataSource:(id<HIUISlidingTabViewDataSource>)dataSource {
    _dataSource = dataSource;

    if ( self.layoutManager.useFocusBar ) {
        if ( [self.dataSource respondsToSelector:@selector(focusBarViewInSlidingTabView:)] ) {
            self.focusBar = [self.dataSource focusBarViewInSlidingTabView:self];
        } else {
            self.focusBar = [[UIView alloc] initWithFrame:CGRectZero];
            if ( [self.layoutManager respondsToSelector:@selector(focusBarColor)] ) {
                self.focusBar.backgroundColor = self.layoutManager.focusBarColor;
            }
        }
        
        NSUInteger numberOfContents = [self.dataSource numberOfContentsInSlidingTabView:self];
        self.focusBar.frame = CGRectMake(0.f, 0.f, floorf(CGRectGetWidth(self.bounds) / numberOfContents), self.layoutManager.focusBarHeight);
        [self.focusBarScrollView addSubview:self.focusBar];
    }
    
    NSUInteger numberOfContents = [self.dataSource numberOfContentsInSlidingTabView:self];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for ( int i = 0 ; i < numberOfContents ; i++ ) {
        UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        space.width = (i == 0 ? -16.f : -10.f);
        [items addObject:space];
        
        HIUIBarButtonItem* item = [self.dataSource slidingTabView:self barButtonItemAtIndex:i];
        item.target = self;
        item.action = @selector(onMenuButton:);
        item.tag = i;
        [items addObject:item];
    }
    
    [_menuToolBar setItems:items];
}

- (NSArray *)contentViews {
    return self.contentScrollView.subviews;
}

#pragma mark - layout

- (void)reloadData {
    _shouldConstructItemViews = YES;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ( NO == _shouldConstructItemViews ) {
        return;
    }
    
    NSUInteger numberOfContents = [self.dataSource numberOfContentsInSlidingTabView:self];
    
    // frames
    switch ( self.layoutManager.menuPosition ) {
        case HIUISlidingTabMenuPositionTop:
        {
            if ( !self.layoutManager.useFocusBar ) {
                self.menuToolBar.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), self.layoutManager.menuHeight);
                CGFloat verticalOffset = CGRectGetMaxY(self.menuToolBar.frame);
                if ( self.layoutManager.useFocusBar ) {
                    self.focusBarScrollView.frame = CGRectMake(0.f, CGRectGetMaxY(self.menuToolBar.frame), CGRectGetWidth(self.bounds), self.layoutManager.focusBarHeight);
                    verticalOffset = CGRectGetMaxY(self.focusBarScrollView.frame);
                }
                self.contentScrollView.frame = CGRectMake(0.f, verticalOffset, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - verticalOffset);
            } else {
                self.menuToolBar.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), self.layoutManager.menuHeight);
                if ( self.layoutManager.useFocusBar ) {
                    self.focusBarScrollView.frame = CGRectMake(0.f, CGRectGetMaxY(self.menuToolBar.frame) - self.layoutManager.focusBarHeight, CGRectGetWidth(self.bounds), self.layoutManager.focusBarHeight);
                }
                self.contentScrollView.frame = CGRectMake(0.f, CGRectGetMaxY(self.menuToolBar.frame), CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetMaxY(self.menuToolBar.frame));
            }
        }
            break;
        case HIUISlidingTabMenuPositionBottom:
        {
            if ( !self.layoutManager.useFocusBar ) {
            self.menuToolBar.frame = CGRectMake(0.f, CGRectGetHeight(self.bounds) - self.layoutManager.menuHeight, CGRectGetWidth(self.bounds), self.layoutManager.menuHeight);
            CGFloat verticalOffset = CGRectGetMinY(self.menuToolBar.frame);
            if ( self.layoutManager.useFocusBar ) {
                self.focusBarScrollView.frame = CGRectMake(0.f, CGRectGetMinY(self.menuToolBar.frame) - self.layoutManager.focusBarHeight, CGRectGetWidth(self.bounds), self.layoutManager.focusBarHeight);
                verticalOffset = CGRectGetMinY(self.focusBarScrollView.frame);
            }
            self.contentScrollView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - verticalOffset);
            } else {
                self.menuToolBar.frame = CGRectMake(0.f, CGRectGetHeight(self.bounds) - self.layoutManager.menuHeight, CGRectGetWidth(self.bounds), self.layoutManager.menuHeight);
                if ( self.layoutManager.useFocusBar ) {
                    self.focusBarScrollView.frame = CGRectMake(0.f, CGRectGetMinY(self.menuToolBar.frame), CGRectGetWidth(self.bounds), self.layoutManager.focusBarHeight);
                }
                self.contentScrollView.frame = CGRectMake(0.f, 0.f, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - CGRectGetHeight(self.menuToolBar.frame));
            }
        }
            break;
    }
    
    // content sizes
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) * numberOfContents, CGRectGetHeight(self.contentScrollView.frame));
    
    // contents
    [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [((UIView*)obj) removeFromSuperview];
    }];
    
    for ( int i = 0 ; i < numberOfContents ; i++ ) {
        UIView* contentView = [self.dataSource slidingTabView:self contentViewAtIndex:i];
        contentView.frame = CGRectMake(CGRectGetWidth(self.bounds) * i, 0.f, CGRectGetWidth(self.contentScrollView.frame), CGRectGetHeight(self.contentScrollView.frame));
        contentView.tag = i;
        [self.contentScrollView addSubview:contentView];
    }
    [self.contentScrollView setContentOffset:CGPointZero];
    [self setSelectedItemIndex:0];
    
    _shouldConstructItemViews = NO;
}

#pragma mark - user interactions

- (void)onMenuButton:(id)sender {
    UIBarButtonItem* item = sender;
    
    [self setSelectedItemIndex:item.tag];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat position = (self.contentScrollView.contentOffset.x / CGRectGetWidth(self.bounds));
    _focusBarScrollView.contentOffset = CGPointMake(-position * CGRectGetWidth(_focusBar.frame), 0.f);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger index = round(scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame));
    [self setSelectedItemIndex:index];
}

#pragma mark - notifications

- (void)didReceiveMemoryWarning:(NSNotification*)notification {
    [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [obj conformsToProtocol:@protocol(HIUISlidingTabViewContentView) ] ) {
            UIView<HIUISlidingTabViewContentView>* contentView = obj;
            if ( self.selectedItemIndex == contentView.tag ) {
                return;
            }
            
            if ( [contentView respondsToSelector:@selector(clearContents)] ) {
                [contentView clearContents];
            }
        }
    }];
}

- (void)resetContentViews {
    [self.contentScrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ( [obj conformsToProtocol:@protocol(HIUISlidingTabViewContentView) ] ) {
            UIView<HIUISlidingTabViewContentView>* contentView = obj;
            if ( [contentView respondsToSelector:@selector(clearContents)] ) {
                [contentView clearContents];
            }
        }
    }];
    
    self.selectedItemIndex = self.selectedItemIndex;
}

- (void)resetContentViewAtIndex:(NSUInteger)index {
    UIView<HIUISlidingTabViewContentView>* contentView = [self.contentScrollView.subviews objectAtIndex:index];
    if ( [contentView respondsToSelector:@selector(clearContents)] ) {
        [contentView clearContents];
    }
}

@end
