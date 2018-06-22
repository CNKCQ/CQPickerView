//
//  CQPickerView.m
//  HEMS
//
//  Created by cnkcq on 06/20/2018.
//  Copyright © 2018 cnkcq. All rights reserved.
//

#import "CQPickerView.h"
#import "CQPickerViewCell.h"

#define SCREEN_WIDTH    [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT   [UIScreen mainScreen].bounds.size.height
#define VI_HZBLUE_COLOR [UIColor colorWithRed:0 / 255.0 green:171 / 255.0 blue:253 / 255.0 alpha:1]

CGFloat const kDefaultcellLabelFontSize = 18.0f;

CGFloat const   kDefaultCellHeight = 60.0f;
CGFloat const   kDefaultCellWidth = 60.0f;

CGFloat const kDefaultMonthLabelMaxZoomValue = 12.0f;

NSInteger const kDefaultInitialInactiveItems = 8;
NSInteger const kDefaultFinalInactiveItems = 8;

#define kDefaultColorInactiveItem  [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1]

#define kDefaultColorBackground    [UIColor whiteColor]
#define kDefaultColorItem      [UIColor blackColor]

@interface CQPickerView () <UITableViewDelegate, UITableViewDataSource>{
    UILabel *yearLabel;
}

// initialFrame property is a hack for initWithCoder:
@property (nonatomic, assign) CGRect initialFrame;

@property (nonatomic, strong) NSIndexPath *currentIndex;

@property (nonatomic, assign) CGSize itemCellSize;

@property (nonatomic, assign) NSRange activeItems;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *tableMonthsData;

@end

@implementation CQPickerView

#pragma mark - 初始化方法

- (instancetype)initWithFrame:(CGRect)frame itemCellSize:(CGSize)cellSize datas: (NSArray *)datas {
    _itemCellSize = cellSize;
    _tableMonthsData = datas;
    if (self = [self initWithFrame:frame]) {
        [self fillTableDataWithCurrentItem];
        self.currentItem = 4;
    }
    return self;
}

- (void)setactiveItems:(NSRange)activeItems {
    _activeItems = activeItems;
    [self.tableView reloadData];
    [self setupTableViewContent];
}

- (void)setCurrentIndex:(NSIndexPath *)currentIndex {
    _currentIndex = currentIndex;
    //  手动计算ContentOffset
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:currentIndex];
    CGFloat contentOffset = cell.center.y - (self.tableView.frame.size.width / 2);
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, contentOffset) animated:YES];
    if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)]) {
        [self.delegate pickerView:self didSelectItem:self.tableMonthsData[currentIndex.row]];
    }
}

- (CQPickerViewCell *)cellForItem:(CQPickerEntity *)item {
    NSInteger index = [self.tableMonthsData indexOfObject:item];
    return (CQPickerViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)reloadData {
    [self.tableView reloadData];
    [self setupTableViewContent];
}

- (void)setFrame:(CGRect)frame {
    if (CGRectIsEmpty(self.initialFrame)) {
        self.initialFrame = frame;
    }
    [super setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _activeItemColor = kDefaultColorItem;
        _deactiveItemColor = kDefaultColorInactiveItem;
        _cellLabelFontZoomSize = kDefaultMonthLabelMaxZoomValue;
        _cellLabelFontSize = kDefaultcellLabelFontSize;
        
        // Make the UITableView's height the width, and width the height so that when we rotate it it will fit exactly
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin);
        
        // Rotate the tableview by 90 degrees so that it is side scrollable
        self.tableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.tableView.center = CGPointMake(frame.size.width / 2, frame.size.height  / 2);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.decelerationRate = UIScrollViewDecelerationRateFast;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        [self.tableView addGestureRecognizer:tapGesture];
        [self addSubview:self.tableView];
//        self.backgroundColor = VI_HZBLUE_COLOR;
        self.backgroundColor = [UIColor whiteColor];
        if (self.tableMonthsData.count < 2) {
            return self;
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.tableMonthsData.count / 2 inSection:0];
        [self setCurrentIndex:indexPath];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self setupTableViewContent];
    
    [self setCurrentIndex:_currentIndex];
}

- (void)setupTableViewContent {}

- (void)fillTableDataWithCurrentItem {
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)tapGesture {
    if (tapGesture.state == UIGestureRecognizerStateEnded) {
        CGPoint     location = [tapGesture locationInView:tapGesture.view];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        if (indexPath.row != self.currentIndex.row) {
            if ([self.delegate respondsToSelector:@selector(pickerView:willSelectItem:)]) {
                [self.delegate pickerView:self willSelectItem:self.tableMonthsData[indexPath.row]];
            }
            _currentItem = indexPath.row - 1;
            [self setCurrentIndex:indexPath];
        }
    }
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pickerView:scrollViewDidScroll:)]) {
        [self.delegate pickerView:self scrollViewDidScroll:scrollView];
    }
    
    CGPoint centerTableViewPoint = [self convertPoint:CGPointMake(self.frame.size.width / 2.0, self.itemCellSize.height / 2.0) toView:self.tableView];
    
    // Zooming visible cell's
    for (CQPickerViewCell *cell in self.tableView.visibleCells) {
        @autoreleasepool {
            // Distance between cell center point and center of tableView
            CGFloat distance = cell.center.y - centerTableViewPoint.y;
            
            // Zoom step using cosinus
            CGFloat zoomStep = cosf(M_PI_2 * distance / self.itemCellSize.width);
            
            if ((distance < self.itemCellSize.width) && (distance > -self.itemCellSize.width)) {
                cell.cellLabel.textColor = kDefaultColorItem;
                cell.cellLabel.font = [cell.cellLabel.font fontWithSize:self.cellLabelFontSize + self.cellLabelFontZoomSize * zoomStep];
                if (@available(iOS 8.2, *)) {
                    cell.cellLabel.font = [UIFont systemFontOfSize:(self.cellLabelFontZoomSize ?: self.cellLabelFontSize + 12) * zoomStep weight:UIFontWeightMedium * zoomStep];
                } else {
                    cell.cellLabel.font = [UIFont systemFontOfSize:(self.cellLabelFontZoomSize ?: self.cellLabelFontSize + 12) * zoomStep];
                }
                
            } else {
                cell.cellLabel.textColor = kDefaultColorInactiveItem;
                cell.cellLabel.font = [cell.cellLabel.font fontWithSize:self.cellLabelFontSize];
                if (@available(iOS 8.2, *)) {
                    cell.cellLabel.font = [UIFont systemFontOfSize: self.cellLabelFontSize ?: 14 weight:UIFontWeightRegular];
                } else {
                    cell.cellLabel.font = [UIFont systemFontOfSize:self.cellLabelFontSize ?: 14];
                }
            }
            
            if ((distance < self.itemCellSize.width / 2) && (distance > -self.itemCellSize.width / 2)) {
                cell.containerView.backgroundColor = self.backgroundPickerColor;
            } else {
                cell.containerView.backgroundColor = [UIColor clearColor];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(pickerView:scrollViewDidEndDecelerating:)]) {
        [self.delegate pickerView:self scrollViewDidEndDecelerating:scrollView];
    }
    [self scrollViewDidFinishScrolling:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(pickerView:scrollViewDidEndDragging:)]) {
        [self.delegate pickerView:self scrollViewDidEndDragging:scrollView];
    }

    if (!decelerate) {
        [self scrollViewDidFinishScrolling:scrollView];
    }
}

- (void)scrollViewDidFinishScrolling:(UIScrollView *)scrollView {
    CGPoint point = [self convertPoint:CGPointMake(self.frame.size.width / 2.0, self.itemCellSize.height / 2.0) toView:self.tableView];

    NSIndexPath *centerIndexPath = [self.tableView indexPathForRowAtPoint:CGPointMake(0, point.y)];

    if (centerIndexPath.row != self.currentIndex.row) {
        if ([self.delegate respondsToSelector:@selector(pickerView:willSelectItem:)]) {
            [self.delegate pickerView:self willSelectItem:self.tableMonthsData[centerIndexPath.row]];
        }
        _currentItem = centerIndexPath.row - 1;
        self.currentIndex = centerIndexPath;
    } else {
        // Go back to currentIndex
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:_currentIndex];
        CGFloat contentOffset = cell.center.y - (self.tableView.frame.size.width / 2);
        [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, contentOffset) animated:YES];
    }
}

#pragma mark - UITableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableMonthsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemCellSize.width;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"CQPickerViewCell";
    
    CQPickerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (!cell) {
        cell = [[CQPickerViewCell alloc] initWithSize:self.itemCellSize reuseIdentifier:reuseIdentifier];
    }
    
    CQPickerEntity *month = self.tableMonthsData[indexPath.row];
    
    // Bug: 有时候点击的时候row并没有被选中，所以不能在didselect中统一处理，我添加了一个tap手势😉
    [cell setUserInteractionEnabled:NO];
    
    cell.cellLabel.font = [cell.cellLabel.font fontWithSize:self.cellLabelFontSize];
    cell.cellLabel.text = month.text;
    
    if (indexPath.row == _currentIndex.row) {
        cell.cellLabel.textColor = self.activeItemColor ?: kDefaultColorItem;
        cell.containerView.backgroundColor = self.backgroundPickerColor;
        if (@available(iOS 8.2, *)) {
            cell.cellLabel.font = [UIFont systemFontOfSize:40 weight:UIFontWeightMedium];
        } else {
            cell.cellLabel.font = [cell.cellLabel.font fontWithSize:40];
        }
    } else {
        cell.cellLabel.textColor = self.deactiveItemColor ?: kDefaultColorInactiveItem;
        cell.containerView.backgroundColor = [UIColor clearColor];
        if (@available(iOS 8.2, *)) {
            cell.cellLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
        } else {
            cell.cellLabel.font = [UIFont systemFontOfSize:18];
        }
    }
    return cell;
}

@end
