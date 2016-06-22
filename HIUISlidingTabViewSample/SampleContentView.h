//
//  SampleContentView.h
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 23..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIUISlidingTabViewContentView.h"

@interface SampleContentView : UIView <HIUISlidingTabViewContentView>
{
    UILabel* _label;
}

@property (nonatomic, strong, readonly) UILabel* label;

@end
