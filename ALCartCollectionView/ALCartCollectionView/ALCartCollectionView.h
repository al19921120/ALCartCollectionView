//
//  ALCartCollectionView.h
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ALCartCollectionView;
@protocol ALCartCollectionViewDelegate <NSObject>

@end

@interface ALCartCollectionView : UICollectionView

@property (nonatomic, weak) id<ALCartCollectionViewDelegate> cartDelegate;

@property (nonatomic, strong) NSMutableArray *selectedDataArr;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *selectColor;

@end
