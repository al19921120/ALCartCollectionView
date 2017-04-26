//
//  ALStringUtils.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALStringUtils.h"

#define UpIOS7 [[[UIDevice currentDevice] systemVersion] doubleValue] >= 7.0

@implementation ALStringUtils

+ (CGSize)oneLineTextSizeWithStr:(NSString *)str withFont:(UIFont *)font {
    
    CGSize size;
    if (UpIOS7) {
        size = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    }
    else {
        size = [str sizeWithFont:font];
    }
    return size;
    
}


@end
