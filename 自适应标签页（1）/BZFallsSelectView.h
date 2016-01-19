//
//  BZFallsSelectView.h
//  668PetHotel
//
//  Created by 蔡士林 on 15/12/10.
//  Copyright © 2015年 wby. All rights reserved.

//  需要使用Masonry

typedef enum : NSUInteger {
    BZFallsSelectViewTypeMultiSelect, // default 多选标签
    BZFallsSelectViewTypeRadioSelect, // 单选标签
    BZFallsSelectViewTypeTag,         // 点击标签
} BZFallsSelectViewType;

#import <UIKit/UIKit.h>
/// 标签的数据源协议
@interface BZFallsSelectViewModel : NSObject
/// 标签标题
@property (copy, nonatomic) NSString *title;
/// 标签携带的数据
@property (strong, nonatomic) id data;
/// 标签的图片
@property (strong, nonatomic) UIImage *iconImage;
@end

@class BZFallsSelectView;
@protocol BZFallsSelectViewDelegate <NSObject>
/**
 *	@brief  点击标签时触发
 */
- (void)fallsSelectView:(BZFallsSelectView *)fallsSelectView didSelected:(BZFallsSelectViewModel *)selectedModel;

@end

@interface BZFallsSelectView : UIView
/// 所有的选项数据
@property (strong, nonatomic) NSArray<BZFallsSelectViewModel *> *datas;
/// 默认选中的值
@property (strong, nonatomic) NSArray<BZFallsSelectViewModel *> *defaultDatas;
/// 最大宽度（使用masonry自动布局，所以需要知道）
@property (assign, nonatomic) CGFloat maxWidth;
/// 选中后的值
@property (strong, nonatomic) NSMutableArray<BZFallsSelectViewModel *> *selectedDatas;
/// 标签页类型
@property (assign, nonatomic) BZFallsSelectViewType fallsSelectViewType;
/// 代理协议
@property (weak, nonatomic) id <BZFallsSelectViewDelegate> delegate;
/// 布局完成后当前视图的高度
@property (assign, nonatomic) CGFloat currentHeight;
@end