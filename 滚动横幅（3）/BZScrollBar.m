//
//  BZScrollBar.m
//  BZScrollBar
//
//  Created by 蔡士林 on 16/1/22.
//  Copyright © 2016年 BZ. All rights reserved.
//

#import "BZScrollBar.h"

@interface BZScrollBar ()
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *imageViewArr;
@end

@implementation BZScrollBar

- (NSMutableArray *)imageViewArr
{
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    self.scrollView = scrollView;
    scrollView.pagingEnabled = YES;
    [self addSubview:scrollView];
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    for (int i = 0; i < datas.count + 2; i ++) {
        
        UILabel *label = [[UILabel alloc]init];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [self randomColor];
        [self.scrollView addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self.imageViewArr addObject:label];
        
        if (i == 0) {
            label.text = datas[datas.count - 1];
        }
        else if (i == datas.count + 1)
        {
            label.text = datas[0];
            label.backgroundColor = ((UILabel *)self.imageViewArr[1]).backgroundColor;
        }
        else if (i == datas.count)
        {
            label.text = datas[i - 1];
            label.backgroundColor = ((UILabel *)self.imageViewArr[0]).backgroundColor;
        }
        else
        {
            label.text = datas[i - 1];
        }
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollBar) userInfo:nil repeats:YES];
}

- (UIColor *)randomColor
{
    CGFloat red   = ((arc4random() % 255) + 1) / 255.0;
    CGFloat green = ((arc4random() % 255) + 1) / 255.0;
    CGFloat blue  = ((arc4random() % 255) + 1) / 255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentOffset = CGPointMake(0, self.bounds.size.height);
    CGFloat W = self.bounds.size.width;
    CGFloat H = self.bounds.size.height;
    self.scrollView.contentSize = CGSizeMake(1, self.imageViewArr.count * self.bounds.size.height);
    for (int i = 0 ; i < self.imageViewArr.count; i ++) {
        UILabel *label = self.imageViewArr[i];
        label.frame = CGRectMake(0, H * i, W, H);
    }
}

- (void)scrollBar
{
    if (self.scrollView.contentOffset.y >= self.scrollView.contentSize.height - self.scrollView.bounds.size.height) {
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.bounds.size.height);
    }
    CGPoint point = self.scrollView.contentOffset;
    point.y = point.y + self.scrollView.bounds.size.height;
    [UIView animateWithDuration:1 animations:^{
        self.scrollView.contentOffset = point;
    }];
}












@end