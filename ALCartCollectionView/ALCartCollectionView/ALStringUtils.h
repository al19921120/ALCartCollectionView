//
//  ALStringUtils.h
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALStringUtils : NSObject

+ (CGSize)oneLineTextSizeWithStr:(NSString *)str withFont:(UIFont *)font;

+ (CGSize)sizeOfStr:(NSString *)str withFont:(UIFont *)font withMaxWidth:(CGFloat)width withLineBreakMode:(NSLineBreakMode)mode;

@end
