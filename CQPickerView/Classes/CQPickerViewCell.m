//
//  CQPickerViewCell.m
//  CQPickerView
//
//  Created by cnkcq on 06/20/2018.
//  Copyright © 2018 cnkcq. All rights reserved.
//

#import "CQPickerViewCell.h"

@interface CQPickerViewCell(){}

@property (nonatomic,assign) CGSize cellSize;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *cellLabel;
@end

@implementation CQPickerViewCell

- (UITableViewCell *)initWithSize:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        
        if (CGSizeEqualToSize(size, CGSizeZero))
            [NSException raise:NSInvalidArgumentException format:@"CQPickerViewCell size can't be zero!"];
        else
            self.cellSize = size;
        
        [self applyCellStyle];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithSize:CGSizeZero reuseIdentifier:reuseIdentifier];
    if (self) {}
    return self;
}

- (void)applyCellStyle
{
    UIView* containingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
    
    self.cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.cellSize.width, self.cellSize.height)];
    self.cellLabel.center = CGPointMake(containingView.frame.size.width/2, self.cellSize.height/2);
    self.cellLabel.textAlignment = NSTextAlignmentCenter;
    self.cellLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:self.cellLabel.font.pointSize];
    self.cellLabel.backgroundColor = [UIColor clearColor];
    [containingView addSubview: self.cellLabel];
    
    self.containerView = containingView;
    
    [containingView setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    [self addSubview:containingView];
    if (self.cellSize.width != self.cellSize.height) {
        containingView.frame = CGRectMake(0, 0, self.cellSize.height, self.cellSize.width);
    }
}


@end
