//
//  ALCartCollectionView.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ALCartCollectionView.h"
#import "ALCartCollectionHeaderView.h"
#import "ALCartQuantityView.h"
#import "ALCartCollectionViewCell.h"
#import "ALCartCollectionViewLayout.h"

static NSString *CellID = @"ALCartCell";
static NSString *SectionHeaderID = @"ALCartSectionHeader";
static NSString *QuantityViewID = @"ALCartQuantityViewID";

@interface ALCartCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, ALCartQuantityInputViewDataDelegate>



@end

@implementation ALCartCollectionView {
    
    ALCartQuantityInputView *_inputView;
    
}

#pragma mark - dealloc

- (void)dealloc {
    
    
}

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.selectColor = [UIColor redColor];
        self.normalColor = [UIColor blackColor];
        
        [self registerClass:[ALCartCollectionViewCell class] forCellWithReuseIdentifier:CellID];
        
        [self registerClass:[ALCartCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SectionHeaderID];
        
        [self registerClass:[ALCartQuantityView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:QuantityViewID];
        
        self.dataSource = self;
        self.delegate = self;
        
        ALCartCollectionViewLayout *tempLayout = (ALCartCollectionViewLayout *)layout;
        _selectedDataArr = [NSMutableArray arrayWithCapacity:tempLayout.dataArr.count];
        
    }
    return self;
    
}

#pragma mark - cartDelegate

- (void)alCartQuantityInputView:(ALCartQuantityInputView *)quantityView didChangeValue:(NSNumber *)newValue {
    
    _curQuantity = [newValue integerValue];
    
}


#pragma mark - delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    ALCartCollectionViewLayout *layout = (ALCartCollectionViewLayout *)collectionView.collectionViewLayout;
    return layout.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    ALCartCollectionViewLayout *layout = (ALCartCollectionViewLayout *)collectionView.collectionViewLayout;
    NSArray *dataArr = [layout.dataArr[section] valueForKeyPath:layout.dataListKey];
    return dataArr.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
 
        ALCartCollectionViewLayout *layout = (ALCartCollectionViewLayout *)collectionView.collectionViewLayout;
        
        ALCartCollectionHeaderView *temp = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SectionHeaderID forIndexPath:indexPath];
        temp.lab.text = [layout.dataArr[indexPath.section] valueForKeyPath:layout.groupTitleKey];
        
        reusableView = temp;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        ALCartQuantityView *temp = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:QuantityViewID forIndexPath:indexPath];

        temp.quantityInputView.delegate = _quantityDelegate;
        temp.quantityInputView.dataDelegate = self;
        temp.quantityInputView.maxValue = _maxQuantity;
        temp.quantityInputView.minValue = _minQuantity;
        temp.quantityInputView.curValue = _curQuantity;
        temp.lab.text = @"数量";

        _inputView = temp.quantityInputView;
        
        reusableView = temp;
    }
    
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, __kALCartHeaderHeight);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(self.frame.size.width, __kALCartFooterHeight);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ALCartCollectionViewLayout *layout = (ALCartCollectionViewLayout *)collectionView.collectionViewLayout;
    NSArray *dataArr = [layout.dataArr[indexPath.section] valueForKeyPath:layout.dataListKey];
    id selObj = dataArr[indexPath.row];
    NSNumber *selectStatus = [selObj valueForKeyPath:layout.selectedTagKey];
    
    ALCartCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    cell.lab.text = [selObj valueForKeyPath:layout.dataContentKey];
    
    if ([selectStatus isEqualToNumber:@1]) {
        cell.lab.layer.borderColor = _selectColor.CGColor;
        cell.lab.textColor = _selectColor;
    }
    else {
        cell.lab.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.lab.textColor = _normalColor;
    }
    
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;

    ALCartCollectionViewLayout *layout = (ALCartCollectionViewLayout *)collectionView.collectionViewLayout;
    NSArray *dataArr = [layout.dataArr[section] valueForKeyPath:layout.dataListKey];
    id selObj = dataArr[row];
    
    
    NSNumber *selectStatus = [selObj valueForKeyPath:layout.selectedTagKey];
    if ([selectStatus isEqualToNumber:@1]) {
        [selObj setValue:@0 forKeyPath:layout.selectedTagKey];
        [_selectedDataArr removeObject:selObj];
        [self reloadData];
        return;
    }
    else {
        [selObj setValue:@1 forKeyPath:layout.selectedTagKey];
    }

    //去除同section之前选中的
    for (NSDictionary *tempDic in _selectedDataArr) {
        
        if ([tempDic[@"Section"] isEqualToNumber:@(section)]) {
            
            id lastSelObj = tempDic[@"Data"];
            [lastSelObj setValue:@0 forKeyPath:layout.selectedTagKey];
            [_selectedDataArr removeObject:tempDic];
            break;
        }
    }

    NSDictionary *selDic = @{
                             @"Section":@(section),
                             @"Data":selObj
                             };
    

    [_selectedDataArr addObject:selDic];
    [self reloadData];
    
}

#pragma mark - set & get

- (void)setCurQuantity:(NSInteger)curQuantity {
    
    _curQuantity = curQuantity;
    
    ALCartCollectionViewLayout *layout = (ALCartCollectionViewLayout *)self.collectionViewLayout;
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:layout.dataArr.count - 1];
    [UIView performWithoutAnimation:^{
        [self reloadSections:indexSet];
    }];
//    [self reloadData];
    
}

@end
