//
//  UIView+Additions.m
//  ZDComponents
//
//  Created by zhuchao on 13-12-19.
//  Copyright (c) 2013年 baidu. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

@end

@implementation UIView (Border)

- (void) setBorder:(UIViewBorderOption)option width:(CGFloat)width color:(UIColor *)color
{
    CALayer *border = [CALayer layer];
    CGRect frame = self.bounds;
    switch (option) {
            case UIViewBorderOptionTop:
            frame.size.height = width;
            break;
            case UIViewBorderOptionRight:
            frame.origin.x = frame.size.width - width;
            frame.size.width = width;
            break;
            case UIViewBorderOptionBottom:
            frame.origin.y = frame.size.height - width;
            frame.size.height = width;
            break;
            case UIViewBorderOptionLeft:
            frame.size.width = width;
            break;
            case UIViewBorderOptionAll:
            [self setBorder: UIViewBorderOptionBottom width:width color: color];
            [self setBorder: UIViewBorderOptionLeft width:width color: color];
            [self setBorder: UIViewBorderOptionRight width:width color: color];
            [self setBorder: UIViewBorderOptionTop width:width color: color];
            break;
    }
    border.frame = frame;
    border.backgroundColor = [color CGColor];
    [self.layer addSublayer: border];
    
}

- (void) setDashBorder:(UIViewBorderOption)option width:(CGFloat)width color:(UIColor *)color
{
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGRect frame = self.bounds;
    switch (option) {
            case UIViewBorderOptionTop:
            frame.size.height = width;
            [path moveToPoint: CGPointMake(0, 0)];
            [path addLineToPoint: CGPointMake(frame.size.width, 0)];
            break;
            case UIViewBorderOptionRight:
            frame.origin.x = frame.size.width - width;
            frame.size.width = width;
            [path moveToPoint: CGPointMake(frame.size.width, 0)];
            [path addLineToPoint: CGPointMake(frame.size.width, frame.size.height)];
            break;
            case UIViewBorderOptionBottom:
            frame.origin.y = frame.size.height - width;
            frame.size.height = width;
            [path moveToPoint: CGPointMake(0, frame.size.height)];
            [path addLineToPoint: CGPointMake(frame.size.width, frame.size.height)];
            break;
            case UIViewBorderOptionLeft:
            frame.size.width = width;
            [path moveToPoint: CGPointMake(0, 0)];
            [path addLineToPoint: CGPointMake(0, frame.size.height)];
            break;
            case UIViewBorderOptionAll:
            [self setDashBorder: UIViewBorderOptionBottom width:width color: color];
            [self setDashBorder: UIViewBorderOptionLeft width:width color: color];
            [self setDashBorder: UIViewBorderOptionRight width:width color: color];
            [self setDashBorder: UIViewBorderOptionTop width:width color: color];
            break;
    }
    shapelayer.frame = frame;
    
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = color.CGColor;
    shapelayer.fillColor = [[UIColor clearColor] CGColor];
    shapelayer.lineWidth = width;
    shapelayer.lineJoin = kCALineJoinMiter;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:2], nil];
    shapelayer.lineDashPhase = 2.0f;
    shapelayer.path = path.CGPath;
    [self.layer addSublayer: shapelayer];
}

- (void) roundCornerWithDashBorder:(CGFloat)radius width:(CGFloat)width color:(UIColor *)color
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: self.bounds cornerRadius: radius];
    CAShapeLayer *shapelayer = [CAShapeLayer layer];
    shapelayer.frame = self.bounds;
    shapelayer.strokeStart = 0.0;
    shapelayer.strokeColor = color.CGColor;
    shapelayer.fillColor = [[UIColor clearColor] CGColor];
    shapelayer.lineWidth = width;
    shapelayer.lineJoin = kCALineJoinMiter;
    shapelayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:4],[NSNumber numberWithInt:2], nil];
    shapelayer.lineDashPhase = 2.0f;
    shapelayer.path = path.CGPath;
    [self.layer insertSublayer: shapelayer atIndex: 0];
    //[self.layer addSublayer: shapelayer];
    
}

@end


@implementation UIView (FrameAdditions)
-(float) x {
    return self.frame.origin.x;
}

-(void) setX:(float) newX {
    CGRect frame = self.frame;
    frame.origin.x = newX;
    self.frame = frame;
}

-(float) y {
    return self.frame.origin.y;
}

-(void) setY:(float) newY {
    CGRect frame = self.frame;
    frame.origin.y = newY;
    self.frame = frame;
}

-(float) width {
    return self.frame.size.width;
}

-(void) setWidth:(float) newWidth {
    CGRect frame = self.frame;
    frame.size.width = newWidth;
    self.frame = frame;
}

-(float) height {
    return self.frame.size.height;
}

-(void) setHeight:(float) newHeight {
    CGRect frame = self.frame;
    frame.size.height = newHeight;
    self.frame = frame;
}

-(float) right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(float)newRight{
    CGRect frame = self.frame;
    frame.origin.x = newRight - frame.size.width;
    self.frame = frame;
}

- (float) buttom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setButtom:(float)newButtom{
    [self setHeight:fmaxf(newButtom-self.frame.origin.y, 0)];
}

- (CGSize) size {
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGPoint) origin {
    return self.frame.origin;
}

- (void) setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


@end


@implementation UIView(ScreenShot)

+ (UIImage *)screenShot
{
    
    UIView *view = [UIApplication sharedApplication].keyWindow;
    
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGFloat barHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    
    if ([UIApplication sharedApplication].statusBarHidden == NO) {
        
        CGFloat scale = [[UIScreen mainScreen] scale];
        CGRect rect = CGRectMake(0, barHeight * scale, view.bounds.size.width * scale, (view.bounds.size.height - barHeight) * scale);
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
        image = [UIImage imageWithCGImage:imageRef scale:image.scale orientation:image.imageOrientation];
        CFRelease(imageRef);
    }
    
    return image;
}

@end


@implementation UIView (TKCategory)


// Returns an appropriate starting point for the demonstration of a linear gradient
/*- (CGPoint) demoLGStart:(CGRect)bounds{
 return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
 }
 
 */

CGPoint demoLGStart(CGRect bounds);
CGPoint demoLGStart(CGRect bounds){
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.25);
}
CGPoint demoLGEnd(CGRect bounds);
CGPoint demoLGEnd(CGRect bounds){
	return CGPointMake(bounds.origin.x, bounds.origin.y + bounds.size.height * 0.75);
}
CGPoint demoRGCenter(CGRect bounds);
CGPoint demoRGCenter(CGRect bounds){
	return CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}
CGFloat demoRGInnerRadius(CGRect bounds);
CGFloat demoRGInnerRadius(CGRect bounds){
	CGFloat r = bounds.size.width < bounds.size.height ? bounds.size.width : bounds.size.height;
	return r * 0.125;
}


+ (void) drawGradientInRect:(CGRect)rect withColors:(NSArray*)colors{
	
	NSMutableArray *ar = [NSMutableArray array];
	for(UIColor *c in colors){
		[ar addObject:(id)c.CGColor];
	}
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	
	CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
	CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
	
    
	CGContextClipToRect(context, rect);
	
	CGPoint start = CGPointMake(0.0, 0.0);
	CGPoint end = CGPointMake(0.0, rect.size.height);
	
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(gradient);
	CGContextRestoreGState(context);
	
}


+ (void) drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colours{
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
	CGColorSpaceRelease(rgb);
	CGPoint start, end;
	
	start = demoLGStart(rect);
	end = demoLGEnd(rect);
	
	
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
	
}



+ (void) drawRoundRectangleInRect:(CGRect)rect withRadius:(CGFloat)radius color:(UIColor*)color{
	CGContextRef context = UIGraphicsGetCurrentContext();
	[color set];
	
	CGRect rrect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height );
    
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
	CGContextMoveToPoint(context, minx, midy);
	CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
	CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
	CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
	CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
	CGContextClosePath(context);
	CGContextDrawPath(context, kCGPathFill);
}




+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors {
	
	[UIView drawLineInRect:rect colors:colors width:1 cap:kCGLineCapButt];
	
}
+ (void) drawLineInRect:(CGRect)rect red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha{
	CGFloat colors[4];
	colors[0] = red;
	colors[1] = green;
	colors[2] = blue;
	colors[3] = alpha;
	[UIView drawLineInRect:rect colors:colors];
}
+ (void) drawLineInRect:(CGRect)rect colors:(CGFloat[])colors width:(CGFloat)lineWidth cap:(CGLineCap)cap{
	
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	
	CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
	CGContextSetLineCap(context,cap);
	CGContextSetLineWidth(context, lineWidth);
    
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context,rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
	CGContextStrokePath(context);
	
	
	CGContextRestoreGState(context);
	
}
@end

