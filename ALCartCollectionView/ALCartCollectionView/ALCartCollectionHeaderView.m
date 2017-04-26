//
//  ALCartCollectionHeaderView.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/26.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALCartCollectionHeaderView.h"

@implementation ALCartCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
    
}

#pragma mark - init

- (void)initUI {
    
    [self addSubview:self.lab];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:20]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0]];
    [self.lab addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:nil
                                                         attribute:NSLayoutAttributeNotAnAttribute
                                                        multiplier:1.0
                                                          constant:30]];
    
}

#pragma mark - set && get

- (UILabel *)lab {
    
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.font = [UIFont systemFontOfSize:14];
        _lab.translatesAutoresizingMaskIntoConstraints = NO;
        _lab.textAlignment = NSTextAlignmentLeft;
    }
    return _lab;
    
}

@end
