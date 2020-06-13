//
//  GPageIndicator.m
//  aura
//
//  Created by Grumoon on 2020/6/8.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "GPageIndicator.h"

#define INDICATOR_FRAME_PADDING 2.0

#define INDICATOR_MIN_WIDTH 7.0
#define INDICATOR_MAX_WIDTH 28.0
#define INDICATOR_HEIGHT 7.0
#define INDICATOR_SPACING 7.0
#define INDICATOR_SHADOW_BLUR 1.0

#define INDICATOR_COLOR_BG_R 209.0 / 255.0
#define INDICATOR_COLOR_BG_G 209.0 / 255.0
#define INDICATOR_COLOR_BG_B 209.0 / 255.0
#define INDICATOR_COLOR_BG_A 1.0

#define INDICATOR_COLOR_SHADOW_R 0.0
#define INDICATOR_COLOR_SHADOW_G 0.0
#define INDICATOR_COLOR_SHADOW_B 0.0
#define INDICATOR_COLOR_SHADOW_A 0.8

#define INDICATOR_COLOR_INNER_R 1.0
#define INDICATOR_COLOR_INNER_G 1.0
#define INDICATOR_COLOR_INNER_B 1.0

#define INDICATOR_COLOR_INNER_ALPHA_PROGRESS_DIFF_MAX 0.3

#define PROGRESS_OF_CURRENT_INVALID_VALUE -1.0

@interface GPageIndicator()
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, assign) BOOL nextPageRunningFlag; //自动下一页 运行中标志位
@property (nonatomic, assign) NSInteger nextPageStartPage; //自动下一页 开始页数
@property (nonatomic, assign) NSTimeInterval nextPageStartTimeMs; //自动下一页 开始时间
@property (nonatomic, assign) NSTimeInterval nextPageDuration; //自动下一页 持续时间
@property (nonatomic, assign) CGFloat nextPageProgressOfStartPage; //自动下一页 开始页填充进度
@property (nonatomic, assign) CGFloat nextPageProgressOfNextPage; //自动下一页 下一页填充进度

@property (nonatomic, assign) BOOL fillCurrentRunningFlag; //自动填充当前页 进行中标志位
@property (nonatomic, assign) CGFloat fillCurrentStartProgress; //自动填充当前页 开始进度
@property (nonatomic, assign) NSTimeInterval fillCurrentStartTimeMs; //自动填充当前页 开始时间
@property (nonatomic, assign) NSTimeInterval fillCurrentDuration; //自动填充当前页 持续时间

@property (nonatomic, strong) UIColor *indicatorColorBg;
@property (nonatomic, strong) UIColor *indicatorColorShadow;

@end

@implementation GPageIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [self getSelfFrame];
        self.opaque = NO;
        
        _numberOfPages = 0.0;
        _progressOfTotal = 0.0;
        _progressOfCurrent = 1.0;
        
        _nextPageProgressOfStartPage = -1.0;
        _nextPageProgressOfNextPage = -1.0;
        
        _indicatorColorBg = [UIColor colorWithRed:INDICATOR_COLOR_BG_R
                                            green:INDICATOR_COLOR_BG_G
                                             blue:INDICATOR_COLOR_BG_B
                                            alpha:INDICATOR_COLOR_BG_A];
        
        _indicatorColorShadow = [UIColor colorWithRed:INDICATOR_COLOR_SHADOW_R
                                                green:INDICATOR_COLOR_SHADOW_G
                                                 blue:INDICATOR_COLOR_SHADOW_B
                                                alpha:INDICATOR_COLOR_SHADOW_A];
    }
    return self;
}

- (void)dealloc {
    self.nextPageRunningFlag = NO;
    self.fillCurrentRunningFlag = NO;
    [self releaseDisplayLink];
}

- (CGRect)getSelfFrame {
    CGRect frame;
    frame.origin.x = self.frame.origin.x;
    frame.origin.y = self.frame.origin.y;
    frame.size.height = INDICATOR_HEIGHT + INDICATOR_FRAME_PADDING * 2;
    CGFloat width = INDICATOR_FRAME_PADDING * 2;
    for (int i = 0; i < self.numberOfPages; i++) {
        if (i == 0) {
            width += INDICATOR_MAX_WIDTH;
        } else {
            width += INDICATOR_SPACING;
            width += INDICATOR_MIN_WIDTH;
        }
    }
    frame.size.width = width;
    return frame;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    if (numberOfPages < 0) {
        _numberOfPages = 0;
    } else {
        _numberOfPages = numberOfPages;
    }
    self.frame = [self getSelfFrame];
}

- (void)setProgressOfCurrent:(CGFloat)progressOfCurrent {
    [self setProgressOfCurrentInternal:progressOfCurrent];
    
    /** 修改 progressOfCurrent，自动填充停止 */
    self.fillCurrentRunningFlag = NO;
}

- (void)setProgressOfTotal:(CGFloat)progressOfTotal {
    [self setProgressOfTotalInternal:progressOfTotal];
    
    /** 修改 progressOfTotal，自动翻页停止 */
    self.nextPageRunningFlag = NO;
}


- (void)setProgressOfCurrentInternal:(CGFloat)progressOfCurrent {
    if (progressOfCurrent > 1.0) {
        _progressOfCurrent = 1.0;
    } else if (progressOfCurrent < 0.0) {
        _progressOfCurrent = 0.0;
    } else {
        _progressOfCurrent = progressOfCurrent;
    }
    if (!self.hidden) {
        [self setNeedsDisplay];
    }
}

- (void)setProgressOfTotalInternal:(CGFloat)progressOfTotal {
    if (progressOfTotal > _numberOfPages) {
        _progressOfTotal = _numberOfPages;
    } else if (progressOfTotal < -1.0) {
        _progressOfTotal = -1.0;
    } else {
        _progressOfTotal = progressOfTotal;
    }
    if (!self.hidden) {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.numberOfPages <= 1) {
        return;
    }
    
    CGFloat baseX = 0.0 + INDICATOR_FRAME_PADDING;
    CGFloat baseY = 0.0 + INDICATOR_FRAME_PADDING;
    
    for (int i = 0; i < self.numberOfPages; i++) {
        CGFloat diff = fabs(self.progressOfTotal - i);

        if (i == 0 && self.progressOfTotal > (self.numberOfPages - 1)) {
            diff = fabs(self.numberOfPages - self.progressOfTotal);
        } else if (i == (self.numberOfPages - 1) && self.progressOfTotal < 0.0) {
            diff = fabs(-1.0 - self.progressOfTotal);
        }

        CGFloat indicatorWidth = 0.0;
        if (diff >= 1.0) {
            indicatorWidth = INDICATOR_MIN_WIDTH;
        } else {
            indicatorWidth = INDICATOR_MIN_WIDTH + (INDICATOR_MAX_WIDTH - INDICATOR_MIN_WIDTH) * (1.0 - diff) / 1.0;
        }

        CGRect indicatorRect = CGRectMake(baseX, baseY, indicatorWidth, INDICATOR_HEIGHT);
        [self drawRoundedRectangle:context
                              rect:indicatorRect
                         fillColor:self.indicatorColorBg
                       strokeColor:nil
                       shadowColor:self.indicatorColorShadow
                       drawingMode:kCGPathFill];

        baseX += indicatorWidth + INDICATOR_SPACING;


        /**
         画当前 Indicator
         小于 0.5 的，一定最近，认为是当前
         */
        if (diff < 0.5) {
            CGFloat currentIndicatorAlpha = 0.0;
            if (diff < INDICATOR_COLOR_INNER_ALPHA_PROGRESS_DIFF_MAX) {
                currentIndicatorAlpha = (INDICATOR_COLOR_INNER_ALPHA_PROGRESS_DIFF_MAX - diff) / INDICATOR_COLOR_INNER_ALPHA_PROGRESS_DIFF_MAX;
            }

            CGFloat currentIndicatorWidth = INDICATOR_MIN_WIDTH + (indicatorRect.size.width - INDICATOR_MIN_WIDTH) * self.progressOfCurrent;
            CGRect currentIndicatorRect = CGRectMake(indicatorRect.origin.x,
                                                     indicatorRect.origin.y,
                                                     currentIndicatorWidth,
                                                     indicatorRect.size.height);

            UIColor *fillColor = [UIColor colorWithRed:INDICATOR_COLOR_INNER_R
                                                 green:INDICATOR_COLOR_INNER_G
                                                  blue:INDICATOR_COLOR_INNER_B
                                                 alpha:currentIndicatorAlpha];
            [self drawRoundedRectangle:context
                                  rect:currentIndicatorRect
                             fillColor:fillColor
                           strokeColor:nil
                           shadowColor:nil
                           drawingMode:kCGPathFill];
        }
    }
}

- (void)drawRoundedRectangle:(CGContextRef)context
                        rect:(CGRect)rect
                   fillColor:(UIColor *)fillColor
                 strokeColor:(UIColor *)strokeColor
                 shadowColor:(UIColor *)shadowColor
                 drawingMode:(CGPathDrawingMode)drawingMode {
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    
    if (fillColor != nil) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
    }
    
    if (strokeColor != nil) {
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
    }
    
    if (shadowColor != nil) {
        CGContextSetShadowWithColor(context, CGSizeMake(0.0, 0.0), INDICATOR_SHADOW_BLUR, shadowColor.CGColor);
    }
    
    CGMutablePathRef path = [self makeRoundedRectanglePath:rect];
    CGContextAddPath(context, path);
    
    CGContextDrawPath(context, drawingMode);
    
    CGPathRelease(path);
    
    CGContextRestoreGState(context);
}

- (CGMutablePathRef)makeRoundedRectanglePath:(CGRect)rect {
    CGFloat radio = rect.size.height / 2.0;
    
    // 矩形的8个关建点
    CGPoint leftTopPoint = CGPointMake(rect.origin.x + 0, rect.origin.y + 0);
    
    CGPoint centerTopPoint = CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + 0);
    
    CGPoint rightTopPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + 0);
    
    CGPoint rightCenterPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2.0);
    
    CGPoint rightBottomPoint = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    
    CGPoint centerBottomPoint = CGPointMake(rect.origin.x + rect.size.width / 2.0, rect.origin.y + rect.size.height);
    
    CGPoint leftBottomPoint = CGPointMake(rect.origin.x + 0, rect.origin.y + rect.size.height);
    
    CGPoint leftCenterPoint = CGPointMake(rect.origin.x + 0, rect.origin.y + rect.size.height / 2.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, centerTopPoint.x, centerTopPoint.y);
    CGPathAddArcToPoint(path, NULL, rightTopPoint.x, rightTopPoint.y, rightCenterPoint.x, rightCenterPoint.y, radio); // 右上角
    CGPathAddArcToPoint(path, NULL, rightBottomPoint.x, rightBottomPoint.y, centerBottomPoint.x, centerBottomPoint.y, radio); // 右下角
    CGPathAddArcToPoint(path, NULL, leftBottomPoint.x, leftBottomPoint.y, leftCenterPoint.x, leftCenterPoint.y, radio); // 左下角
    CGPathAddArcToPoint(path, NULL, leftTopPoint.x, leftTopPoint.y, centerTopPoint.x, centerTopPoint.y, radio); // 左上角
    CGPathCloseSubpath(path);
    return path;
}


- (void)tryStartDisplayLink {
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAutoCheck)];\
        self.displayLink.preferredFramesPerSecond = 60;
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)releaseDisplayLink {
    [self.displayLink invalidate];
    self.displayLink = nil;
}


- (void)displayLinkAutoCheck {
    if (!self.nextPageRunningFlag && !self.fillCurrentRunningFlag) {
        [self releaseDisplayLink];
        return;
    }

    // 处理翻页
    if (self.nextPageRunningFlag) {
        NSTimeInterval autoNextPageCostTime = [[NSDate date] timeIntervalSince1970] * 1000 - self.nextPageStartTimeMs;

        if (self.nextPageDuration <= 0 || autoNextPageCostTime > self.nextPageDuration) {
            // 完成任务
            self.nextPageRunningFlag = NO;
        } else {
            CGFloat progressOfTotal = self.nextPageStartPage + 1.0 * autoNextPageCostTime / self.nextPageDuration;
            [self setProgressOfTotalInternal:progressOfTotal];

            // 时间过半，设置下一页的填充数据
            if (autoNextPageCostTime >= self.nextPageDuration / 2.0) {
                // 如果 self.nextPageProgressOfNextPage 在有效范围，就设置
                if (self.nextPageProgressOfNextPage >= 0.0 && self.nextPageProgressOfNextPage <= 1.0) {
                    [self setProgressOfCurrentInternal:self.nextPageProgressOfNextPage];
                }
            }
        }
    }

    // 处理填充当前
    if (self.fillCurrentRunningFlag) {
        NSTimeInterval autoFillCurrentCostTime = [[NSDate date] timeIntervalSince1970] * 1000 - self.fillCurrentStartTimeMs;

        if (self.fillCurrentDuration <= 0 || autoFillCurrentCostTime > self.fillCurrentDuration) {
            // 完成任务
            self.fillCurrentRunningFlag = NO;
        } else {
            CGFloat progressOfCurrent = self.fillCurrentStartProgress +
            (1.0 - self.fillCurrentStartProgress) * autoFillCurrentCostTime / self.fillCurrentDuration;

            [self setProgressOfCurrentInternal:progressOfCurrent];
        }
    }
}


- (void)autoNextPage:(NSInteger)startPage duration:(NSTimeInterval)duration {
    [self autoNextPage:startPage duration:duration progressOfStartPage:-1.0 progressOfNextPage:-1.0];
}

- (void)autoNextPage:(NSInteger)startPage
            duration:(NSTimeInterval)duration
 progressOfStartPage:(CGFloat)progressOfStartPage
  progressOfNextPage:(CGFloat)progressOfNextPage {
    NSLog(@"autoNextPage startPage = %ld | duration = %f | progressOfStartPage = %f | progressOfNextPage = %f | runningFlag = %d",
          startPage, duration, progressOfStartPage, progressOfNextPage, self.nextPageRunningFlag);
    
    if (duration <= 0.0) {
        return;
    }
    
    if (self.nextPageRunningFlag) {
        return;
    }
    
    self.nextPageRunningFlag = YES;
    
    if (startPage < 0) {
        startPage = 0;
    } else if(startPage > self.numberOfPages - 1) {
        startPage = self.numberOfPages - 1;
    }
    
    self.nextPageStartPage = startPage;
    self.nextPageStartTimeMs = [[NSDate date]timeIntervalSince1970] * 1000;
    self.nextPageDuration = duration;
    self.nextPageProgressOfStartPage = progressOfStartPage;
    self.nextPageProgressOfNextPage = progressOfNextPage;
    
    [self setProgressOfTotalInternal:self.nextPageStartPage];
    
    // 如果 self.nextPageProgressOfStartPage 在有效范围，就设置
    if (self.nextPageProgressOfStartPage >= 0.0 && self.nextPageProgressOfStartPage <= 1.0) {
        [self setProgressOfCurrentInternal:self.nextPageProgressOfStartPage];
    }
    
    [self tryStartDisplayLink];
}

- (void)autoFillCurrent:(CGFloat)startProgress duration:(NSTimeInterval)duration {
    NSLog(@"autoFillCurrent startProgress = %f | duration = %f | runningFlag = %d", startProgress, duration, self.fillCurrentRunningFlag);
    
    if (duration <= 0.0) {
        return;
    }
    
    if (self.fillCurrentRunningFlag) {
        return;
    }
    
    self.fillCurrentRunningFlag = YES;
    
    if (startProgress > 1.0) {
        startProgress = 1.0;
    } else if (startProgress < 0.0) {
        startProgress = 0.0;
    }
    
    self.fillCurrentStartProgress = startProgress;
    self.fillCurrentStartTimeMs = [[NSDate date]timeIntervalSince1970] * 1000;
    self.fillCurrentDuration = duration;
    
    [self setProgressOfCurrentInternal:self.fillCurrentStartProgress];
    
    [self tryStartDisplayLink];
}
@end
