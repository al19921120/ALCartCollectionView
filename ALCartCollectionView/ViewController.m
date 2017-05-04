//
//  ViewController.m
//  ALCartCollectionView
//
//  Created by hwt on 17/4/25.
//  Copyright © 2017年 hwt. All rights reserved.
//

#import "ViewController.h"
#import "ALCartCollectionView.h"
#import "ALCartCollectionViewLayout.h"

@interface ViewController () <ALCartCollectionViewDelegate, ALCartQuantityInputViewDelegate>

@property (nonatomic, strong) ALCartCollectionView *collectView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    NSMutableDictionary *obj1 = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"abcdefgh", @"sel":@0}];
    NSMutableDictionary *obj2 = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"1234567899099999123123123123999999", @"sel":@0}];
    NSMutableDictionary *obj3 = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"hello,world!let's go!", @"sel":@0}];
    NSMutableDictionary *obj4 = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"worldworld worldworldworldworldworldworldworldworldworldworld", @"sel":@0}];
    NSMutableDictionary *obj5 = [NSMutableDictionary dictionaryWithDictionary:@{@"content":@"!!", @"sel":@0}];

    
    NSArray *arr = @[@{@"title":@"AAAA", @"list":@[obj1, obj2, obj3]}, @{@"title":@"BBBB", @"list":@[obj4, obj5]}];
    

    ALCartCollectionViewLayout *layout = [[ALCartCollectionViewLayout alloc] init];
    layout.isTextOneLine = NO;
    layout.dataContentKey = @"content";
    layout.dataListKey = @"list";
    layout.groupTitleKey = @"title";
    layout.selectedTagKey = @"sel";
    
    
    CGFloat width = self.view.frame.size.width;
    
    _collectView = [[ALCartCollectionView alloc] initWithFrame:CGRectMake((width - 300)/2.0, 100, 300, 150) collectionViewLayout:layout];
    _collectView.cartDelegate = self;
    _collectView.quantityDelegate = self;
    _collectView.maxQuantity = 10;
    _collectView.minQuantity = 2;
    
    layout.dataArr = arr;
    
    [self.view addSubview:_collectView];
    
    
}

- (IBAction)btnAction:(id)sender {
    
    NSLog(@"\n%@\n", _collectView.selectedDataArr);
    
}

- (void)alCartQuantityInputView:(ALCartQuantityInputView *)quantityView valueIsOutOfRangeWithType:(ALCartQuantityType)type {
    
    NSLog(@"\noutOfRange %ld\n", type);
    
}

- (void)alCartQuantityInputView:(ALCartQuantityInputView *)quantityView willChangeValue:(NSNumber *)oldValue type:(ALCartQuantityType)type {
    
    NSLog(@"\noldValue:%@", oldValue);
    if (type == ALCartQuantityTypeFree) {
        
        //弹窗等修改数值
        _collectView.curQuantity = 7;
    }
    
    
}



@end
