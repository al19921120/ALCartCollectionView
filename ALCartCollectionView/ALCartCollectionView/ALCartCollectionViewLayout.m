//
//  ALCartCollectionViewLayout.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALCartCollectionViewLayout.h"
#import "ALStringUtils.h"

#define __kALCartCellXMargin 20

#define __kALCartItemLineSpacing 10
#define __kALCartItemInteritemSpacing 10
#define __kALCartItemHeight 40
#define __kALCartHeaderHeight 40

@interface ALCartCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *attrsArr;
@property (nonatomic, strong) NSMutableArray *attrsArrForHeader;

@property (nonatomic, strong) NSMutableArray<NSMutableArray*> *strWidthArr;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *sectionTopArr;

@end

@implementation ALCartCollectionViewLayout {
    CGFloat _curRowRemainWidth;  //当前行x剩余
    CGFloat _curRowTopForSection;//当前行y位置
}


#pragma mark - private

- (void)prepareLayout {
    [super prepareLayout];
    
    //    self.itemSize
    //    self.
    _curRowRemainWidth = self.collectionView.frame.size.width - 2*__kALCartCellXMargin;
    _curRowTopForSection = __kALCartHeaderHeight;
    
    [self.attrsArr removeAllObjects];
    [self.attrsArrForHeader removeAllObjects];
    self.sectionTopArr = [NSMutableArray arrayWithObject:@(__kALCartHeaderHeight)];//统一0和其他section
    
    NSInteger section = _strWidthArr.count;
    for (NSInteger i = 0; i<section; i++) {

        
        NSInteger row = _strWidthArr[i].count;
        for (NSInteger j = 0; j<row; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            
            [self.attrsArr addObject:attrs];
            
        }
        NSIndexPath *indexPathForHeader = [NSIndexPath indexPathForItem:0 inSection:i];
        UICollectionViewLayoutAttributes *attrsForHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPathForHeader];
        [self.attrsArrForHeader addObject:attrsForHeader];
        
    }
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSMutableArray *tempAttrsArr = [NSMutableArray array];

    [_attrsArr enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempAttrsArr addObject:obj];
    }];
    
    [_attrsArrForHeader enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tempAttrsArr addObject:obj];
    }];
    
    
    return tempAttrsArr;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, _curRowTopForSection);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat totalRowWidth = self.collectionView.frame.size.width - 2*__kALCartCellXMargin;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;


    CGFloat curWidth = [_strWidthArr[section][row] floatValue];
    if (curWidth > totalRowWidth) {
        curWidth = totalRowWidth;
    }
    if (curWidth < 60) {
        curWidth = 60;
    }
    
    if (_curRowRemainWidth == totalRowWidth) {
        //每行第一个
        attrs.frame = CGRectMake(__kALCartCellXMargin, _curRowTopForSection, curWidth, __kALCartItemHeight);
        _curRowRemainWidth = _curRowRemainWidth - curWidth - __kALCartItemInteritemSpacing;
        
    }
    else {
        
        if (_curRowRemainWidth < __kALCartItemInteritemSpacing + curWidth) {
            //换行
            _curRowTopForSection = _curRowTopForSection + __kALCartItemHeight + __kALCartItemLineSpacing;
            _curRowRemainWidth = totalRowWidth;
            attrs.frame = CGRectMake(__kALCartCellXMargin, _curRowTopForSection, curWidth, __kALCartItemHeight);
            
        }
        else {
            
            CGFloat lastCellRight = totalRowWidth - _curRowRemainWidth + __kALCartCellXMargin;
            attrs.frame = CGRectMake(lastCellRight, _curRowTopForSection, curWidth, __kALCartItemHeight);
        }
        
        _curRowRemainWidth = _curRowRemainWidth - curWidth - __kALCartItemInteritemSpacing;
        
    }

//    NSLog(@"\n section=%ld, row=%ld\n right=%f", section, row, attrs.frame.origin.x+attrs.frame.size.width);

    //attrs.size
    //section＋1
    if (row == _strWidthArr[section].count - 1) {
        _curRowTopForSection = _curRowTopForSection + __kALCartItemHeight + __kALCartItemLineSpacing + __kALCartHeaderHeight;
        _curRowRemainWidth = totalRowWidth;
    }
    if (section != 0 && row == 0) {
        [_sectionTopArr addObject:@(_curRowTopForSection)];
    }
    
    return attrs;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        
        //    UICollectionViewLayoutAttributes *attrs = _attrsArrForHeader[indexPath.section];
        
        UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
        NSInteger idx = indexPath.section;

        CGFloat headerTop = [_sectionTopArr[idx] floatValue] - __kALCartHeaderHeight;

        attrs.frame = CGRectMake(0, headerTop, self.collectionView.frame.size.width, __kALCartHeaderHeight);
        
        return attrs;
    }
    
    return nil;

    
}

#pragma mark - set & get

- (void)setDataArr:(NSArray *)dataArr {
    
    _dataArr = dataArr;

    //取得内容长度
    _strWidthArr = [NSMutableArray array];
    [_dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger section, BOOL * _Nonnull stop) {
       
        NSArray *subDataArr = [obj valueForKeyPath:self.dataListKey];
        NSMutableArray *tempArr = [NSMutableArray array];
        [subDataArr enumerateObjectsUsingBlock:^(id  _Nonnull subObj, NSUInteger row, BOOL * _Nonnull stop) {
            
            NSString *cellContentStr = [subObj valueForKeyPath:self.dataContentKey];
            
            CGSize strSize = [ALStringUtils oneLineTextSizeWithStr:cellContentStr withFont:[UIFont systemFontOfSize:13]];
            NSNumber *width = @(strSize.width + 15);
            [tempArr addObject:width];
            
        }];
        [_strWidthArr addObject:tempArr];
        
    }];
    
}

- (NSMutableArray *)attrsArr {
    
    if(!_attrsArr) {
        _attrsArr = [NSMutableArray array];
    }
    return _attrsArr;
}

- (NSMutableArray *)attrsArrForHeader {
    
    if (!_attrsArrForHeader) {
        _attrsArrForHeader = [NSMutableArray array];
    }
    return _attrsArrForHeader;
}

- (NSMutableArray<NSNumber *> *)sectionTopArr {
    
    if (!_sectionTopArr) {
        _sectionTopArr = [NSMutableArray array];
    }
    return _sectionTopArr;
}

- (NSString *)groupTitleKey {
    
    if (!_groupTitleKey) {
        return @"";
    }
    return _groupTitleKey;

}

- (NSString *)dataListKey {
    
    if (!_dataListKey) {
        return @"";
    }
    return _dataListKey;
    
}

- (NSString *)dataContentKey {
    
    if (!_dataContentKey) {
        return @"";
    }
    return _dataContentKey;
    
}

- (NSString *)selectedTagKey {
    
    if (!_selectedTagKey) {
        return @"";
    }
    return _selectedTagKey;
}

@end
