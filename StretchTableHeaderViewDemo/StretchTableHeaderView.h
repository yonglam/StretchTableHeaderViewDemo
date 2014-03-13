//
//  StretchTableHeaderView.h
//  StretchTableHeaderViewDemo
//
//  Created by Lin Yong on 14-3-13.
//  Copyright (c) 2014年 Lin Yong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreenWidth   320

#define kSmallHeight (([UIDevice currentDevice].systemVersion.floatValue >= 7) ? 73 : 53)
#define kOneRowHeight (([UIDevice currentDevice].systemVersion.floatValue >= 7) ? 220 : 200)
#define kTwoRowHeight (([UIDevice currentDevice].systemVersion.floatValue >= 7) ? 290 : 270)
#define kThreeRowHeight (([UIDevice currentDevice].systemVersion.floatValue >= 7) ? 407 : 387)

typedef NS_ENUM(NSInteger, kTHButtonType) {
    kTHButtonTypeOne = 1001,
    kTHButtonTypeTwo,
    kTHButtonTypeThree,
    kTHButtonTypeFour,
    kTHButtonTypeFive,
    kTHButtonTypeSix,
    kTHButtonTypeSeven,
    kTHButtonTypeEight,
    kTHButtonTypeNine,
};

@protocol StretchTableHeaderViewDelegate <NSObject>

- (void)headerViewButtonClick:(UIButton *)sender;

@end

@interface StretchTableHeaderView : UIView

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic, weak) id<StretchTableHeaderViewDelegate> delegate;

// call it in [scrollViewWillBeginDragging]
- (void)handleScrollBeginDraging;
// call it in [scrollViewDidEndDragging] & [scrollViewDidEndDecelerating]
- (void)handleScrollEnd;
// call it in [scrollViewDidEndScrollingAnimation]
- (void)handleScrollAnimationEnd;

@end

