//
//  CustomActionSheet.m
//  YYFocus
//
//  Created by anjun on 16/3/17.
//  Copyright © 2016年 anjun. All rights reserved.
//


#define ColorWithKey(obj) [UIColor colorWithKey:obj]


#import "CustomActionSheet.h"
#import "UIView+Extensions.h"
#import "UIColor+Extension.h"

@interface CustomActionSheet ()

/** 中间的按钮个数 */
@property (nonatomic, assign) NSInteger buttonTitlesCount;
/** 上方标题 */
@property (nonatomic, copy) NSString * title;
/** 中间连续的几个按钮文字 */
@property (nonatomic, copy) NSArray * otherButtonTitles;
/**  */
@property (nonatomic, weak) UIView * mainView;
/** 最下面的取消按钮 */
@property (nonatomic, weak) UIButton * cancelBtn;

@end

@implementation CustomActionSheet

- (id)initWithTitle:(NSString *)title otherButtonTitles:(NSArray *)otherButtonTitles
{
    if(self = [super init])
    {
        self.title = title;
        self.otherButtonTitles = otherButtonTitles;
        self.buttonTitlesCount = [otherButtonTitles count];
        [self createUI];
    }
    
    return self;
}

- (void)createUI
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    // 设置自己的frame为全屏
    self.frame = keyWindow.bounds;
    [keyWindow addSubview:self];
    
    // 透明度变化从0 -- 0.4:初始状态是隐藏的
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
  
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [self addGestureRecognizer:tap];
    
    // 1表示分割线的高度,48表示每一行的高度，4表示"取消"按钮上面的分割线高度
    CGFloat mainViewHeight = (52) + (1 + 48)*self.buttonTitlesCount;
    UIView * mainView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, mainViewHeight)];
    self.mainView = mainView;
    mainView.backgroundColor = [UIColor whiteColor];
    [self addSubview:mainView];
    
    CGFloat up = 0;
    if (self.title) {
        
        // 添加标题
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainView.frame.size.width, 48)];
        titleLabel.tag = 1000;
        titleLabel.text = self.title;
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = ColorWithKey(0x999999);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [mainView addSubview:titleLabel];
        up = titleLabel.bottom;
        mainViewHeight += 48;
        mainView.height = mainViewHeight;
    }
    
    // 添加多个按钮
    CGFloat bottomY = 0;
    for (int i = 0; i < self.buttonTitlesCount; i++) {
        CGFloat lineX = 0;
        CGFloat lineY = up + i*49;
        CGFloat lineW = self.width;
        CGFloat lineH = 1;
        
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
        lineView.backgroundColor = ColorWithKey(0xe5e5e5);
        [mainView addSubview:lineView];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(0, lineView.bottom, self.width, 48);
        [btn setTitle:self.otherButtonTitles[i] forState:UIControlStateNormal];
        [btn setTitleColor:ColorWithKey(0x333333) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:18];
        [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:btn];
        bottomY = btn.bottom;
    }
 
    // 添加深灰色分割线
    UIView * grayView = [[UIView alloc] initWithFrame:CGRectMake(0, bottomY, self.width, 4)];
    grayView.backgroundColor = ColorWithKey(0xd9d9d9);
    [mainView addSubview:grayView];
    
    // 取消按钮
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.tag = 1001;
    cancelBtn.frame = CGRectMake(0, grayView.bottom, self.width, 48);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:ColorWithKey(0x999999) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [cancelBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
}

- (void)show
{
    [UIView animateWithDuration:0.33 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.mainView.y = self.height - self.mainView.height;
    }];
}

- (void)closeView
{
    [UIView animateWithDuration:0.33 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.mainView.y = self.height;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickAction:(UIButton *)btn
{
    if([_delegate respondsToSelector:@selector(sheet:clickedButtonAtIndex:)])
    {
        [_delegate sheet:self clickedButtonAtIndex:btn.tag];
        [self closeView];
    }
}

- (void)setCancelTitle:(NSString *)cancelTitle{
    [self.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
}

@end
