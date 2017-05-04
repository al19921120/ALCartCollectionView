//
//  ALCartCollectionViewCell.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALCartCollectionViewCell.h"

@implementation ALCartCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
    
}

#pragma mark - init

- (void)initUI {
    
    [self addSubview:self.lab];
    [self addSubview:self.viewBg];
    
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
                                                      constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1.0
                                                              constant:-5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.lab
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:-5]];
    
    
    
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewBg
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewBg
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewBg
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:5]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.viewBg
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:-5]];
    

    
    self.viewBg.layer.borderWidth = 1;
    self.viewBg.layer.cornerRadius = 3;

}

#pragma mark - set && get

- (UILabel *)lab {
    
    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.font = [UIFont systemFontOfSize:13];
        _lab.translatesAutoresizingMaskIntoConstraints = NO;
        _lab.textAlignment = NSTextAlignmentLeft;
        _lab.lineBreakMode = NSLineBreakByCharWrapping;
        _lab.numberOfLines = 0;
    }
    return _lab;
    
}

- (UIView *)viewBg {
    
    if (!_viewBg) {
        _viewBg = [[UIView alloc] init];
        _viewBg.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _viewBg;
    
}

@end
