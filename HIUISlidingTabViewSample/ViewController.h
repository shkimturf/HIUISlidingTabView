//
//  ViewController.h
//  HIUISlidingTabViewSample
//
//  Created by Sunhong Kim on 2016. 6. 22..
//  Copyright © 2016년 Sunhong Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HIUISlidingTabView.h"

@interface ViewController : UIViewController <HIUISlidingTabViewDataSource, HIUISlidingTabViewDelegate>
{
    HIUISlidingTabView* _slidingTabView;
}


@end

