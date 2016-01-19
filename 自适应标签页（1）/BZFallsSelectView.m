//
//  BZFallsSelectView.m
//  668PetHotel
//
//  Created by 蔡士林 on 15/12/10.
//  Copyright © 2015年 wby. All rights reserved.
//

#define kMargin  15
#define kLeading 10
#define kBtnH    25
#import "BZFallsSelectView.h"
#import "BZButton.h"

@implementation BZFallsSelectViewModel

@end

@interface BZFallsSelectView ()
@property (strong, nonatomic) BZButton *allBtn;
@property (strong, nonatomic) NSMutableArray *btnArr;

@property (strong, nonatomic) UIButton *lastBtn;
@end

@implementation BZFallsSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultDatas = [NSArray array];
        self.fallsSelectViewType = BZFallsSelectViewTypeMultiSelect;
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    BZButton *allBtn = [self addSelectBtn:@"全选" data:nil];
    self.allBtn = allBtn;
}

- (BZButton *)addSelectBtn:(NSString *)title data:(BZFallsSelectViewModel *)data
{
    BZButton *btn = [[BZButton alloc]init];
    btn.data = data;
    btn.titleLabel.font = [UIFont systemFontOfSize:11];
    [btn setBackgroundImage:[UIImage resizeImageWithName:@"shezhi_xuanze_da_anxia"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizeImageWithName:@"shezhi_xuanze_da_zhengchang"] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:data.iconImage forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [btn  setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

- (void)btnDidClick:(BZButton *)sender
{
    if (self.fallsSelectViewType == BZFallsSelectViewTypeTag) {
        if ([self.delegate respondsToSelector:@selector(fallsSelectView:didSelected:)]) {
            [self.delegate fallsSelectView:self didSelected:sender.data];
        }
    }
    else if (self.fallsSelectViewType == BZFallsSelectViewTypeRadioSelect)
    {
        self.lastBtn.selected = NO;
        sender.selected = YES;
        self.lastBtn = sender;
    }
    else
    {
        sender.selected = !sender.isSelected;
        if ([sender.titleLabel.text isEqualToString:@"全选"]) {
            for (BZButton *btn in self.btnArr) {
                btn.selected = sender.isSelected;
            }
        }
    }
}

- (CGSize)sizeOfBtnWithString:(NSString *)title
{
    CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, kBtnH) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size;
    size = CGSizeMake(size.width + 20, kBtnH);
    return size;
}

- (void)setDatas:(NSArray<BZFallsSelectViewModel *> *)datas
{
    _datas = datas;
    for (UIButton *btn in self.btnArr) {
        [btn removeFromSuperview];
    }
    self.btnArr = nil;
    self.btnArr = [NSMutableArray array];
    for (BZFallsSelectViewModel *model in datas) {
        BZButton *btn = [self addSelectBtn:model.title data:model];
        for (BZFallsSelectViewModel *defaultModel in self.defaultDatas) {
            if ([model.title isEqualToString:defaultModel.title]) {
                btn.selected = YES;
                continue;
            }
        }
        [self.btnArr addObject:btn];
    }
    [self setUpLayout];
}

- (void)setDefaultDatas:(NSArray *)defaultDatas
{
    _defaultDatas = defaultDatas;
    if (self.btnArr.count > 0) {
        for (BZButton *btn in self.btnArr) {
            BZFallsSelectViewModel *btnModel = (BZFallsSelectViewModel *)btn.data;
            for (BZFallsSelectViewModel *defaultModel in self.defaultDatas) {
                if ([btnModel.title isEqualToString:defaultModel.title]) {
                    btn.selected = YES;
                    continue;
                }
            }
        }
    }
}

- (void)setUpLayout
{
    if (self.fallsSelectViewType == BZFallsSelectViewTypeMultiSelect) {
        self.allBtn.frame = CGRectMake(kMargin, 0, [self sizeOfBtnWithString:@"全部"].width,kBtnH);
    }
    else
    {
        self.allBtn.frame = CGRectMake(0, 0, 0, 0);
    }
    NSInteger currRow = 0;
    BZButton *lastBtn = self.allBtn;
    
    for (BZButton *btn in self.btnArr) {
        BZFallsSelectViewModel *btnModel = (BZFallsSelectViewModel *)btn.data;
        btn.width = [self sizeOfBtnWithString:btnModel.title].width;
        btn.height = kBtnH;
        btn.y = (kBtnH + kLeading) * currRow;
        CGFloat btnEndX = CGRectGetMaxX(lastBtn.frame) + kMargin + btn.width;
        if (btnEndX > self.maxWidth) {
            btn.x = kMargin;
            currRow ++;
            btn.y = (kBtnH + kLeading) * currRow;
        }
        else
        {
            btn.x = CGRectGetMaxX(lastBtn.frame) + kMargin;
        }
        lastBtn = btn;
    }
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(CGRectGetMaxY(lastBtn.frame));
    }];
    self.height = CGRectGetMaxY(lastBtn.frame);
}

- (NSMutableArray *)selectedDatas
{
    NSMutableArray *tempArr = [NSMutableArray array];
    for (BZButton *btn  in self.btnArr) {
        if (btn.isSelected) {
            [tempArr addObject:btn.data];
        }
    }
    return tempArr;
}

@end
