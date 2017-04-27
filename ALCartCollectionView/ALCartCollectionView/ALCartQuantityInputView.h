//
//  ALCartQuantityInputView.h
//  ALCartCollectionView
//
//  Created by hwt on 17/4/27.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import <UIKit/UIKit.h>

#define __kALCartQuantityBaseTag 100

typedef NS_ENUM(NSUInteger, ALCartQuantityType) {
    ALCartQuantityTypeAdd,
    ALCartQuantityTypeReduce,
    ALCartQuantityTypeFree,
};

@class ALCartQuantityInputView;
@protocol ALCartQuantityInputViewDelegate <NSObject>

- (void)alCartQuantityInputView:(ALCartQuantityInputView *)quantityView willChangeValue:(NSNumber *)oldValue type:(ALCartQuantityType)type;

- (void)alCartQuantityInputView:(ALCartQuantityInputView *)quantityView valueIsOutOfRangeWithType:(ALCartQuantityType)type;

@end


@interface ALCartQuantityInputView : UIView

@property (nonatomic, weak) id<ALCartQuantityInputViewDelegate> delegate;

@property (nonatomic, assign) NSInteger maxValue;
@property (nonatomic, assign) NSInteger minValue;
@property (nonatomic, assign) NSInteger curValue;

@end
