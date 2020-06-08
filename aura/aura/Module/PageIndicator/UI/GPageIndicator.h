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

@property(nonatomic) NSInteger numberOfPages;
@property(nonatomic) double progressOfTotal; // 0到numberOfPages
@property(nonatomic) double progressOfCurrent; // 0到1

@end

NS_ASSUME_NONNULL_END
