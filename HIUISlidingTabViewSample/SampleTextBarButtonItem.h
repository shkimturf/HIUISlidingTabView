//
//  SampleTextBarButtonItem.h
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 23..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "HIUIBarButtonItem.h"

@interface SampleTextBarButtonItem : HIUIBarButtonItem
{
    UIButton* _button;
}

@property (nonatomic, strong, readonly) UIButton* button;
@property (nonatomic, strong) NSString* buttonTitle;

+ (SampleTextBarButtonItem*)buttonItemWithTitle:(NSString*)title;

@end
