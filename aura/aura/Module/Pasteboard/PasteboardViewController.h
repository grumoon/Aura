//
//  PasteboardViewController.h
//  aura
//
//  Created by Grumoon on 2020/5/27.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasteboardViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) IBOutlet UILabel *lbPasteboardInfo;

-(IBAction)btnGetPasteboardInfoClick:(UIButton *)button;

@end

NS_ASSUME_NONNULL_END
