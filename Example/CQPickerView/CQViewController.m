//
//  CQViewController.m
//  CQPickerView
//
//  Created by cnkcq on 06/20/2018.
//  Copyright (c) 2018 cnkcq. All rights reserved.
//

#import "CQViewController.h"
#import "CQPickerView.h"

#define VI_HZBLUE_COLOR [UIColor colorWithRed:0/255.0 green:171/255.0 blue:253/255.0 alpha:1]

@interface CQViewController ()<CQPickerViewDelegate,CQPickerViewDataSource>{}
@property (nonatomic, strong) CQPickerView *pickerView;
@end

@implementation CQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.view.backgroundColor = VI_HZBLUE_COLOR;
        
    NSMutableArray<CQPickerEntity *> *datas = [NSMutableArray array];
    for (int i = 1; i < 8; i++) {;
        CQPickerEntity *entity = [[CQPickerEntity alloc] init];
        entity.text = [NSString stringWithFormat:@"%d", i];
        [datas addObject:entity];
    }
    self.pickerView = [[CQPickerView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width , 60) itemCellSize:CGSizeMake(60, 60) datas: [datas copy]];
    self.pickerView.cellLabelFontSize = 18.0f;
    self.pickerView.cellLabelFontZoomSize = 40.0f;
//    self.pickerView.deactiveItemColor = [UIColor colorWithRed:102 green:102 blue:102 alpha:1];
//    self.pickerView.deactiveItemColor = [UIColor blackColor];
    self.pickerView.activeItemColor = [UIColor blackColor];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    [self.view addSubview:self.pickerView];
}

#pragma mark - CQPickerViewDelegate & CQPickerViewDataSource
-(void)pickerView:(CQPickerView *)pickerView willSelectItem:(CQPickerEntity *)item {
    NSLog(@"🌹%@", item.text);
}

-(void)pickerView:(CQPickerView *)pickerView didSelectItem:(CQPickerEntity *)item {
     NSLog(@"🐈%@", item.text);
}

@end
