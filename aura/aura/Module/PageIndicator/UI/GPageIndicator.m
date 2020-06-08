//
//  GPageIndicator.m
//  aura
//
//  Created by Grumoon on 2020/6/8.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "GPageIndicator.h"

#define INDICATOR_WIDTH 7.0
#define INDICATOR_HEIGHT 7.0
#define INDICATOR_RADIO 7.0

#define INDICATOR_BORDER_1 1.0
#define INDICATOR_BORDER_2 2.0

#define CURRENT_INDICATOR_WIDTH 28.0
#define CURRENT_INDICATOR_HEIGHT 7.0
#define CURRENT_INDICATOR_RADIO 7.0

#define INDICATOR_SPACING 7

#define INDICATOR_COLOR_BG_R 207/255
#define INDICATOR_COLOR_BG_G 207/255
#define INDICATOR_COLOR_BG_B 207/255
#define INDICATOR_COLOR_BG_A 207/255

#define INDICATOR_COLOR_BORDER_1_R 0
#define INDICATOR_COLOR_BORDER_1_G 0
#define INDICATOR_COLOR_BORDER_1_B 0
#define INDICATOR_COLOR_BORDER_1_A 0.3

#define INDICATOR_COLOR_BORDER_2_R 0
#define INDICATOR_COLOR_BORDER_2_G 0
#define INDICATOR_COLOR_BORDER_2_B 0
#define INDICATOR_COLOR_BORDER_2_A 0.5

#define INDICATOR_COLOR_INNER_R 1.0
#define INDICATOR_COLOR_INNER_G 1.0
#define INDICATOR_COLOR_INNER_B 1.0


@implementation GPageIndicator

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = [self getSelfFrame];
    }
    return self;
}

- (CGRect)getSelfFrame {
    CGRect frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    frame.size.height = INDICATOR_HEIGHT + INDICATOR_BORDER_2;
    double width = 0.0;
    for (int i = 0; i < self.numberOfPages; i++) {
        if (i == 0) {
            width += INDICATOR_BORDER_2;
            width += CURRENT_INDICATOR_WIDTH;
        } else {
            width += INDICATOR_SPACING;
            width += INDICATOR_WIDTH;
        }
        
        
        if (i == self.numberOfPages - 1) {
            width += INDICATOR_BORDER_2;
        }
    }
    frame.size.width = width;
    return frame;
}

- (void)setNumberOfPages:(NSInteger)numberOfPages {
    _numberOfPages = numberOfPages;
    self.frame = [self getSelfFrame];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}


@end
