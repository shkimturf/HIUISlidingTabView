//
//  SampleLayoutManager.m
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "SampleLayoutManager.h"

@implementation SampleLayoutManager
@synthesize menuHeight, menuPosition, useFocusBar, focusBarHeight;

- (instancetype)init {
    self = [super init];
    if (self) {
        menuHeight = 40.f;
        menuPosition = HIUISlidingTabMenuPositionTop;
        useFocusBar = YES;
        focusBarHeight = 2.f;
    }
    
    return self;
}

@end
