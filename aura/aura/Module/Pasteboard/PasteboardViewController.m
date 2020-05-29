//
//  PasteboardViewController.m
//  aura
//
//  Created by Grumoon on 2020/5/27.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "PasteboardViewController.h"

#define CUSTOM_PASTEBOARD_TYPE @"com.grumoon.type"

@interface PasteboardViewController ()

@end

@implementation PasteboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
    self.lbPasteboardInfo.lineBreakMode = NSLineBreakByWordWrapping;
    self.lbPasteboardInfo.numberOfLines = 0;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(IBAction)btnGetPasteboardInfoClick:(UIButton *)button {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    NSString *result = @"";
    
    result = [result stringByAppendingString:@"剪贴板基本信息\n"];
    result = [result stringByAppendingFormat:@"名称：%@\n", pasteboard.name];
    
    result = [result stringByAppendingString:@"\n=========================\n"];
    result = [result stringByAppendingString:@"剪贴板最新一条数据的信息\n"];
    result = [result stringByAppendingFormat:@"类型：\n%@\n", pasteboard.pasteboardTypes];
    if([pasteboard.pasteboardTypes count] > 0) {
        NSString *pasteboardType = pasteboard.pasteboardTypes[0];
        if ([pasteboardType isEqualToString:CUSTOM_PASTEBOARD_TYPE]) {
            result = [result stringByAppendingFormat:@"数据：\n%@\n", [[NSString alloc] initWithData:[pasteboard dataForPasteboardType:pasteboardType] encoding:NSUTF8StringEncoding]];
        } else {
            result = [result stringByAppendingFormat:@"数据：\n%@\n", [pasteboard valueForPasteboardType:pasteboardType]];
        }
    }

    result = [result stringByAppendingString:@"\n=========================\n"];
    result = [result stringByAppendingString:@"剪贴板所有数据信息\n"];
    result = [result stringByAppendingFormat:@"个数：%ld\n\n", pasteboard.numberOfItems];
    for (int i = 0; i < [pasteboard.items count]; i++) {
        result = [result stringByAppendingFormat:@"元素：%d\n", (i + 1)];
        result = [result stringByAppendingFormat:@"类型：\n%@\n\n", pasteboard.items[i].allKeys];
    }

    self.lbPasteboardInfo.text = result;
    
    NSLog(@"%@", result);
}


-(IBAction)btnAddValue1Click:(UIButton *)button {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setData:[@"value for custom paste type" dataUsingEncoding:NSUTF8StringEncoding] forPasteboardType:CUSTOM_PASTEBOARD_TYPE];
    
}

-(IBAction)btnAddValue2Click:(UIButton *)button {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    if(pasteboard.numberOfItems >= 3) {
        return;
    }
    
    NSMutableArray<NSDictionary<NSString *, id> *> *newItems = [NSMutableArray array];
    
    NSDictionary<NSString *, id> *newItemDic = [NSMutableDictionary dictionary];
    [newItemDic setValue:@"1" forKey:@"key1-1"];
    [newItemDic setValue:@"2" forKey:@"key1-2"];
    [newItems addObject:newItemDic];
    
    
    newItemDic = [NSMutableDictionary dictionary];
    [newItemDic setValue:@"1" forKey:@"key2-1"];
    [newItemDic setValue:@"2" forKey:@"key2-2"];
    [newItemDic setValue:@"3" forKey:@"key2-3"];
    [newItemDic setValue:@"4" forKey:@"key2-4"];
    [newItems addObject:newItemDic];

    [pasteboard addItems:newItems];
    
    
}

@end
