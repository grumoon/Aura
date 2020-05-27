//
//  ViewController.h
//  aura
//
//  Created by Grumoon on 2020/5/27.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleInfo.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<ModuleInfo *> *dataArray;

@end

