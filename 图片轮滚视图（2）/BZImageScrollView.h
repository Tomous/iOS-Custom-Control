//
//  BZImageScrollView.h
//  668PetHotel
//
//  Created by 蔡士林 on 15/11/4.
//  Copyright © 2015年 wby. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BZImageScrollView;

@protocol BZImageScrollViewDelegate <NSObject>
/// 点击的图片内容
- (void)imageScrollViewDidClickImage:(BZImageScrollView *)imageScrollView andImageData:(UIImage *)image;
/// 点击的图片下标
- (void)imageScrollViewDidClickImage:(BZImageScrollView *)imageScrollView andClickIndex:(NSInteger)index;
@end


@interface BZImageScrollView : UIView

/// 要滚动显示的图片url数组
@property (strong, nonatomic) NSArray<NSString *> *imageDatas;
/// 要滚动的图片数组（如果有url数组则失效）
@property (strong, nonatomic) NSArray<UIImage *>* photos;

@property (assign, nonatomic) id <BZImageScrollViewDelegate> delegate;
/// 自动滚动
@property (assign, nonatomic, getter=isAutoScroll) BOOL autoScroll;

@end
