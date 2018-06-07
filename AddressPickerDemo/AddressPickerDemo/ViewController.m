//
//  ViewController.m
//  AddressPickerDemo
//
//  Created by try.lee on 2018/6/7.
//  Copyright © 2018年 GeeFan. All rights reserved.
//

#import "ViewController.h"
#import "LGAddressPicker.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *addressTF;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    self.addressTF.inputView = [LGAddressPicker addressPickerWithHeight:-200 PickOver:^(NSDictionary *addressDict) {
        
        NSLog(@"地区选择完毕！");
         [weakSelf.addressTF endEditing:YES];
        weakSelf.addressTF.text = [NSString stringWithFormat:@"%@%@%@",addressDict[@"province"], addressDict[@"city"], addressDict[@"area"]];
        
    } PickCancel:^{
        
        NSLog(@"您已取消选择地区！");
        [weakSelf.addressTF endEditing:YES];
        
    }];
}



@end
