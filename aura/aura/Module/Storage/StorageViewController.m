//
//  StorageViewController.m
//  aura
//
//  Created by Grumoon on 2020/5/27.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "StorageViewController.h"

@interface StorageViewController ()

@end

@implementation StorageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tvDisplay.editable = NO;
    
    [self displayStorageInfo];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (void)displayStorageInfo {
    NSString *displayInfo = @"";
    
    NSString *bundlePath = [[NSBundle mainBundle]bundlePath];
    NSLog(@"bundle path is %@", bundlePath);
    displayInfo = [displayInfo stringByAppendingFormat:@"Bundle Path：%@\n", bundlePath];
    
    // Home
    NSString *homeDir = NSHomeDirectory();
    NSLog(@"home dir is %@", homeDir);
    displayInfo = [displayInfo stringByAppendingFormat:@"\nHome Path：%@\n", homeDir];
    
    // Document
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"doc dir is %@", docDir);
    displayInfo = [displayInfo stringByAppendingFormat:@"\nDocument Path：%@\n", docDir];
    
    // Library
    NSString *libraryDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"library dir is %@", libraryDir);
    displayInfo = [displayInfo stringByAppendingFormat:@"\nLibrary Path：%@\n", libraryDir];
    
    // Library/Caches
    NSString *cachesDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"caches dir is %@", cachesDir);
    displayInfo = [displayInfo stringByAppendingFormat:@"\nCaches Path：%@\n", cachesDir];
    
    // Temp
    NSString *tempPath  = NSTemporaryDirectory();
    NSLog(@"temp dir is %@", tempPath);
    displayInfo = [displayInfo stringByAppendingFormat:@"\nTemp Path：%@\n", tempPath];
   
    self.tvDisplay.text = displayInfo;
}

@end
