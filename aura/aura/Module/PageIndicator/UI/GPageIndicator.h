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
 这里的范围，定义为 -1.0 到 numberOfPages
 */
@property(nonatomic) double progressOfTotal;

/**
 0 到 1
 */
@property(nonatomic) double progressOfCurrent;

@end

NS_ASSUME_NONNULL_END
