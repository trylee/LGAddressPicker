//
//  LGAddressPicker.h
//  LGPicker
//
//  Created by 李国 on 2017/6/21.
//  Copyright © 2017年 GoldenDays. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGAddressPicker : UIView

/**
 类方法加载地址选择器
 
 @param height 传入选择器高度（默认300）
 @param pickOver 传入选择完成的回调
 @param pickCancel 传入取消输入的回调
 @return 返回地址选择器
 */
+(LGAddressPicker *) addressPickerWithHeight:(CGFloat)height PickOver:(void(^)(NSDictionary * addressDict))pickOver PickCancel:(void(^)(void))pickCancel;

@end
