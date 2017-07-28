//
//  LXTimeSelectViewController.m
//  Advertisement
//
//  Created by zuolixin on 2017/6/14.
//  Copyright © 2017年 gomeplus. All rights reserved.
//

#import "LXTimeSelectViewController.h"

#import "SKConstant.h"
#import "LXCalendarConfigure.h"

#import "LXTimeRepeatViewController.h"

@interface LXTimeSelectViewController () <SKCalendarViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) SKCalendarView *calendarView;
@property (nonatomic, strong) UIButton *myConfirmB;

@property (nonatomic, strong) UIView *repeatView;
@property (nonatomic, strong) UILabel *repeatLabel;

@property (nonatomic, strong) UIView *bigBGView;
@property (nonatomic, strong) UIView *samllBGView;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@property (nonatomic, strong) UIPickerView *pickView;

@property (nonatomic, strong) NSMutableArray *pickDataSource;

@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, assign) NSInteger repeatTime;

@property (nonatomic, copy) NSString *mouthTime;
@property (nonatomic, copy) NSString *hourTime;
@property (nonatomic, copy) NSString *minuteTime;

@property (nonatomic, strong) UILabel *repeatL;
@property (nonatomic,copy)NSString *dateStr;
@property (nonatomic,strong)NSMutableArray *dateArr;
@end


@implementation LXTimeSelectViewController

- (void)dealloc {
    LXLog(@"LXTimeSelectViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"服务时间";
    self.view.backgroundColor = LXVCBackgroundColor;
    
    self.repeatTime = 0;
    self.timeArray = [NSMutableArray array];
    self.dateArr = [NSMutableArray array];
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpaceBarButtonItem.width = -10;
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.myConfirmB];
    self.navigationItem.rightBarButtonItems = @[fixedSpaceBarButtonItem, barButtonItem];
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(creatView) object:nil];
    [thread start];
    
    self.repeatTime = self.repeatTimeInter;
    [self.repeatL setText:[self generateRepestStringWithInteger:self.repeatTime]];
    [SVProgressHUD showWithStatus:@"加载中……"];
}
-(void)creatView{
     [self.view addSubview:self.calendarView];
    [self.view addSubview:self.repeatView];
    if(self.timeStringArr.count>0&&![self.timeStringArr[0] isEqualToString:@""]){
        self.timeArray = self.timeStringArr;
       
        for (NSString *time in self.timeArray) {
            NSArray *tempArr0 =[time componentsSeparatedByString:@" "];
            NSArray *tempArray = [tempArr0[0] componentsSeparatedByString:@"-"];
            NSString *month = tempArray[1];
            NSString *date = [NSString stringWithFormat:@"%@-%d-%@",tempArray[0],month.intValue ,tempArray.lastObject];
            [self.dateArr addObject:date];
            [self.calendarView reloadWithSelectTime:[time substringWithRange:NSMakeRange(11, 5)] day:date];
        }
        
    }

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}


#pragma mark - SKCalendarViewDelegate

- (void)selectDateWithDate:(NSString *)date {
    LXLog(@"%@", date);
    if(self.dateArr.count>0){
         BOOL  isHave = NO;
            for (NSString *d in (NSArray*)self.dateArr) {
                if([date isEqualToString:d]){
                    [self.calendarView reloadWithSelectTime:@"" day:date];
                    for (NSString *timeS in self.timeArray) {
                        NSArray *tempArray = [timeS componentsSeparatedByString:@"-"];
                        NSArray *dataArray =[date componentsSeparatedByString:@"-"];
                        NSString *temp0 = tempArray[0];
                         NSString *temp1 = tempArray[1];
                         NSString *temp2 = tempArray.lastObject;
                        
                        NSString *data0  = dataArray[0];
                         NSString *data1  = dataArray[1];
                         NSString *data2  = dataArray.lastObject;
                        
                        if(temp0.intValue==data0.intValue&&temp1.intValue==data1.intValue&&temp2.intValue==data2.intValue){
                            [self.timeArray removeObject:timeS];
                            break;
                        }
                    }
                    [self.dateArr removeObject:date];
                    self.dateStr = @"";
                    isHave = YES;
                    break;
                }
                
            }
            if(!isHave){
                self.mouthTime = date;
                [self.view addSubview:self.bigBGView];
            }
        

        
    }else{
        self.mouthTime = date;
        [self.view addSubview:self.bigBGView];
    }
    
}

- (void)cannotSelectDateWithRow:(NSInteger)row {
    UIAlertController *alterVC = [UIAlertController alertControllerWithTitle:nil message:@"不能预订超过一周的时间段！" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *call1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alterVC addAction:call1];
    
    [self presentViewController:alterVC animated:YES completion:^{
        
    }];
}


#pragma mark - Aciton

- (void)myConfirmBClick {
    LXWeakSelf(self);
    
    self.selectBlock(weakself.timeArray, [weakself generateRepestStringWithInteger:weakself.repeatTime]);
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)repeatViewClick {
    LXWeakSelf(self);
    
    LXTimeRepeatViewController *trVC = [LXTimeRepeatViewController new];
    trVC.repeatT = self.repeatTime;
    trVC.myblock = ^(NSInteger repeat) {
        weakself.repeatTime = repeat;
        
        [weakself.repeatL setText:[weakself generateRepestStringWithInteger:repeat]];
    };
    
    [self.navigationController pushViewController:trVC animated:YES];
}

- (void)cancelBtnClick {
    [self.bigBGView removeFromSuperview];
}

- (void)confirmBtnClick {
    [self.dateArr addObject:self.mouthTime];
    self.dateStr = self.mouthTime;
    NSString *currentDay = nil;
    NSString *mouth =nil;
    NSArray *tempArray = [self.mouthTime componentsSeparatedByString:@"-"];
    currentDay = tempArray.lastObject;
    mouth = tempArray[1];
    if(currentDay.intValue<10){
        currentDay = [NSString stringWithFormat:@"0%@", currentDay];
    }
    if(mouth.intValue<10){
        mouth =[NSString stringWithFormat:@"0%@", mouth];
    }
    self.mouthTime = [NSString stringWithFormat:@"%@-%@-%@",tempArray[0],mouth,currentDay];
    NSString *hourTime = nil;
    if (!self.hourTime) {
        hourTime = @"00";
        self.hourTime = hourTime;
    }else{
        if(self.hourTime.intValue<10){
            hourTime = [NSString stringWithFormat:@"0%d", self.hourTime.intValue];
        }else{
            hourTime = [NSString stringWithFormat:@"%d", self.hourTime.intValue];
        }
        
        self.hourTime = hourTime;
    }
    
    NSString *minute = nil;
    if (!self.minuteTime) {
        minute = @"00";
        self.minuteTime = minute;
    }
    else {
        if(self.minuteTime.intValue<10){
            minute = [NSString stringWithFormat:@"0%d", self.minuteTime.intValue];
        }else{
            minute = [NSString stringWithFormat:@"%d", self.minuteTime.intValue];
        }
        self.minuteTime = minute;
    }
    
    NSString *string = [NSString stringWithFormat:@"%@:%@:00", self.hourTime, minute];
    NSString *string1 = [string substringWithRange:NSMakeRange(0, string.length-3)];
    [self.calendarView reloadWithSelectTime:string1 day:self.mouthTime];
    
    NSString *timeString = [NSString stringWithFormat:@"%@ %@", self.mouthTime, string];
    if (![self.timeArray containsObject:timeString]) {
        [self.timeArray addObject:timeString];
    }
    
    [self.bigBGView removeFromSuperview];
}


#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [self.pickDataSource count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.pickDataSource[component] count];
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *tempString = self.pickDataSource[component][row];
    
    if (component == 0) {
        NSAttributedString *component0String = [[NSAttributedString alloc] initWithString:tempString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : LXColorHex(0x666666)}];
        
        return component0String;
    }
    else if (component == 1) {
        NSAttributedString *component0String = [[NSAttributedString alloc] initWithString:tempString attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : LXColorHex(0x666666)}];
        
        return component0String;
    }
    
    return nil;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (LXScreenWidth - 40) / 2;
}


#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        NSString *hourT = self.pickDataSource[0][row];
        self.hourTime = [hourT substringToIndex:hourT.length - 1];
    }
    
    if (component == 1) {
        NSString *minuteT = self.pickDataSource[1][row];
        self.minuteTime = [minuteT substringToIndex:minuteT.length - 1];
    }
}


#pragma mark - Private

- (NSString *)generateRepestStringWithInteger:(NSInteger)repeat {
    if (repeat == 0) {
        return @"不重复";
    }
    else if (repeat == 1) {
        return @"一周";
    }
    else if (repeat == 2) {
        return @"两周";
    }
    else if (repeat == 3) {
        return @"三周";
    }
    
    return @"";
}


#pragma mark - Getter

- (SKCalendarView *)calendarView {
    if (!_calendarView) {
        
        _calendarView = [[SKCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 420)];
        
        _calendarView.delegate = self;
        
        LXCalendarConfigure *configure = [LXCalendarConfigure new];
        configure.weekViewInWeekTitleColor = LXColorHex(0x4c4c4c);
        configure.weekViewOffWeekTitleColor = LXMainColor;
        _calendarView.calendarConfigure = configure;
        
        _calendarView.calendarTodayColor = LXMainColor;  // 今天日期字体颜色
        
        _calendarView.dayoffInWeekColor = LXColorHex(0xb2b2b2);
        _calendarView.weekBackgroundColor = [UIColor whiteColor];
        _calendarView.normalInWeekColor = LXColorHex(0xb2b2b2);
        
    }
    
  [SVProgressHUD dismiss];
    
    return _calendarView;
}

- (UIButton *)myConfirmB {
    if (!_myConfirmB) {
        _myConfirmB = [UIButton buttonWithType:UIButtonTypeCustom];
        [_myConfirmB setTitle:@"确定" forState:UIControlStateNormal];
        [_myConfirmB setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_myConfirmB.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_myConfirmB setFrame:CGRectMake(0, 0, 40, 30)];
        [_myConfirmB.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_myConfirmB addTarget:self action:@selector(myConfirmBClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myConfirmB;
}

- (UIView *)repeatView {
    if (!_repeatView) {
        _repeatView = [[UIView alloc] initWithFrame:CGRectMake(0, 430, LXScreenWidth, 50)];
        [_repeatView setBackgroundColor:[UIColor whiteColor]];
        
        UILabel *firstL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, 40)];
        [firstL setFont:[UIFont systemFontOfSize:15]];
        [firstL setTextColor:LXColorHex(0x4c4c4c)];
        [firstL setText:@"重复"];
        [_repeatView addSubview:firstL];
        
        UILabel *lastL = [[UILabel alloc] init];
        [lastL setFont:[UIFont systemFontOfSize:15]];
        [lastL setTextColor:LXColorHex(0x4c4c4c)];
        [lastL setTextAlignment:NSTextAlignmentRight];
        [lastL setText:[self generateRepestStringWithInteger:self.repeatTime]];
        [lastL setFrame:CGRectMake(LXScreenWidth - 100, 5, 75, 40)];
        self.repeatL = lastL;
        [_repeatView addSubview:self.repeatL];
        
        UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [arrowBtn setBackgroundImage:[UIImage imageNamed:@"Order_arrow"] forState:UIControlStateNormal];
        [arrowBtn setFrame:CGRectMake(LXScreenWidth - 20, 17.5, 10, 15)];
        [_repeatView addSubview:arrowBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(repeatViewClick)];
        [_repeatView addGestureRecognizer:tap];
        
    }
    return _repeatView;
}

- (UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn {
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitleColor:LXMainColor forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBtn;
}

- (UIPickerView *)pickView {
    if (!_pickView) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, LXScreenWidth - 40, 216)];
        [_pickView setBackgroundColor:[UIColor whiteColor]];
        _pickView.dataSource = self;
        _pickView.delegate = self;
        _pickView.hidden = NO;
        _pickView.showsSelectionIndicator=YES;
    }
    return _pickView;
}

- (NSMutableArray *)pickDataSource {
    if (!_pickDataSource) {
        _pickDataSource = [NSMutableArray array];
        
        NSMutableArray *component1 = [NSMutableArray array];
        for (int i = 0; i <= 23 ; i++) {
            [component1 addObject:[NSString stringWithFormat:@"%d点", i]];
        }
        [_pickDataSource addObject:component1];
        
        NSMutableArray *component2 = [NSMutableArray array];
//        for (int i = 0; i <= 60 ; i++) {
//            [component2 addObject:[NSString stringWithFormat:@"%d分", i]];
//        }
        [component2 addObject:@"0分"];
         [component2 addObject:@"30分"];
        [_pickDataSource addObject:component2];
    }
    return _pickDataSource;
}


- (UIView *)bigBGView {
    if (!_bigBGView) {
        _bigBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LXScreenWidth, LXScreenHeight - LXNavigaitonBarHeight)];
        [_bigBGView setBackgroundColor:[UIColor lightGrayColor]];
        
        self.samllBGView = [[UIView alloc] initWithFrame:CGRectMake(20, 0, LXScreenWidth - 40, 260)];
        [self.samllBGView setCenterY:_bigBGView.centerY];
        [_bigBGView addSubview:self.samllBGView];
        
        self.topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.samllBGView.width, 44)];
        [self.topBgView setBackgroundColor:LXColorHex(0xedeeef)];
        [self.cancelBtn setFrame:CGRectMake(0, 0, 80, 44)];
        [self.confirmBtn setFrame:CGRectMake(self.topBgView.width - 80, 0, 80, 44)];
        [self.topBgView addSubview:self.cancelBtn];
        [self.topBgView addSubview:self.confirmBtn];
        [self.samllBGView addSubview:self.topBgView];
        
        [self.samllBGView addSubview:self.pickView];
    }
    return _bigBGView;
}

@end
