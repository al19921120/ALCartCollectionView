//
//  ALCartCollectionViewLayout.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALCartCollectionViewLayout.h"
#import "ALStringUtils.h"

@interface ALCartCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *attrsArr;
@property (nonatomic, strong) NSMutableArray *attrsArrForHeader;
@property (nonatomic, strong) NSMutableArray *attrsArrForFooter;

@property (nonatomic, strong) NSMutableArray<NSMutableArray*> *strSizeArr;
@property (nonatomic, strong) NSMutableArray<NSNumber*> *sectionTopArr;

@end

@implementation ALCartCollectionViewLayout {

    CGFloat _oneLineHeight;
    
    CGFloat _curRowRemainWidth;  //当前行x剩余
    CGFloat _curRowTopForSection;//当前行y位置
}

#pragma mark - public

- (NSInteger)numOfLinesForIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    CGSize curSize = [_strSizeArr[section][row] CGSizeValue];
    NSInteger numOfLines = roundf((curSize.height / _oneLineHeight));
    
    return numOfLines;
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
    [self.attrsArrForFooter removeAllObjects];
    self.sectionTopArr = [NSMutableArray arrayWithObject:@0];//统一0和其他section
//    self.sectionTopArr = [NSMutableArray array];
    
    NSInteger section = _strSizeArr.count;
    for (NSInteger i = 0; i<section; i++) {

        
        NSInteger row = _strSizeArr[i].count;
        for (NSInteger j = 0; j<row; j++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
            
            
            [self.attrsArr addObject:attrs];
            
        }
        NSIndexPath *indexPathForHeader = [NSIndexPath indexPathForItem:0 inSection:i];
        UICollectionViewLayoutAttributes *attrsForHeader = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPathForHeader];
        [self.attrsArrForHeader addObject:attrsForHeader];
        
        if (i == section - 1) {

            NSIndexPath *indexPathForFooter = [NSIndexPath indexPathForItem:0 inSection:i];
            UICollectionViewLayoutAttributes *attrsForFooter = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPathForFooter];
            [self.attrsArrForHeader addObject:attrsForFooter];
            
        }
        
        
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
    return CGSizeMake(0, _curRowTopForSection - __kALCartHeaderHeight + __kALCartFooterHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    CGFloat totalRowWidth = self.collectionView.frame.size.width - 2*__kALCartCellXMargin;
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;

    CGSize curSize = [_strSizeArr[section][row] CGSizeValue];
    CGFloat curWidth = curSize.width;
    if (_isTextOneLine && curWidth > totalRowWidth) {
        curWidth = totalRowWidth;
    }
    if (curWidth < __kALCartMinItemWidth) {
        curWidth = __kALCartMinItemWidth;
    }
    
    CGFloat curHeight = curSize.height;
    NSInteger numOfLines = [self numOfLinesForIndexPath:indexPath];
    
    if (_isTextOneLine) {
        curHeight = __kALCartMinItemHeight;
    }
    else {
        curHeight = __kALCartMinItemHeight + (numOfLines-1) * _oneLineHeight;
    }
    
    
    //适配reloadSections
    if (_sectionTopArr.count >= indexPath.section + 1 && indexPath.row == 0) {
        _curRowTopForSection = [_sectionTopArr[indexPath.section] floatValue] + __kALCartHeaderHeight;
    }
    
    if (_curRowRemainWidth == totalRowWidth) {
        //每行第一个
        attrs.frame = CGRectMake(__kALCartCellXMargin, _curRowTopForSection, curWidth, curHeight);
        _curRowRemainWidth = _curRowRemainWidth - curWidth - __kALCartItemInteritemSpacing;
        
    }
    else {
        
        if (_curRowRemainWidth < __kALCartItemInteritemSpacing + curWidth) {
            //换行
            CGFloat lastHeight = 0;
            NSInteger numOfLines = [self numOfLinesForIndexPath:[NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section]];
            if (_isTextOneLine) {
                lastHeight = __kALCartMinItemHeight;
            }
            else {
                lastHeight = __kALCartMinItemHeight + (numOfLines-1) * _oneLineHeight;
            }
            
            _curRowTopForSection = _curRowTopForSection + lastHeight + __kALCartItemLineSpacing;
            _curRowRemainWidth = totalRowWidth;
            attrs.frame = CGRectMake(__kALCartCellXMargin, _curRowTopForSection, curWidth, curHeight);
            
        }
        else {
            
            CGFloat lastCellRight = totalRowWidth - _curRowRemainWidth + __kALCartCellXMargin;
            attrs.frame = CGRectMake(lastCellRight, _curRowTopForSection, curWidth, curHeight);
        }
        
        _curRowRemainWidth = _curRowRemainWidth - curWidth - __kALCartItemInteritemSpacing;
        
    }

//    NSLog(@"\n section=%ld, row=%ld\n right=%f, top=%f", section, row, attrs.frame.origin.x+attrs.frame.size.width, _curRowTopForSection);

    //section＋1，最后一个会多加1
    if (row == _strSizeArr[section].count - 1) {
        _curRowTopForSection = _curRowTopForSection + curHeight + __kALCartItemLineSpacing + __kALCartHeaderHeight;
        _curRowRemainWidth = totalRowWidth;
        [_sectionTopArr addObject:@(_curRowTopForSection - __kALCartHeaderHeight)];
    }
    
    return attrs;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    
    if (elementKind == UICollectionElementKindSectionHeader) {
        
        NSInteger idx = indexPath.section;

        CGFloat headerTop = [_sectionTopArr[idx] floatValue];

        attrs.frame = CGRectMake(0, headerTop, self.collectionView.frame.size.width, __kALCartHeaderHeight);
        
        return attrs;
    }
    
    if (elementKind == UICollectionElementKindSectionFooter) {
        
        CGFloat FooterTop = _curRowTopForSection - __kALCartHeaderHeight;
        
        attrs.frame = CGRectMake(0, FooterTop, self.collectionView.frame.size.width, __kALCartFooterHeight);
        
        return attrs;

    }
    
    
    return nil;

    
}

#pragma mark - set & get

- (void)setDataArr:(NSArray *)dataArr {
    
    _dataArr = dataArr;

    //取得内容长度
    _strSizeArr = [NSMutableArray array];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    CGFloat totalRowWidth = self.collectionView.frame.size.width - 2*__kALCartCellXMargin;
    
    _oneLineHeight = [ALStringUtils sizeOfStr:@"   " withFont:font withMaxWidth:totalRowWidth withLineBreakMode:NSLineBreakByCharWrapping].height;
    
    [_dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger section, BOOL * _Nonnull stop) {
       
        NSArray *subDataArr = [obj valueForKeyPath:self.dataListKey];
        NSMutableArray *tempArr = [NSMutableArray array];
        [subDataArr enumerateObjectsUsingBlock:^(id  _Nonnull subObj, NSUInteger row, BOOL * _Nonnull stop) {
            
            NSString *cellContentStr = [subObj valueForKeyPath:self.dataContentKey];

            CGSize strSize;
            strSize = [ALStringUtils sizeOfStr:cellContentStr withFont:font withMaxWidth:totalRowWidth withLineBreakMode:NSLineBreakByCharWrapping];
            strSize.width = strSize.width + __kALCartCellLabXMargin;
            
            NSValue *value = [NSValue valueWithCGSize:strSize];
            [tempArr addObject:value];
            
            
            
            
        }];
        [_strSizeArr addObject:tempArr];
        
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

- (NSMutableArray *)attrsArrForFooter {
    
    if (!_attrsArrForFooter) {
        _attrsArrForFooter = [NSMutableArray array];
    }
    return _attrsArrForFooter;
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
