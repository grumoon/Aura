//
//  GPageIndicator.h
//  aura
//
//  Created by Grumoon on 2020/6/8.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPageIndicator : UIView

/**
 页数
 */
@property(nonatomic) NSInteger numberOfPages;

/**
 为了能够第一页向左，或者最后一页向右
 需要在 0 到 numberOfPages - 1 的范围上扩大
 所以范围，定义为 -1.0 到 numberOfPages
 */
@property(nonatomic) CGFloat progressOfTotal;

/**
 当前页的填充进度
 0.0 到 1.0
 */
@property(nonatomic) CGFloat progressOfCurrent;


/**
 自动翻页

 过程中，如果设置 progressOfTotal 会停止自动
 
 @param startPage 开始页数 0 到 numberOfPages - 1
 @param duration  持续时间 ms
 */
- (void)autoNextPage:(NSInteger)startPage duration:(NSTimeInterval)duration;


/**
 自动翻页
 
 过程中，如果设置 progressOfTotal 会停止自动
 
 @param startPage 开始页数 0 到 numberOfPages - 1
 @param duration 持续时间 ms
 @param progressOfStartPage 设置当前页的 填充 progress 0 到 1.0 超出范围认为无效，不设置
 @param progressOfNextPage 设置下一页的 填充 progress 0 到 1.0 超过范围认为无效，不设置
 */
- (void)autoNextPage:(NSInteger)startPage
            duration:(NSTimeInterval)duration
 progressOfStartPage:(CGFloat)progressOfStartPage
  progressOfNextPage:(CGFloat)progressOfNextPage;

/**
 自动填充当前
 
 过程中，如果设置 progressOfCurrent 会停止自动
 
 @param startProgress 填充开始的进度 0 到 1.0
 @param duration 持续时间 ms
 */
- (void)autoFillCurrent:(CGFloat)startProgress duration:(NSTimeInterval)duration;
@end

NS_ASSUME_NONNULL_END
