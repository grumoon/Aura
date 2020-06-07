//
//  ViewController.m
//  aura
//
//  Created by Grumoon on 2020/5/27.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Aura";

    [self prepareModuleData];
}

- (void)prepareModuleData {
    ModuleInfo *moduleInfo = [[ModuleInfo alloc] init];
    moduleInfo.name = @"剪贴板";
    moduleInfo.vcClassName = @"PasteboardViewController";

    [self.dataArray addObject:moduleInfo];

    moduleInfo = [[ModuleInfo alloc] init];
    moduleInfo.name = @"存储";
    moduleInfo.vcClassName = @"StorageViewController";

    [self.dataArray addObject:moduleInfo];
    
    moduleInfo = [[ModuleInfo alloc] init];
    moduleInfo.name = @"设备";
    moduleInfo.vcClassName = @"DeviceViewController";

    [self.dataArray addObject:moduleInfo];
    
    moduleInfo = [[ModuleInfo alloc] init];
    moduleInfo.name = @"分页指示";
    moduleInfo.vcClassName = @"PageIndicatorViewController";

    [self.dataArray addObject:moduleInfo];
}

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataArray[indexPath.row].name];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ModuleInfo *moduleInfo = self.dataArray[indexPath.row];
    ViewController *vc = [[NSClassFromString(moduleInfo.vcClassName) alloc] init];
    vc.title = moduleInfo.name;
    [self.navigationController pushViewController:vc animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
