//
//  ALCartQuantityInputView.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/27.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALCartQuantityInputView.h"

//#define __kALCartQuantityBtnValueWidth  110
#define __kALCartQuantityBtnChangeWidth 40

@interface ALCartQuantityInputView ()

@property (nonatomic, strong) UIButton *btnReduce;
@property (nonatomic, strong) UIButton *btnAdd;
@property (nonatomic, strong) UIButton *btnValue;

@end

@implementation ALCartQuantityInputView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.minValue = 0;
        self.maxValue = 1;
        self.curValue = 1;
        
        [self initUI];
    }
    return self;
    
}

#pragma mark - init

- (void)initUI {
    
    self.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    self.layer.cornerRadius = 2;
    
    [self addSubview:self.btnAdd];
    [self addSubview:self.btnReduce];
    [self addSubview:self.btnValue];
    
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];

//    [self updateConstraints];
    [self.btnReduce addConstraint:[NSLayoutConstraint constraintWithItem:self.btnReduce
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:__kALCartQuantityBtnChangeWidth]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnReduce
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:1]];
    [self.btnReduce addConstraint:[NSLayoutConstraint constraintWithItem:self.btnReduce
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:nil
                                                               attribute:NSLayoutAttributeNotAnAttribute
                                                              multiplier:1.0
                                                                constant:self.frame.size.height - 2*1]];
    
    

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnValue
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:1]];
    [self.btnValue addConstraint:[NSLayoutConstraint constraintWithItem:self.btnValue
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1.0
                                                               constant:self.frame.size.height - 2*1]];
    
    
    
    [self.btnAdd addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd
                                                            attribute:NSLayoutAttributeWidth
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:__kALCartQuantityBtnChangeWidth]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:1]];
    [self.btnAdd addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.0
                                                             constant:self.frame.size.height - 2*1]];

    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnReduce
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:1]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnReduce
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.btnValue
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:-1]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnValue
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.btnAdd
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:-1]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.btnAdd
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:-1]];
    
}

#pragma mark - private

- (void)btnAction:(UIButton *)btn {
    
    ALCartQuantityType type = btn.tag - __kALCartQuantityBaseTag;
    
    if ([self.delegate respondsToSelector:@selector(alCartQuantityInputView:willChangeValue:type:)]) {
        [self.delegate alCartQuantityInputView:self willChangeValue:@(_curValue) type:type];
    }
    
    
    switch (type) {
        case ALCartQuantityTypeReduce:
            
            if (_curValue == _minValue) {
                
                if ([self.delegate respondsToSelector:@selector(alCartQuantityInputView:valueIsOutOfRangeWithType:)]) {
                    [self.delegate alCartQuantityInputView:self valueIsOutOfRangeWithType:type];
                }
                self.curValue = _minValue;
                
            }
            else {
                self.curValue = _curValue - 1;
            }
            
            break;

        case ALCartQuantityTypeAdd:
            
            if (_curValue == _maxValue) {
                
                if ([self.delegate respondsToSelector:@selector(alCartQuantityInputView:valueIsOutOfRangeWithType:)]) {
                    [self.delegate alCartQuantityInputView:self valueIsOutOfRangeWithType:type];
                }
                self.curValue = _maxValue;
            }
            else {
                self.curValue = _curValue + 1;
            }
            
            break;
            
        case ALCartQuantityTypeFree:
            

            
            break;
            
        default:
            break;
    }
    
    
    
}

- (BOOL)isValueOutOfRange:(NSInteger)newValue {
    
    BOOL isOutOfRange = NO;
    if (newValue > _maxValue) {
        
        if ([self.delegate respondsToSelector:@selector(alCartQuantityInputView:valueIsOutOfRangeWithType:)]) {
            [self.delegate alCartQuantityInputView:self valueIsOutOfRangeWithType:ALCartQuantityTypeAdd];
        }
        self.curValue = _maxValue;
        isOutOfRange = YES;
        
    }
    if (newValue < _minValue) {

        if ([self.delegate respondsToSelector:@selector(alCartQuantityInputView:valueIsOutOfRangeWithType:)]) {
            [self.delegate alCartQuantityInputView:self valueIsOutOfRangeWithType:ALCartQuantityTypeReduce];
        }
        self.curValue = _minValue;
        isOutOfRange = YES;
        
    }
    return isOutOfRange;
    
}

#pragma mark - set && get

- (UIButton *)btnReduce {
    
    if (!_btnReduce) {
        _btnReduce = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnReduce.translatesAutoresizingMaskIntoConstraints = NO;
        _btnReduce.tag = __kALCartQuantityBaseTag + ALCartQuantityTypeReduce;
        _btnReduce.backgroundColor = [UIColor whiteColor];
        _btnReduce.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnReduce setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnReduce setTitle:@"-" forState:UIControlStateNormal];
        [_btnReduce addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _btnReduce;
}

- (UIButton *)btnAdd {
    
    if (!_btnAdd) {
    
        _btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAdd.translatesAutoresizingMaskIntoConstraints = NO;
        _btnAdd.tag = __kALCartQuantityBaseTag + ALCartQuantityTypeAdd;
        _btnAdd.backgroundColor = [UIColor whiteColor];
        _btnAdd.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnAdd setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnAdd setTitle:@"+" forState:UIControlStateNormal];
        [_btnAdd addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnAdd;
    
}

- (UIButton *)btnValue {
    
    if (!_btnValue) {
   
        _btnValue = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnValue.translatesAutoresizingMaskIntoConstraints = NO;
        _btnValue.tag = __kALCartQuantityBaseTag + ALCartQuantityTypeFree;
        _btnValue.backgroundColor = [UIColor whiteColor];
        _btnValue.titleLabel.font = [UIFont systemFontOfSize:14];
        [_btnValue setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_btnValue setTitle:[NSString stringWithFormat:@"%ld", _curValue] forState:UIControlStateNormal];
        [_btnValue addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _btnValue;
    
}

- (void)setMinValue:(NSInteger)minValue {
    
    _minValue = minValue;
    if (_minValue < 0) {
        _minValue = 0;
    }
    if (_curValue < minValue) {
        self.curValue = _minValue;
    }
    
}

- (void)setMaxValue:(NSInteger)maxValue {
    
    _maxValue = maxValue;
    if (_maxValue < 0) {
        _maxValue = 0;
    }
    if (_curValue > _maxValue) {
        self.curValue = _maxValue;
    }
    
}

- (void)setCurValue:(NSInteger)curValue {
    
    if ([self isValueOutOfRange:curValue]) {
        return;
    }
    
    _curValue = curValue;
    [_btnValue setTitle:[NSString stringWithFormat:@"%ld", _curValue] forState:UIControlStateNormal];
    
}

@end
