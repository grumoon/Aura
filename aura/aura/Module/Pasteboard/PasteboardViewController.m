//
//  PasteboardViewController.m
//  aura
//
//  Created by Grumoon on 2020/5/27.
//  Copyright © 2020 Grumoon. All rights reserved.
//

#import "PasteboardViewController.h"

#define CUSTOM_PASTEBOARD_TYPE @"com.grumoon.test"

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
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *result = @"";
    
    result = [result stringByAppendingString:@"剪贴板基本信息\n"];
    result = [result stringByAppendingFormat:@"名称：%@\n", pasteBoard.name];
    
    result = [result stringByAppendingString:@"\n=========================\n"];
    result = [result stringByAppendingString:@"剪贴板最新一条数据的信息\n"];
    result = [result stringByAppendingFormat:@"类型：%@\n", pasteBoard.pasteboardTypes];
    if([pasteBoard.pasteboardTypes count] > 0) {
        NSString *pasteboardType = pasteBoard.pasteboardTypes[0];
        if ([pasteboardType isEqualToString:CUSTOM_PASTEBOARD_TYPE]) {
            result = [result stringByAppendingFormat:@"数据：%@\n", [[NSString alloc] initWithData:[pasteBoard dataForPasteboardType:CUSTOM_PASTEBOARD_TYPE] encoding:NSUTF8StringEncoding]];
        } else {
            result = [result stringByAppendingFormat:@"数据：%@\n", [pasteBoard valueForPasteboardType:pasteBoard.pasteboardTypes[0]]];
        }
    }

    result = [result stringByAppendingString:@"\n=========================\n"];
    result = [result stringByAppendingString:@"剪贴板所有数据信息\n"];
    result = [result stringByAppendingFormat:@"个数：%ld\n\n", pasteBoard.numberOfItems];
    for (int i = 0; i < [pasteBoard.items count]; i++) {
        result = [result stringByAppendingFormat:@"元素：%d\n", (i + 1)];
        result = [result stringByAppendingFormat:@"类型：%@\n\n", pasteBoard.items[i].allKeys];
    }
    
    self.lbPasteboardInfo.text = result;
}


-(IBAction)btnAddValue1Click:(UIButton *)button {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setData:[@"schema://test.test.test" dataUsingEncoding:NSUTF8StringEncoding] forPasteboardType:@"com.grumoon.test"];
    
}

-(IBAction)btnAddValue2Click:(UIButton *)button {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSMutableArray<NSDictionary<NSString *, id> *> *newItems = [NSMutableArray array];
    
    NSDictionary<NSString *, id> *newItemDic = [NSMutableDictionary dictionary];
    [newItemDic setValue:@"123" forKey:@"key1-1"];
    [newItemDic setValue:@"123" forKey:@"key1-2"];
    [newItemDic setValue:@"123" forKey:@"key1-3"];
    [newItemDic setValue:@"123" forKey:@"key1-4"];
    [newItems addObject:newItemDic];
    
    
    newItemDic = [NSMutableDictionary dictionary];
    [newItemDic setValue:@"123" forKey:@"key2-1"];
    [newItemDic setValue:@"123" forKey:@"key2-2"];
    [newItemDic setValue:@"123" forKey:@"key2-3"];
    [newItemDic setValue:@"123" forKey:@"key2-4"];
    [newItems addObject:newItemDic];
    
    newItemDic = [NSMutableDictionary dictionary];
    [newItemDic setValue:@"123" forKey:@"key3-1"];
    [newItemDic setValue:@"123" forKey:@"key3-2"];
    [newItemDic setValue:@"123" forKey:@"key3-3"];
    [newItemDic setValue:@"123" forKey:@"key3-4"];
    [newItems addObject:newItemDic];
    
    
    [pasteBoard addItems:newItems];
    
    
}

@end
