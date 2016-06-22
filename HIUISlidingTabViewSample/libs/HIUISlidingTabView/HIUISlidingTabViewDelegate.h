//
//  HIUISlidingTabViewDelegate.h
//  HIDevKit
//
//  Created by Sunhong Kim on 2014. 9. 29..
//  Copyright (c) 2014년 Sunhong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HIUISlidingTabView;
@protocol HIUISlidingTabViewDelegate <NSObject>

@optional
- (void)slidingTabView:(HIUISlidingTabView*)view didSelectMenuAtIndex:(NSUInteger)index;

@end
