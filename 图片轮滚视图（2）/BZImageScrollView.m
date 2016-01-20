//
//  BZImageScrollView.m
//  668PetHotel
//
//  Created by 蔡士林 on 15/11/4.
//  Copyright © 2015年 wby. All rights reserved.
//

#import "BZImageScrollView.h"

@interface BZImageScrollView ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *mainScrollView;
@property (strong, nonatomic) UIImageView  *leftImageView;
@property (strong, nonatomic) UIImageView  *centerImageView;
@property (strong, nonatomic) UIImageView  *rightImageView;

@property (assign, nonatomic) NSInteger imageCount;
@property (assign, nonatomic) NSInteger currentImageIndex;

@property (strong, nonatomic) UIPageControl *pageControl;
@property (assign, nonatomic) NSInteger pageControlCurrentPage;
@property (strong, nonatomic)  NSTimer *timer;

@end

@implementation BZImageScrollView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
        _currentImageIndex = 0;
    }
    return self;
}


- (void)setUpUI
{
    _mainScrollView = [[UIScrollView alloc]init];
    _mainScrollView.delegate = self;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.showsVerticalScrollIndicator   = NO;
    _mainScrollView.pagingEnabled = YES;
    [self addSubview:_mainScrollView];

    _leftImageView = [self imageView];
    _centerImageView = [self imageView];
    _rightImageView = [self imageView];
    
    self.pageControl = [[UIPageControl alloc]init];
    [self addSubview:self.pageControl];
    self.pageControl.pageIndicatorTintColor = UIColorFromRGB(KPlaceHolderG);
    self.pageControl.currentPageIndicatorTintColor = UIColorFromRGB(kNormalOrange);
}


- (UIImageView *)imageView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    [_mainScrollView addSubview:imageView];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidClick:)];
    [imageView addGestureRecognizer:tapGes];
    return imageView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _mainScrollView.frame = self.bounds;
    
    _leftImageView.frame = CGRectMake(0, 0, self.width, self.height);
    _centerImageView.frame = CGRectMake(self.width, 0, self.width, self.height);
    _rightImageView.frame = CGRectMake(self.width * 2, 0, self.width, self.height);
    _mainScrollView.contentSize = CGSizeMake(self.width * 3, self.height);
    [_mainScrollView setContentOffset:CGPointMake(self.width, 0)];
    
    self.pageControl.centerX = self.self.width/2;
    self.pageControl.y = self.height - 20;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self mainScrollViewDidScroll:scrollView];
}

- (void)mainScrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((self.imageDatas.count != 0 && self.imageDatas != nil) || (self.photos.count != 0)) {
        NSInteger allPage = self.imageDatas.count != 0 ? self.imageDatas.count : self.photos.count;
        if (scrollView.contentOffset.x > self.width) {
            _currentImageIndex = (_currentImageIndex + 1) % self.imageCount;
            self.pageControlCurrentPage ++;
            if (self.pageControlCurrentPage >= allPage) {
                self.pageControlCurrentPage = 0;
            }
        }
        else if (scrollView.contentOffset.x < self.width)
        {
            _currentImageIndex = (_currentImageIndex + self.imageCount -1) % self.imageCount;
            self.pageControlCurrentPage --;
            if (self.pageControlCurrentPage < 0) {
                self.pageControlCurrentPage = allPage - 1;
            }
        }
        self.pageControl.currentPage = self.pageControlCurrentPage;
        if (self.imageDatas.count != 0) {
            [_leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imageDatas[(_currentImageIndex + _imageCount - 1) % _imageCount]] placeholderImage:PLACEHOLDER_BIG_IMAGE];
            [_rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imageDatas[(_currentImageIndex + 1) % self.imageCount]] placeholderImage:PLACEHOLDER_BIG_IMAGE];
            [_centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imageDatas[_currentImageIndex % self.imageCount]] placeholderImage:PLACEHOLDER_BIG_IMAGE];
        }
        else
        {
            [_leftImageView setImage:self.photos[(_currentImageIndex + _imageCount - 1) % self.imageCount]];
            [_rightImageView setImage:self.photos[(_currentImageIndex + 1) % self.imageCount]];
            [_centerImageView setImage:self.photos[_currentImageIndex % self.imageCount]];
        }
        [scrollView setContentOffset:CGPointMake(self.width, 0)];
    }

}

- (void)setImageDatas:(NSArray<NSString *> *)imageDatas
{
    _imageDatas = imageDatas;
    if (imageDatas.count == 0) {
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
        [_centerImageView sd_setImageWithURL:[NSURL URLWithString:imageDatas[0]] placeholderImage:PLACEHOLDER_BIG_IMAGE];
        self.imageCount = imageDatas.count;
        self.pageControl.numberOfPages = imageDatas.count;
        self.pageControl.currentPage = 0;
        self.currentImageIndex = 0;
        self.pageControlCurrentPage = 0;
    }
    if (self.isAutoScroll) {
        [self beginScroll];
    }
}

- (void)setPhotos:(NSArray<UIImage *> *)photos
{
    _photos = photos;
    if (photos.count == 0) {
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
        [_centerImageView setImage:photos[0]];
        self.imageCount = photos.count;
        self.pageControl.numberOfPages = photos.count;
        self.pageControl.currentPage = 0;
        self.currentImageIndex = 0;
        self.pageControlCurrentPage = 0;
    }
    if (self.isAutoScroll) {
        [self beginScroll];
    }
}

- (NSInteger)imageCount
{
    if (self.imageDatas.count == 0) {
        return self.photos.count;
    }
    return self.imageDatas.count;
}

- (void)imageViewDidClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(imageScrollViewDidClickImage:andImageData:)]) {
        [self.delegate imageScrollViewDidClickImage:self andImageData:((UIImageView *)tap.view).image];
    }
    if ([self.delegate respondsToSelector:@selector(imageScrollViewDidClickImage:andClickIndex:)]) {
        [self.delegate imageScrollViewDidClickImage:self andClickIndex:self.pageControl.currentPage];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

- (void)beginScroll
{
    NSTimer *timer = [ NSTimer timerWithTimeInterval:3 target:self selector:@selector(didAutoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    [timer setFireDate:[NSDate distantPast]];
    self.timer = timer;
}

- (void)didAutoScroll
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.mainScrollView setContentOffset:CGPointMake(self.width * 2, 0)];
    } completion:^(BOOL finshed) {
        [self mainScrollViewDidScroll:self.mainScrollView];
    }];
}

@end















