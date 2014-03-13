//
//  StretchTableHeaderView.m
//  StretchTableHeaderViewDemo
//
//  Created by Lin Yong on 14-3-13.
//  Copyright (c) 2014年 Lin Yong. All rights reserved.
//

#import "StretchTableHeaderView.h"
#import "UIView+Additions.h"
#import "UIColor+Hex.h"

#define kTagTitleLabel 1101
#define kTagRedDot     1102

@interface StretchTableHeaderView()<UIScrollViewDelegate>
@property (nonatomic) UIButton *arrowBtn;
@property (nonatomic) UIImageView *logoImage;

@property (nonatomic) NSArray *btnInfos;
@property (nonatomic) NSMutableArray *btnArray;

@property (nonatomic, assign) BOOL scrollViewDraging; // finger on the screen

@end

@implementation StretchTableHeaderView{
    float _firstRowY;
    float _logoImageY;
    float _panStartY;
    CGPoint _panStartScrollOffset;
}

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.btnInfos = @[@{@"imgColor":[UIColor redColor],
                            @"tag":@(kTHButtonTypeOne),
                            @"title":@"Red"},
                          @{@"imgColor":[UIColor orangeColor],
                            @"tag":@(kTHButtonTypeTwo),
                            @"title":@"Orange"},
                          @{@"imgColor":[UIColor yellowColor],
                            @"tag":@(kTHButtonTypeThree),
                            @"title":@"Yellow"},
                          @{@"imgColor":[UIColor blueColor],
                            @"tag":@(kTHButtonTypeFour),
                            @"title":@"Blue"},
                          @{@"imgColor":[UIColor purpleColor],
                            @"tag":@(kTHButtonTypeFive),
                            @"title":@"Purple"},
                          @{@"imgColor":[UIColor grayColor],
                            @"tag":@(kTHButtonTypeSix),
                            @"title":@"Gray"},
                          @{@"imgColor":[UIColor lightGrayColor],
                            @"tag":@(kTHButtonTypeSeven),
                            @"title":@"LightGray"},
                          @{@"imgColor":[UIColor whiteColor],
                            @"tag":@(kTHButtonTypeEight),
                            @"title":@"White"},
                          @{@"imgColor":[UIColor orangeColor],
                            @"tag":@(kTHButtonTypeNine),
                            @"title":@"Orange"},
                          ];
        
        self.backgroundColor = [UIColor colorWithHex:0x37b059];
        self.clipsToBounds = YES;
        self.layer.borderColor = [UIColor colorWithHex:0x1f975a].CGColor;
        self.layer.borderWidth = .5f;
        
        _logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"headerImage.jpg"]];
        _logoImage.center = CGPointMake(160, frame.size.height * 0.25f - (([UIDevice currentDevice].systemVersion.floatValue >= 7) ? 0 : 12));
        _logoImageY = _logoImage.y;
        [self addSubview:_logoImage];
        
        //创建按钮
        _firstRowY = _logoImage.buttom + 10;
        self.btnArray = [NSMutableArray array];
        [self _createButtons];
        
        //提示下滑的箭头
        self.arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.arrowBtn addTarget:self action:@selector(handleArrowBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.arrowBtn setImage:[UIImage imageNamed:@"arrow.png"] forState:UIControlStateNormal];
        [self.arrowBtn sizeToFit];
        self.arrowBtn.center = CGPointMake(kScreenWidth/2.0, ((UIView *)self.btnArray[1]).buttom + 10 + self.arrowBtn.height/2.);
        [self addSubview:self.arrowBtn];
        
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanRecognizer:)];
        [self addGestureRecognizer:panRecognizer];
        
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self.scrollView setContentInset:UIEdgeInsetsMake(kThreeRowHeight, 0, 0, 0)];
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
    self.scrollView.contentOffset = CGPointMake(0, -kOneRowHeight);
}

#pragma mark - UI
- (UIView *)_createButtonWithTitle:(NSString *)title andImageColor:(UIColor *)imgColor andTag:(int)tag atX:(float)x andY:(float)y andLog:(NSString *)log{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, y, 62, 87)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(highlightedBtn:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(cancelHighlightedBtn:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [btn addTarget:self action:@selector(handleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setAdjustsImageWhenHighlighted:NO];
    btn.tag = tag;
    btn.frame = CGRectMake(0, 0, 62, 62);
    [btn setBackgroundColor:imgColor];
    [btn.layer setCornerRadius:btn.width/2.f];
    [v addSubview:btn];
    
    UILabel *txtLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.buttom + 8, 62, 20)];
    txtLabel.tag = kTagTitleLabel;
    txtLabel.backgroundColor = [UIColor clearColor];
    txtLabel.font = [UIFont systemFontOfSize:14];
    txtLabel.textColor = [UIColor whiteColor];
    txtLabel.text = title;
    txtLabel.textAlignment = NSTextAlignmentCenter;
    txtLabel.width = 62;
    txtLabel.height = [UIFont systemFontOfSize:14].lineHeight;
    [v addSubview:txtLabel];
    
    return v;
}

- (void)_createButtons{
    float startX = 45;
    float x = startX;
    float y = _firstRowY;
    int i = 0;
    for (NSDictionary *btnInfo in self.btnInfos) {
        int column = i % 3;
        int row = i / 3;
        x = startX + (62 + 25) * column;
        y = _firstRowY + (87 + 15) * row;
        
        UIView *btn = [self _createButtonWithTitle:btnInfo[@"title"] andImageColor:btnInfo[@"imgColor"] andTag:[btnInfo[@"tag"] intValue] atX:x andY:y andLog:btnInfo[@"logName"]];
        [self addSubview:btn];
        
        if (i >= 3) {
            btn.alpha = 0;
        }
        
        [self.btnArray addObject:btn];
        
        i += 1;
    }
}


#pragma mark - Animation when scrolling
// ratio: (0, 1)
- (void)_animateToSmallModelWithRatio:(float)ratio{
    self.logoImage.alpha = ratio;
    self.logoImage.transform = CGAffineTransformMakeTranslation(0, -1 * (_logoImageY+20) * (1-ratio));
    
    for (int i=0; i<3; i++) {
        UIView *v = self.btnArray[i];
        
        UILabel *lab = (UILabel *)[v viewWithTag:kTagTitleLabel];
        lab.alpha = ratio;
        
        float newRatio = 0.6 + 0.4 * ratio;
        
        float d = ([UIDevice currentDevice].systemVersion.floatValue >= 7) ? 96 : 92;
        v.transform = CGAffineTransformMakeTranslation(0, -1 * d * (1-ratio));
        v.transform = CGAffineTransformScale(v.transform, newRatio, newRatio);
    }
}

- (void)_animateSecondRowWithRatio:(float)ratio{
    for (int i = 3; i < 6; i++) {
        UIView *btn = self.btnArray[i];
        btn.alpha = ratio;
    }
}

- (void)_animateThreeRowWithRatio:(float)ratio{
    for (int i = 6; i < 9; i++) {
        UIView *btn = self.btnArray[i];
        btn.alpha = ratio;
    }
}

#pragma mark - Observer of "contentOffset" of scrollView and its handler

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGPoint newOffset = [change[@"new"] CGPointValue];
        [self _handleScrollViewContentOffsetChanged:newOffset];
    }
}

- (void)_handleScrollViewContentOffsetChanged:(CGPoint)newOffset{
    float destinaOffset = -kSmallHeight;
    float startChangeOffset = -kOneRowHeight;
    
    if (self.scrollViewDraging) {
        [self.arrowBtn setHidden:YES];
    }
    
    if (newOffset.y >= startChangeOffset) {
    // Moving from middle to small status
        
        newOffset = CGPointMake(newOffset.x, newOffset.y<startChangeOffset?startChangeOffset:(newOffset.y>destinaOffset?destinaOffset:newOffset.y));
        
        self.height = newOffset.y * -1;
        
        float d = destinaOffset-startChangeOffset;
        float alpha = 1-(newOffset.y-startChangeOffset)/d;
        
        [self _animateToSmallModelWithRatio:alpha];
        [self _animateSecondRowWithRatio:0];
        [self _animateThreeRowWithRatio:0];
    }
    else{
    // Moving from middle to big status
        
        self.y = 0;
        
        float secondRowOffset = -kTwoRowHeight;
        float thirdRowOffset = -kThreeRowHeight;
        
        if (newOffset.y >= secondRowOffset) {
            self.height = -newOffset.y;
            float alpha1 = 1 - (newOffset.y - (-kTwoRowHeight))/(-kOneRowHeight-(-kTwoRowHeight));
            [self _animateSecondRowWithRatio:alpha1];
            [self _animateThreeRowWithRatio:0];
            [self _animateToSmallModelWithRatio:1];
        }
        else if(newOffset.y >= thirdRowOffset){
            self.height = -newOffset.y;
            float alpha2 = 1 - (newOffset.y - (-kThreeRowHeight))/(-kTwoRowHeight-(-kThreeRowHeight));
            [self _animateThreeRowWithRatio:alpha2];
            [self _animateToSmallModelWithRatio:1];
            [self _animateSecondRowWithRatio:1];
        }
        else {
            if (self.height != kThreeRowHeight) {
                self.height = kThreeRowHeight;
                [self _animateToSmallModelWithRatio:1];
                [self _animateSecondRowWithRatio:1];
                [self _animateThreeRowWithRatio:1];
            }
        }
    }
}

#pragma mark - Public methords for scrollView delegate

- (void)handleScrollBeginDraging{
    self.scrollViewDraging = YES;
}

- (void)handleScrollEnd{
    self.scrollViewDraging = NO;
    
    float offSetY = self.scrollView.contentOffset.y;
    if (offSetY > 0) {
        return;
    }
    offSetY *= -1;
    if (offSetY > (kOneRowHeight + 44)) {
        [self.scrollView setContentOffset:CGPointMake(0, -kThreeRowHeight) animated:YES];
    }
    else if (offSetY > (kOneRowHeight)){
        [self.scrollView setContentOffset:CGPointMake(0, -kOneRowHeight) animated:YES];
    } else if (offSetY > (kOneRowHeight - 100)) {
        [self.scrollView setContentOffset:CGPointMake(0, -kOneRowHeight) animated:YES];
    } else{
        [self.scrollView setContentOffset:CGPointMake(0, -kSmallHeight) animated:YES];
    }
    
}

- (void)handleScrollAnimationEnd{
    if (self.scrollView.contentOffset.y == -kOneRowHeight) {
        [self.arrowBtn setHidden:NO];
    }
}


#pragma mark - UIButton actions

- (void)highlightedBtn:(UIButton *)sender{
    sender.alpha = .65;
}

- (void)cancelHighlightedBtn:(UIButton *)sender{
    sender.alpha = 1;
}

- (void)handleBtnClick:(UIButton *)sender{
    [self cancelHighlightedBtn:sender];
    
    if ([self.delegate respondsToSelector:@selector(headerViewButtonClick:)]) {
        [self.delegate headerViewButtonClick:sender];
    }
}

- (void)handleArrowBtnClick:(UIButton *)sender{
    self.arrowBtn.hidden = YES;
    [self.scrollView setContentOffset:CGPointMake(0, -kThreeRowHeight) animated:YES];
}

#pragma mark - UIPanGestureRecognier action

- (void)handlePanRecognizer:(UIPanGestureRecognizer *)recogizer{
    CGPoint p = [recogizer translationInView:recogizer.view];
    if (recogizer.state == UIGestureRecognizerStateBegan) {
        [self handleScrollBeginDraging];
        _panStartY = p.y;
        _panStartScrollOffset = self.scrollView.contentOffset;
    }
    else if(recogizer.state == UIGestureRecognizerStateCancelled){
        _panStartY = 0;
        [self handleScrollEnd];
    }
    else if (recogizer.state == UIGestureRecognizerStateEnded){
        _panStartY = 0;
        [self handleScrollEnd];
    }
    else{
        float d = (p.y - _panStartY) * -1;
        CGPoint offset = _panStartScrollOffset;
        offset.y += d;
        if (offset.y >= -kThreeRowHeight && offset.y <= kSmallHeight) {
            self.scrollView.contentOffset = offset;
        }
    }
}


@end
