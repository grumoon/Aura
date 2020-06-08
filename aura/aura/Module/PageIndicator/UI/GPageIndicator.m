//
//  GPageIndicator.m
//  aura
//
//  Created by Grumoon on 2020/6/8.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "GPageIndicator.h"
#import <QuartzCore/QuartzCore.h>

#define FRAME_EXTRA 2.0

#define INDICATOR_WIDTH 7.0
#define INDICATOR_HEIGHT 7.0

#define CURRENT_INDICATOR_WIDTH 28.0

#define INDICATOR_SPACING 7.0

#define INDICATOR_COLOR_BG_R 221.0 / 255.0
#define INDICATOR_COLOR_BG_G 221.0 / 255.0
#define INDICATOR_COLOR_BG_B 221.0 / 255.0
#define INDICATOR_COLOR_BG_A 1.0

#define INDICATOR_SHADOW_BLUR 1.0

#define INDICATOR_COLOR_SHADOW_R 0.0
#define INDICATOR_COLOR_SHADOW_G 0.0
#define INDICATOR_COLOR_SHADOW_B 0.0
#define INDICATOR_COLOR_SHADOW_A 0.8

#define INDICATOR_COLOR_INNER_R 1.0
#define INDICATOR_COLOR_INNER_G 1.0
#define INDICATOR_COLOR_INNER_B 1.0

@implementation GPageIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [self getSelfFrame];
        self.opaque = NO;
    }
    return self;
}

- (CGRect)getSelfFrame {
    CGRect frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    frame.size.height = INDICATOR_HEIGHT + FRAME_EXTRA * 2;
    double width = 0.0;
    for (int i = 0; i < self.numberOfPages; i++) {
        if (i == 0) {
            width += FRAME_EXTRA;
            width += CURRENT_INDICATOR_WIDTH;
        } else {
            width += INDICATOR_SPACING;
            width += INDICATOR_WIDTH;
        }

        if (i == self.numberOfPages - 1) {
            width += FRAME_EXTRA;
        }
    }
    frame.size.width = width;
    return frame;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    self.frame = [self getSelfFrame];
}

- (void)setProgressOfCurrent:(double)progressOfCurrent {
    if (progressOfCurrent > 1.0) {
        _progressOfCurrent = 1.0;
    } else if (progressOfCurrent < 0.0) {
        _progressOfCurrent = 0.0;
    } else {
        _progressOfCurrent = progressOfCurrent;
    }
    [self setNeedsDisplay];
}

- (void)setProgressOfTotal:(double)progressOfTotal {
    if (progressOfTotal > _numberOfPages) {
        _progressOfTotal = _numberOfPages;
    } else if (progressOfTotal < -1.0) {
        _progressOfTotal = -1.0;
    } else {
        _progressOfTotal = progressOfTotal;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    CGFloat baseX = 0.0 + FRAME_EXTRA;
    CGFloat baseY = 0.0 + FRAME_EXTRA;

    for (int i = 0; i < self.numberOfPages; i++) {
        CGFloat diff = fabs(self.progressOfTotal - i);
        
        if (i == 0 && self.progressOfTotal > (self.numberOfPages - 1)) {
            diff = fabs(self.numberOfPages - self.progressOfTotal);
        } else if (i == (self.numberOfPages - 1) && self.progressOfTotal < 0.0) {
            diff = fabs(-1.0 - self.progressOfTotal);
        }
        
        CGFloat width = 0.0;
        if (diff >= 1.0) {
            width = INDICATOR_WIDTH;
        } else {
            width = INDICATOR_WIDTH + (CURRENT_INDICATOR_WIDTH - INDICATOR_WIDTH) * (1.0 - diff) / 1.0;
        }
        
        CGRect rect = CGRectMake(baseX, baseY, width, INDICATOR_HEIGHT);
        [self drawIndicator:context rect:rect];
        baseX += width + INDICATOR_SPACING;
    }
}

- (void)drawIndicator:(CGContextRef)context rect:(CGRect)rect {
    
    CGContextSetLineWidth(context, 1.0);
    
    CGFloat radio = rect.size.height / 2;

    // 矩形的8个关建点
    CGPoint leftTopPoint = CGPointMake(rect.origin.x + 0, rect.origin.y + 0);

    CGPoint centerTopPoint = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + 0);
    
    CGPoint rightTopPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + 0);
    
    CGPoint rightCenterPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2);
    
    CGPoint rightBottomPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    
    CGPoint centerBottomPoint = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height);
    
    CGPoint leftBottomPoint = CGPointMake(rect.origin.x + 0, rect.origin.y + rect.size.height);
    
    CGPoint leftCenterPoint = CGPointMake(rect.origin.x + 0, rect.origin.y + rect.size.height / 2);

    
    UIColor *fillColor = [UIColor colorWithRed:INDICATOR_COLOR_BG_R
                                         green:INDICATOR_COLOR_BG_G
                                          blue:INDICATOR_COLOR_BG_B
                                         alpha:INDICATOR_COLOR_BG_A];
    
    // shadow
    UIColor *shadowColor = [UIColor colorWithRed:INDICATOR_COLOR_SHADOW_R
                                           green:INDICATOR_COLOR_SHADOW_G
                                            blue:INDICATOR_COLOR_SHADOW_B
                                           alpha:INDICATOR_COLOR_SHADOW_A];
    
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0.0), INDICATOR_SHADOW_BLUR, shadowColor.CGColor);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, centerTopPoint.x, centerTopPoint.y);
    CGPathAddArcToPoint(path, NULL, rightTopPoint.x, rightTopPoint.y, rightCenterPoint.x, rightCenterPoint.y, radio); // 右上角
    CGPathAddArcToPoint(path, NULL, rightBottomPoint.x, rightBottomPoint.y, centerBottomPoint.x, centerBottomPoint.y, radio); // 右下角
    CGPathAddArcToPoint(path, NULL, leftBottomPoint.x, leftBottomPoint.y, leftCenterPoint.x, leftCenterPoint.y, radio); // 左下角
    CGPathAddArcToPoint(path, NULL, leftTopPoint.x, leftTopPoint.y, centerTopPoint.x, centerTopPoint.y, radio); // 左上角
    CGPathCloseSubpath(path);
    
    CGContextAddPath(context, path);

    CGContextDrawPath(context, kCGPathFill);
    
}

@end
