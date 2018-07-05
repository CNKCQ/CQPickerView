//
//  CQPickerView.h
//  CQPickerView
//
//  Created by cnkcq on 06/20/2018.
//  Copyright © 2018 cnkcq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CQPickerEntity.h"

@class CQPickerView;
@class CQPickerViewCell;

typedef NS_ENUM(NSInteger, CQPickerViewDirection)
{
    CQHorizontal = 0,
    CQVertical
};

@protocol CQPickerViewDataSource <NSObject>
@optional

- (NSString *)pickerView:(CQPickerView *)pickerView titleForCellcellLabelInItem:(CQPickerEntity *)item;

@end

@protocol CQPickerViewDelegate <NSObject>
@optional
- (void)pickerView:(CQPickerView *)pickerView scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pickerView:(CQPickerView *)pickerView scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)pickerView:(CQPickerView *)pickerView scrollViewDidEndDragging:(UIScrollView *)scrollView;

- (void)pickerView:(CQPickerView *)pickerView willSelectItem:(CQPickerEntity *)item;
- (void)pickerView:(CQPickerView *)pickerView didSelectItem:(CQPickerEntity *)item;

@end

@interface CQPickerView : UIView

/*
 * 激活与非激活的文字颜色设置
 */
@property (nonatomic, strong) UIColor *activeItemColor;
@property (nonatomic, strong) UIColor *deactiveItemColor;

/*
 * picker的背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundPickerColor;

/* 显示的字体大小 */
@property (nonatomic, assign) CGFloat cellLabelFontSize;

/* 文字缩放的大小 */
@property (nonatomic, assign) CGFloat cellLabelFontZoomSize;

@property (nonatomic, readonly) CGSize itemCellSize;

/*
 * 激活区间
 */
@property (nonatomic, readonly) NSRange activeItems;

/*
 * 当前选中 item
 */
@property (nonatomic, assign) NSInteger currentItem;

@property (nonatomic, strong) NSNumber *startPoint;
@property (nonatomic, strong) NSNumber *endPoint;

@property (nonatomic, weak) id<CQPickerViewDelegate> delegate;
@property (nonatomic, weak) id<CQPickerViewDataSource> dataSource;

/*
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame itemCellSize:(CGSize)cellSize datas: (NSArray *)datas;

/*
 * 重载，刷新数据
 */
- (void)reloadData;

/*
 * Cell
 */
- (CQPickerViewCell *)cellForItem:(CQPickerEntity *)item;


@end
