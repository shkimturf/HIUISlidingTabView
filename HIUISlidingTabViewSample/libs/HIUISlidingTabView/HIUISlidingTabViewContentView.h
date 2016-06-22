//
//  HIUISlidingTabViewContentView.h
//  HIDevKit
//
//  Created by Sunhong Kim on 2014. 9. 29..
//  Copyright (c) 2014년 Sunhong Kim. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HIUISlidingTabViewContentView <NSObject>

@optional
- (void)loadContentsIfNotLoaded;
- (void)setScrollsToTop:(BOOL)toTop;

- (void)clearContents;

@end
