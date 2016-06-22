//
//  SampleContentView.m
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 23..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "SampleContentView.h"

@implementation SampleContentView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
    }
    
    return self;
}

- (UILabel*)label {
    if ( nil == _label ) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont boldSystemFontOfSize:20.f];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    
    return _label;
}

#pragma mark - HIUISlidingTabViewContentView protocols

- (void)loadContentsIfNotLoaded {
}

- (void)setScrollsToTop:(BOOL)toTop {
}

- (void)clearContents {
    self.label.text = @"";
}

@end
