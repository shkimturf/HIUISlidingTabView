# HIUISlidingTabView

Sliding contents view by swiping or tap menu.

## Screenshot

![alt tag](https://github.com/shkimturf/HIUISlidingTabView/blob/master/preview_top.gif?raw=true =250px)
![alt tag](https://github.com/shkimturf/HIUISlidingTabView/blob/master/preview_bottom.gif?raw=true =250px)

## Environments

over iOS 7.0

## Usage

### Setup

Just import **HIUISlidingTabView** source files to your project.

### Layout Manager

* Set menu position you want.
* you can determine to use focus bar or not.

``` objc
    enum {
        HIUISlidingTabMenuPositionTop = 0,
        HIUISlidingTabMenuPositionBottom,
    };
    typedef NSInteger HIUISlidingTabMenuPosition;

    CGFloat menuHeight;
    HIUISlidingTabMenuPosition menuPosition;
    BOOL useFocusBar;
    
    CGFloat focusBarHeight;
    UIColor* focusBarColor;
```

### DataSource

DataSource should be define to contents view.
It needs optionally focusbar if you set useFocusBar to YES

``` objc
    - (NSUInteger)numberOfContentsInSlidingTabView:(HIUISlidingTabView*)view;
    - (HIUIBarButtonItem*)slidingTabView:(HIUISlidingTabView*)view barButtonItemAtIndex:(NSUInteger)index;
    - (UIView<HIUISlidingTabViewContentView>*)slidingTabView:(HIUISlidingTabView*)view contentViewAtIndex:(NSUInteger)index;

    @optional
    - (UIView*)focusBarViewInSlidingTabView:(HIUISlidingTabView*)view;
```

### Delegate

It delegates when tapped menu.

``` objc
    - (void)slidingTabView:(HIUISlidingTabView*)view didSelectMenuAtIndex:(NSUInteger)index;
```

## Sample source

**HIUISlidingTabViewSample** implements explained above and shows how to use this library.

## Author

[shkimturf](https://github.com/shkimturf)

## License

HIUISlidingTabView is under MIT License.