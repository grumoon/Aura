//
//  DeviceViewController.m
//  aura
//
//  Created by Grumoon on 2020/5/29.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "DeviceViewController.h"

@interface DeviceViewController ()

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tvDisplay.editable = NO;

    [self displayDeviceInfo];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)displayDeviceInfo {
    NSString *displayInfo = @"";

    UIDevice *currentDevice = [UIDevice currentDevice];
    NSString *deviceName = currentDevice.name;    //设备名称
    NSString *deviceModel = currentDevice.model;    //设备类别
    NSString *deviceLocalizedModel = currentDevice.localizedModel;    //设备本地化版本
    NSString *deviceSystemName = currentDevice.systemName;    //设备运行的系统
    NSString *deviceSystemVersion = currentDevice.systemVersion;    //当前系统版本
    NSString *deviceUUIDString = currentDevice.identifierForVendor.UUIDString;    //系统识别码

    displayInfo = [displayInfo stringByAppendingFormat:@"设备信息\n"];
    displayInfo = [displayInfo stringByAppendingFormat:@"Name：%@\n", deviceName];
    displayInfo = [displayInfo stringByAppendingFormat:@"Model：%@\n", deviceModel];
    displayInfo = [displayInfo stringByAppendingFormat:@"LocalizedModel：%@\n", deviceLocalizedModel];
    displayInfo = [displayInfo stringByAppendingFormat:@"SystemName：%@\n", deviceSystemName];
    displayInfo = [displayInfo stringByAppendingFormat:@"SystemVersion：%@\n", deviceSystemVersion];
    displayInfo = [displayInfo stringByAppendingFormat:@"UUID：%@\n", deviceUUIDString];
    
    self.tvDisplay.text = displayInfo;
    
    NSLog(@"%@", displayInfo);
}

@end
