//
//  LGAddressPicker.m
//  LGPicker
//
//  Created by 李国 on 2017/6/21.
//  Copyright © 2017年 GoldenDays. All rights reserved.
//

#import "LGAddressPicker.h"

#define ScreenSize [UIScreen mainScreen].bounds.size
#define GetWidth(view) [self getViewWidth:view]
#define SetWidth(view,width) [self setViewWidth:view Width:width]
#define GetTextWidth(text) [self getWidthWithText:text]
#define TinyColor [UIColor colorWithRed:0 green:153/255.0 blue:1 alpha:1]

@interface LGAddressPicker()<UITableViewDataSource, UITableViewDelegate>
/**
 子视图
 */
@property (nonatomic, strong) UIButton * provinceButton;
@property (nonatomic, strong) UIButton * cityButton;
@property (nonatomic, strong) UIButton * areaButton;
@property (nonatomic,strong) UITableView *provinceTabView;
@property (nonatomic,strong) UITableView *cityTabView;
@property (nonatomic,strong) UITableView *areaTabView;
@property (nonatomic,strong) UIScrollView *scroView;
@property (nonatomic,strong) UIView *indicator;

/**
 变量
 */
@property (nonatomic, strong) void(^pickOver)(id content);
@property (nonatomic, strong) void(^pickCancel)(void);
@property (nonatomic, strong) NSArray * provinces;
@property (nonatomic, strong) NSArray * cities;
@property (nonatomic, strong) NSArray * areas;
@property (nonatomic, assign) NSInteger provinceSelectIndex;
@property (nonatomic, assign) NSInteger citySelectIndex;
@property (nonatomic, assign) NSInteger areaSelectIndex;

@end

@implementation LGAddressPicker

#pragma mark - 类方法
/**
 类方法加载地址选择器
 
 @param height 传入选择器高度（默认300）
 @param pickOver 传入选择完成的回调
 @param pickCancel 传入取消输入的回调
 @return 返回地址选择器
 */
+(LGAddressPicker *) addressPickerWithHeight:(CGFloat)height PickOver:(void(^)(NSDictionary * addressDict))pickOver PickCancel:(void(^)(void))pickCancel
{
    if (height <=0 ) height=300;
    LGAddressPicker * picker = [[LGAddressPicker alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    picker.pickOver = pickOver;
    picker.pickCancel = pickCancel;
    
    return picker;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 解析地址plist文件
        NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
        self.provinces = dict[@"address"];
        
        // 先给索引初始化一个负值
        self.provinceSelectIndex = -1;
        self.citySelectIndex = -1;
        self.areaSelectIndex = -1;
        
        // 初始化子视图
        [self setupChildViews];
    }
    return self;
}


#pragma mark - 事件监听
/**
 点击关闭按钮
 */
-(void) closeButtonClick
{
    if (self.pickCancel) self.pickCancel();
}

/**
 点击省份按钮
 */
-(void) provinceButtonClick
{
    self.citySelectIndex = -1;
    self.areaSelectIndex = -1;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scroView.contentOffset = CGPointMake(0, 0);
        self.indicator.transform = CGAffineTransformIdentity;
        SetWidth(self.indicator, GetWidth(self.provinceButton));
        
        self.cityButton.transform = CGAffineTransformIdentity;
        self.cityButton.alpha = 0;
        self.areaButton.transform = CGAffineTransformIdentity;
        self.areaButton.alpha = 0;
    }];
}

/**
 点击城市按钮
 */
-(void) cityButtonClick
{
    self.areaSelectIndex = -1;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.scroView.contentOffset = CGPointMake(ScreenSize.width, 0);
        self.indicator.transform = CGAffineTransformMakeTranslation(self.provinceButton.frame.size.width, 0);
        SetWidth(self.indicator, GetWidth(self.cityButton));
        
        self.areaButton.transform = CGAffineTransformIdentity;
        self.areaButton.alpha = 0;
    }];
}

/**
 点击区域按钮
 */
-(void) areaButtonClick
{
    [UIView animateWithDuration:0.5 animations:^{
        self.indicator.transform = CGAffineTransformMakeTranslation(CGRectGetMaxX(self.cityButton.frame), 0);
        SetWidth(self.indicator, GetWidth(self.areaButton));
        
        self.scroView.contentOffset = CGPointMake(ScreenSize.width * 2, 0);
    }];
}

#pragma mark - 数据源
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.provinceTabView)
    {
        return self.provinces.count;
    }
    else if (tableView == self.cityTabView)
    {
        return self.cities.count;
    }
    else
    {
        return self.areas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"addressCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    if (tableView == self.provinceTabView)
    {
        cell.textLabel.text = self.provinces[indexPath.row][@"name"];
        if (indexPath.row == self.provinceSelectIndex)
        {
            cell.textLabel.textColor = TinyColor;
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    else if (tableView == self.cityTabView)
    {
        cell.textLabel.text = self.cities[indexPath.row][@"name"];
        if (indexPath.row == self.citySelectIndex)
        {
            cell.textLabel.textColor = TinyColor;
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    else
    {
        cell.textLabel.text = self.areas[indexPath.row];
        if (indexPath.row == self.areaSelectIndex)
        {
            cell.textLabel.textColor = TinyColor;
        }
        else
        {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - 代理
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.provinceTabView)
    {
        // 选中行字体变红
        self.provinceSelectIndex = indexPath.row;
        [self.provinceTabView reloadData];
        
        // 设置按钮标题
        [self.provinceButton setTitle:self.provinces[indexPath.row][@"name"] forState:UIControlStateNormal];
        SetWidth(self.provinceButton, GetTextWidth(self.provinceButton.titleLabel.text));
        
        // 加载下一TabView数据
        self.cities = self.provinces[indexPath.row][@"sub"];
        [self.cityTabView reloadData];
        
        // 设置城市按钮内容
        [self.cityButton setTitle:@"请选择" forState:UIControlStateNormal];
        SetWidth(self.cityButton, GetTextWidth(self.cityButton.titleLabel.text));
        
        // 设置指示器宽度
        SetWidth(self.indicator,GetWidth(self.cityButton));
        
        // 执行相关动画
        [UIView animateWithDuration:0.5 animations:^{
            self.cityButton.alpha = 1;
            self.cityButton.transform = CGAffineTransformMakeTranslation(GetWidth(self.provinceButton), 0);
            self.indicator.transform = CGAffineTransformMakeTranslation(GetWidth(self.provinceButton), 0);
            self.scroView.contentOffset = CGPointMake(ScreenSize.width, 0);
        }];
    }
    else if (tableView == self.cityTabView)
    {
        self.citySelectIndex = indexPath.row;
        [self.cityTabView reloadData];
        
        [self.cityButton setTitle:self.cities[indexPath.row][@"name"] forState:UIControlStateNormal];
        SetWidth(self.cityButton, GetTextWidth(self.cityButton.titleLabel.text));
        
        self.areas = self.cities[indexPath.row][@"sub"];
        [self.areaTabView reloadData];
        
        if (self.areas.count <= 0)
        {
            if (self.pickOver)
            {
                NSString * province = self.provinces[self.provinceSelectIndex][@"name"];
                NSString * city = self.cities[indexPath.row][@"name"];
                NSDictionary * dict = @{@"province":province, @"city":city, @"area":@""};
                self.pickOver(dict);
            }
            return;
        }
        
        [self.areaButton setTitle:@"请选择" forState:UIControlStateNormal];
        SetWidth(self.areaButton, GetTextWidth(self.areaButton.titleLabel.text));
              
        // 设置指示器宽度
        SetWidth(self.indicator,GetWidth(self.areaButton));
        
        [UIView animateWithDuration:0.5 animations:^{
            self.areaButton.alpha = 1;
            self.areaButton.transform = CGAffineTransformMakeTranslation(GetWidth(self.provinceButton)+GetWidth(self.cityButton), 0);
            self.indicator.transform = CGAffineTransformMakeTranslation(GetWidth(self.provinceButton)+GetWidth(self.cityButton), 0);
            self.scroView.contentOffset = CGPointMake(ScreenSize.width * 2, 0);
        }];
    }
    else
    {
        self.areaSelectIndex = indexPath.row;
        [self.areaTabView reloadData];
        
        [self.areaButton setTitle:self.areas[indexPath.row] forState:UIControlStateNormal];
        SetWidth(self.areaButton, GetTextWidth(self.areaButton.titleLabel.text));
        
        //执行Block，传出选中的内容
        NSString * province = self.provinces[self.provinceSelectIndex][@"name"];
        NSString * city = self.cities[self.citySelectIndex][@"name"];
        NSString * area = self.areas[indexPath.row];
        NSDictionary * dict = @{@"province":province, @"city":city, @"area":area};
        if (self.pickOver) self.pickOver(dict);
    }
}


#pragma mark - 方法抽取
/**
 初始化子视图
 */
-(void) setupChildViews
{
    self.backgroundColor = [UIColor whiteColor];
    
    // 选择器标题
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 4, GetWidth(self), 34)];
    titleLabel.text = @"选择地区";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.layer.shadowColor = [UIColor grayColor].CGColor;
    titleLabel.layer.shadowOpacity = .5f;
    titleLabel.layer.shadowOffset = CGSizeMake(0, -4);
    [self addSubview:titleLabel];
    
    // 关闭按钮
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenSize.width-44, 4, 34, 34)];
    NSString * closeIconPath = [[NSBundle mainBundle] pathForResource:@"LG_Close_Icon" ofType:@"png"];
    [closeButton setImage:[UIImage imageWithContentsOfFile:closeIconPath] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    // 地址按钮
    for (int i = 0; i < 3; i++)
    {
        UIButton * button = [[UIButton alloc] init];
        [button setTitle:@"请选择" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        button.backgroundColor = [UIColor whiteColor];
        button.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame),GetTextWidth(button.titleLabel.text), 30);
        [self addSubview:button];
        switch (i)
        {
            case 0:
                self.areaButton = button;
                self.areaButton.alpha = 0;
                [self.areaButton addTarget:self action:@selector(areaButtonClick) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                self.cityButton = button;
                self.cityButton.alpha = 0;
                [self.cityButton addTarget:self action:@selector(cityButtonClick) forControlEvents:UIControlEventTouchUpInside];
                break;
            default:
                self.provinceButton = button;
                [self.provinceButton addTarget:self action:@selector(provinceButtonClick) forControlEvents:UIControlEventTouchUpInside];
                break;
        }
    }
    
    // 分割线
    UIView * sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.provinceButton.frame), ScreenSize.width, 1)];
    sepLine.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self addSubview:sepLine];
    
    // 指示器
    self.indicator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.provinceButton.frame), GetWidth(self.provinceButton), 1)];
    self.indicator.backgroundColor = TinyColor;
    [self addSubview:self.indicator];
    
    // ScroView
    self.scroView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(sepLine.frame), ScreenSize.width, self.frame.size.height-CGRectGetMaxY(sepLine.frame))];
    self.scroView.contentSize = CGSizeMake(ScreenSize.width * 3, 0);
    self.scroView.scrollEnabled = NO;
    
    // ScroView中TabView
    for (int i = 0; i < 3; i++)
    {
        UITableView * tabView = [[UITableView alloc] initWithFrame:CGRectMake(i*ScreenSize.width, 0, ScreenSize.width, self.scroView.frame.size.height)];
        tabView.delegate = self;
        tabView.dataSource = self;
        tabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.scroView addSubview:tabView];
        switch (i)
        {
            case 0:
                self.provinceTabView = tabView;
                break;
            case 1:
                self.cityTabView = tabView;
                break;
            default:
                self.areaTabView = tabView;
                break;
        }
    }
    [self addSubview:self.scroView];
}

/**
 获取视图宽度

 @param view 传入视图
 @return 返回宽度
 */
-(CGFloat) getViewWidth:(UIView *)view
{
    return view.frame.size.width;
}

/**
 设置视图宽度

 @param view 传入视图
 @param width 传入宽度
 */
-(void) setViewWidth:(UIView *)view Width:(CGFloat)width
{
    CGRect frame = view.frame;
    frame.size.width = width;
    view.frame = frame;
}


/**
 根据文字内容获取文字宽度

 @param text 传入文字
 @return 返回宽度
 */
-(CGFloat) getWidthWithText:(NSString *)text
{
    UIFont * font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(MAXFLOAT, 30.f);
    CGSize textSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size;
    return textSize.width + 20;
}
@end
