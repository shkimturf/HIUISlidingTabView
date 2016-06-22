//
//  SampleTextBarButtonItem.m
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 23..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import "SampleTextBarButtonItem.h"

@implementation SampleTextBarButtonItem

+ (SampleTextBarButtonItem*)buttonItemWithTitle:(NSString*)title {
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18.f];
    
    SampleTextBarButtonItem* item = [[SampleTextBarButtonItem alloc] initWithCustomView:button];
    return item;
}

#pragma mark - properties

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;
    [self.button setTitle:buttonTitle forState:UIControlStateNormal];
}


- (UIButton *)button {
    NSAssert([self.customView isKindOfClass:[UIButton class]], @"Invalid view class");
    return (UIButton*)self.customView;
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    self.button.selected = self.selected;
}

- (void)setTag:(NSInteger)tag {
    super.tag = tag;
    
    self.button.tag = self.tag;
}

- (void)setAction:(SEL)action {
    super.action = action;
    
    [self.button addTarget:self.target action:self.action forControlEvents:UIControlEventTouchUpInside];
}

@end
