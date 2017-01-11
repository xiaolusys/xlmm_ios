//
//  JMTagView.h
//  XLMM
//
//  Created by zhang on 17/1/11.
//  Copyright © 2017年 上海己美. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@class JMTagModel;
@interface JMTagView : UIView

@property (assign, nonatomic) UIEdgeInsets padding;
@property (assign, nonatomic) CGFloat lineSpacing;
@property (assign, nonatomic) CGFloat interitemSpacing;
@property (assign, nonatomic) CGFloat preferredMaxLayoutWidth;
@property (assign, nonatomic) CGFloat regularWidth; // 固定宽度
@property (nonatomic,assign ) CGFloat regularHeight; // 固定高度
@property (assign, nonatomic) BOOL singleLine;
@property (copy, nonatomic, nullable) void (^didTapTagAtIndex)(NSUInteger index);

- (void)addTag: (nonnull JMTagModel *)tag;
- (void)insertTag: (nonnull JMTagModel *)tag atIndex:(NSUInteger)index;
- (void)removeTag: (nonnull JMTagModel *)tag;
- (void)removeTagAtIndex: (NSUInteger)index;
- (void)removeAllTags;

@end



@interface JMTagButton : UIButton

+ (nonnull instancetype)buttonWithTag:(nonnull JMTagModel *)tag;

@end


@interface JMTagModel : NSObject

@property (copy, nonatomic, nullable) NSString *text;
@property (copy, nonatomic, nullable) NSAttributedString *attributedText;
@property (strong, nonatomic, nullable) UIColor *textColor;

// 背景颜色 设置
@property (strong, nonatomic, nullable) UIColor *bgColor;
@property (strong, nonatomic, nullable) UIColor *highlightedBgColor;
// 背景图片 设置
@property (strong, nonatomic, nullable) UIImage *bgImg;
@property (assign, nonatomic) CGFloat cornerRadius;
@property (strong, nonatomic, nullable) UIColor *borderColor;
@property (assign, nonatomic) CGFloat borderWidth;
// 设置控件位置的 边距
@property (assign, nonatomic) UIEdgeInsets padding;
@property (strong, nonatomic, nullable) UIFont *font;

@property (assign, nonatomic) CGFloat fontSize;
// 默认为YES
@property (assign, nonatomic) BOOL enable;

- (nonnull instancetype)initWithText: (nonnull NSString *)text;
+ (nonnull instancetype)tagWithText: (nonnull NSString *)text;


@end




