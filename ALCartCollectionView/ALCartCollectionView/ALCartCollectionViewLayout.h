//
//  ALCartCollectionViewLayout.h
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALCartCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, copy) NSString *groupTitleKey;//组头
@property (nonatomic, copy) NSString *dataListKey;//该组数据

@property (nonatomic, copy) NSString *dataContentKey;
@property (nonatomic, copy) NSString *selectedTagKey;//选中标志 NSNumber

@end
