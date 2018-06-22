//
//  CQPickerViewCell.h
//  CQPickerView
//
//  Created by cnkcq on 06/20/2018.
//  Copyright © 2018 cnkcq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CQPickerViewCell : UITableViewCell

@property (nonatomic, readonly) UIView *containerView;
@property (nonatomic, readonly) UILabel *cellLabel;

- (UITableViewCell *)initWithSize:(CGSize)size reuseIdentifier:(NSString *)reuseIdentifier;

@end
