//
//  ALCartCollectionViewLayout.h
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import <UIKit/UIKit.h>


#define __kALCartCellXMargin 20

#define __kALCartCellLabXMargin 15

#define __kALCartItemLineSpacing 10
#define __kALCartItemInteritemSpacing 10
#define __kALCartMinItemWidth 60
#define __kALCartMinItemHeight 40
#define __kALCartHeaderHeight 40
#define __kALCartFooterHeight 60


@interface ALCartCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, strong) NSArray *dataArr; //设置collectionView后设置

@property (nonatomic, copy) NSString *groupTitleKey;//组头
@property (nonatomic, copy) NSString *dataListKey;//该组数据

@property (nonatomic, copy) NSString *dataContentKey;
@property (nonatomic, copy) NSString *selectedTagKey;//选中标志 NSNumber

@property (nonatomic, assign) BOOL isTextOneLine;

- (NSInteger)numOfLinesForIndexPath:(NSIndexPath *)indexPath;

@end
