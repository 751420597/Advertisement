//
//  SKCalendarView.m
//  SKCalendarView
//
//  Created by shevchenko on 17/3/29.
//  Copyright © 2017年 shevchenko. All rights reserved.
//

#import "SKCalendarView.h"
#import "SKConstant.h"
#import "SKCalendarCollectionViewCell.h"
#import "SKWeekCollectionViewCell.h"
#import "SKCalendarManage.h"

#import "LXCalendarCollectionViewCell.h"

@interface SKCalendarView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView * weekCollectionView;
@property (nonatomic, strong) UICollectionView * calendarCollectionView;
@property (nonatomic, strong) UICollectionView * extraCollectionView;

@property (nonatomic, strong) SKCalendarManage * currentCalendarManage;
@property (nonatomic, strong) SKCalendarManage * nextCalendarManage;

@property (nonatomic, strong) UILabel * monthBackgroundLabel;
@property (nonatomic, strong) NSDate *  theDate;       // 当前日期
@property (nonatomic, assign) NSUInteger theYear;      // 本年
@property (nonatomic, assign) NSUInteger theDayInMonth;// 今天在本月所处位置
@property (nonatomic, assign) NSInteger  selectedRow;  // 选择的日期
@property (nonatomic, strong) NSString * displayChineseDate;//已显示的农历日期&节日&节气

@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *aWeekValue;
@property (nonatomic, strong) NSMutableArray *aWeekValueExtra;

@property (nonatomic, strong) LXCalendarCollectionViewCell *wholeCell;

@property (nonatomic, strong) NSDate *currenDate;
@property (nonatomic, strong) NSDate *nextMonthDate;

@property (nonatomic, strong) NSMutableDictionary *cureRecordDictionary;
@property (nonatomic, strong) NSMutableDictionary *nextRecordDictionary;

@end

@implementation SKCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        if (self) {
            self.cureRecordDictionary = [NSMutableDictionary dictionary];
            self.nextRecordDictionary = [NSMutableDictionary dictionary];
            
            self.frame = frame;
            self.calendarConfigure = [LXCalendarConfigure new];
            _nextCalendarManage = [SKCalendarManage manage];
            self.currenDate = [NSDate dateWithTimeIntervalSinceNow:0 * 24 * 60 * 60];
            self.nextMonthDate = [NSDate dateWithTimeInterval:24 * 60 * 60 sinceDate:self.currenDate];
            [self.nextCalendarManage checkThisMonthRecordFromToday:self.nextMonthDate];
            self.currentIndex = -1;
            
            [self customView];
        }
    }
    
    return self;
}

- (SKCalendarManage *)currentCalendarManage {
    if (!_currentCalendarManage) {
        _currentCalendarManage = [SKCalendarManage manage];
        
        [_currentCalendarManage checkThisMonthRecordFromToday:self.currenDate];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *nextMothFirstDay = [dateFormatter stringFromDate:self.nextMonthDate];
        NSString *temp =[nextMothFirstDay substringFromIndex:nextMothFirstDay.length-2];
        self.aWeekValue = [NSMutableArray array];
        //int days =(int)_nextCalendarManage.calendarDate.count;
        int days = 7;
        if ([temp isEqualToString:@"01"] ) {
            
            for(int i=0;i<days;i++){
                [self.aWeekValue addObject:_nextCalendarManage.calendarDate[i]];
            }
        }
        else {
            for (int i = (int)_currentCalendarManage.todayInMonth+1; i <= _currentCalendarManage.days + _currentCalendarManage.dayInWeek - 2; i++) {
                [self.aWeekValue addObject:_currentCalendarManage.calendarDate[i]];
                
            }
            
            self.aWeekValueExtra = [NSMutableArray array];
            
            NSUInteger todayInMonth = _currentCalendarManage.todayInMonth;
            if (todayInMonth > 1) {
                todayInMonth = _currentCalendarManage.todayInMonth - _currentCalendarManage.dayInWeek + 2;
            }
            NSUInteger day = _currentCalendarManage.days - todayInMonth;
            NSInteger hours = (day + 1) * 24;
            
            self.nextMonthDate = [NSDate dateWithTimeInterval:hours * 60 * 60 sinceDate:self.currenDate];
            self.nextCalendarManage = [[SKCalendarManage alloc] init];
            [self.nextCalendarManage checkThisMonthRecordFromToday:self.nextMonthDate];
            
//            NSInteger firstCount = self.aWeekValue.count;
//            NSInteger lastCount = _currentCalendarManage.days - firstCount;
//            for (int i =0 ; i<42-self.aWeekValue.count; i++) {
//                [self.aWeekValue addObject:@""];
//            }
//            for (int j = 0; j < lastCount; j++) {
//                [self.aWeekValueExtra addObject:self.nextCalendarManage.calendarDate[self.nextCalendarManage.dayInWeek + j - 1]];
//            }
            NSInteger firstCount = self.aWeekValue.count;
            NSInteger lastCount = 7 - firstCount;
            for (int j = 0; j < lastCount; j++) {
                [self.aWeekValueExtra addObject:self.nextCalendarManage.calendarDate[self.nextCalendarManage.dayInWeek + j - 1]];
            }
        }
    }
    return _currentCalendarManage;
}

//- (NSUInteger)lastMonth
//{
//    if (_lastMonth == 0) {
//        _lastMonth = self.calendarManage.month - 1;
//    }
//    return _lastMonth;
//}
//
//- (NSUInteger)nextMonth
//{
//    if (_nextMonth == 0) {
//        _nextMonth = self.calendarManage.month + 1;
//    }
//    return _nextMonth;
//}
//
//- (NSInteger)selectedRow
//{
//    if (_selectedRow == 0) {
//        _selectedRow = - 1;
//    }
//    return _selectedRow;
//}
//
//- (NSInteger)todayInMonth
//{
//    if (_todayInMonth == 0) {
//        _todayInMonth = self.calendarManage.todayInMonth;
//    }
//    return _todayInMonth;
//}



#pragma mark - 创建界面
- (void)customView {
    __weak typeof(self) weakSelf = self;
    
    // 周
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.weekCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
    [self addSubview:self.weekCollectionView];
    self.weekCollectionView.backgroundColor = [UIColor whiteColor];
    self.weekCollectionView.delegate = self;
    self.weekCollectionView.dataSource = self;
    self.weekCollectionView.userInteractionEnabled = NO;
    [self.weekCollectionView registerClass:[SKWeekCollectionViewCell class] forCellWithReuseIdentifier:@"Week"];
    [self.weekCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_offset(32);
    }];
    
    UIView *dateView = [[UIView alloc] init];
    [dateView setBackgroundColor:[UIColor whiteColor]];
    [dateView lx_setViewCornerRadius:0 borderColor:LXCellBorderColor borderWidth:1];
    [self addSubview:dateView];
    [dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(35);
        make.leading.mas_equalTo(weakSelf);
        make.trailing.mas_equalTo(weakSelf);
        make.top.mas_equalTo(weakSelf.weekCollectionView.mas_bottom);
    }];
    
    UILabel *dateLabel = [UILabel new];
    [dateView addSubview:dateLabel];
    dateLabel.textColor = LXColorHex(0x4c4c4c);
    dateLabel.font = [UIFont systemFontOfSize:16];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    
   // [self.currentCalendarManage checkThisMonthRecordFromToday:self.currenDate];
    
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(dateView);
        make.centerY.mas_equalTo(dateView);
    }];
    self.currentCalendarManage;
    if ([self.aWeekValue count] == _nextCalendarManage.calendarDate.count) {
        dateLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.currentCalendarManage.year),@(self.nextCalendarManage.month)];
        // 日期
        UICollectionViewFlowLayout * dateLayout = [[UICollectionViewFlowLayout alloc] init];
        dateLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.calendarCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:dateLayout];
        [self addSubview:self.calendarCollectionView];
        self.calendarCollectionView.backgroundColor = [UIColor whiteColor];
        self.calendarCollectionView.delegate = self;
        self.calendarCollectionView.dataSource = self;
        [self.calendarCollectionView registerNib:[UINib nibWithNibName:@"LXCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Calendar"];
        [self.calendarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dateView.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    else {
        dateLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.currentCalendarManage.year),@(self.currentCalendarManage.month)];
        UICollectionViewFlowLayout * dateLayout1 = [[UICollectionViewFlowLayout alloc] init];
        dateLayout1.scrollDirection = UICollectionViewScrollDirectionVertical;

        self.extraCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:dateLayout1];
        [self addSubview:self.extraCollectionView];
        self.extraCollectionView.backgroundColor = [UIColor whiteColor];
        self.extraCollectionView.delegate = self;
        self.extraCollectionView.dataSource = self;
        [self.extraCollectionView registerNib:[UINib nibWithNibName:@"LXCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Calendar1"];
        [self.extraCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dateView.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.mas_equalTo(140);
            //make.height.mas_equalTo(dateView);
        }];

        UIView *dateView1 = [[UIView alloc] init];
        [dateView1 setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:dateView1];
        [dateView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            make.leading.mas_equalTo(weakSelf);
            make.trailing.mas_equalTo(weakSelf);
            make.top.mas_equalTo(weakSelf.extraCollectionView.mas_bottom).mas_offset(10);
        }];
        
        UIView *addBottomLine = [[UIView alloc] init];
        [addBottomLine setBackgroundColor:LXCellBorderColor];
        [dateView1 addSubview:addBottomLine];
        [addBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.mas_equalTo(dateView1);
            make.height.mas_equalTo(1);
        }];

        UIView *topDateBGView = [[UIView alloc] init];
        [topDateBGView setBackgroundColor:LXVCBackgroundColor];
        [dateView addSubview:topDateBGView];
        [topDateBGView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(dateView1);
            make.leading.mas_equalTo(dateView1);
            make.trailing.mas_equalTo(dateView1);
            make.height.mas_equalTo(dateView1);
        }];

        UILabel *nextLabel = [UILabel new];
        [dateView1 addSubview:nextLabel];
        nextLabel.textColor = LXColorHex(0x4c4c4c);
        nextLabel.font = [UIFont systemFontOfSize:16];
        nextLabel.textAlignment = NSTextAlignmentCenter;
        nextLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.nextCalendarManage.year), @(self.nextCalendarManage.month)];
        [nextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(dateView1);
            make.centerY.mas_equalTo(dateView1.mas_centerY);
        }];

        UICollectionViewFlowLayout * dateLayout = [[UICollectionViewFlowLayout alloc] init];
        dateLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.calendarCollectionView = [[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:dateLayout];
        [self addSubview:self.calendarCollectionView];
        self.calendarCollectionView.backgroundColor = [UIColor whiteColor];
        self.calendarCollectionView.delegate = self;
        self.calendarCollectionView.dataSource = self;
        [self.calendarCollectionView registerNib:[UINib nibWithNibName:@"LXCalendarCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Calendar2"];
        [self.calendarCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(dateView1.mas_bottom);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
}

#pragma mark - 外部配置
- (void)setWeekBackgroundColor:(UIColor *)weekBackgroundColor
{
    _weekBackgroundColor = weekBackgroundColor;
    self.weekCollectionView.backgroundColor = weekBackgroundColor;
}

- (void)setNormalInWeekColor:(UIColor *)normalInWeekColor
{
    _normalInWeekColor = normalInWeekColor;
}

- (void)setDayoffInWeekColor:(UIColor *)dayoffInWeekColor
{
    _dayoffInWeekColor = dayoffInWeekColor;
}


- (void)setCalendarTodayColor:(UIColor *)calendarTodayColor
{
    _calendarTodayColor = calendarTodayColor;
}

- (void)setDateColor:(UIColor *)dateColor
{
    _dateColor = dateColor;
}

- (void)setDateIcon:(UIImage *)dateIcon
{
    _dateIcon = dateIcon;
}

- (void)setHolidayBackgroundColor:(UIColor *)holidayBackgroundColor
{
    _holidayBackgroundColor = holidayBackgroundColor;
}

- (void)setSolarTeromBackgroundColor:(UIColor *)solarTeromBackgroundColor
{
    _solarTeromBackgroundColor = solarTeromBackgroundColor;
}

- (void)setDateBackgroundColor:(UIColor *)dateBackgroundColor
{
    _dateBackgroundColor = dateBackgroundColor;
}

- (void)setSpringColor:(UIColor *)springColor
{
    _springColor = springColor;
}

- (void)setSummerColor:(UIColor *)summerColor
{
    _summerColor = summerColor;
}

- (void)setAutumnColor:(UIColor *)autumnColor
{
    _autumnColor = autumnColor;
}

- (void)setWinterColor:(UIColor *)winterColor
{
    _winterColor = winterColor;
}

- (void)setDateBackgroundIcon:(UIImage *)dateBackgroundIcon
{
    _dateBackgroundIcon = dateBackgroundIcon;
}

- (void)setCalendarTodayTitle:(NSString *)calendarTodayTitle
{
    _calendarTodayTitle = calendarTodayTitle;
}

- (void)setCalendarTodayTitleColor:(UIColor *)calendarTodayTitleColor
{
    _calendarTodayTitleColor = calendarTodayTitleColor;
}

- (void)setHolidayColor:(UIColor *)holidayColor
{
    _holidayColor = holidayColor;
}

- (void)setCalendarTitleColor:(UIColor *)calendarTitleColor
{
    _calendarTitleColor = calendarTitleColor;
}

- (void)setEnableClickEffect:(BOOL)enableClickEffect
{
    _enableClickEffect = enableClickEffect;
}

- (void)setEnableDateRoundCorner:(BOOL)enableDateRoundCorner
{
    _enableDateRoundCorner = enableDateRoundCorner;
}

- (void)setCheckLastMonth:(BOOL)checkLastMonth
{
//    _checkLastMonth = checkLastMonth;
//    if (checkLastMonth == YES) {
//        self.selectedRow = -1;// 重置已选日期
//        NSInteger hours = (self.calendarManage.days - 1) * -24;
//        NSDate * date = [NSDate dateWithTimeInterval:hours * 60 * 60 sinceDate:self.theDate];
//        [self.calendarManage checkThisMonthRecordFromToday:date];
//        self.theDate = date;
//        self.monthBackgroundLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarManage.year),@(self.calendarManage.month)];
//        [self.calendarCollectionView reloadData];
//        [self reloadExternalDate];
//    }
}

- (void)setCheckNextMonth:(BOOL)checkNextMonth
{
//    _checkNextMonth = checkNextMonth;
//    if (checkNextMonth == YES) {
//        self.selectedRow = -1;// 重置已选日期
//        NSUInteger todayInMonth = self.calendarManage.todayInMonth;
//        if (todayInMonth > 1) {
//            todayInMonth = self.calendarManage.todayInMonth - self.calendarManage.dayInWeek + 2;
//        }
//        NSUInteger day = self.calendarManage.days - todayInMonth;
//        NSInteger hours = (day + 1) * 24;
//        NSDate * date = [NSDate dateWithTimeInterval:hours * 60 * 60 sinceDate:self.theDate];
//        [self.calendarManage checkThisMonthRecordFromToday:date];
//        self.theDate = date;
//        self.monthBackgroundLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarManage.year),@(self.calendarManage.month)];
//        [self.calendarCollectionView reloadData];
//        [self reloadExternalDate];
//    }
}

#pragma mark - 查看指定日期
- (void)checkCalendarWithAppointDate:(NSDate *)date
{
//    [self.calendarManage checkThisMonthRecordFromToday:date];
//    [self.calendarCollectionView reloadData];
//    self.theDate = date;
//    [self reloadExternalDate];
}

#pragma mark - 更新外部数据
- (void)reloadExternalDate
{
//    self.year = _calendarManage.year;
//    self.month = _calendarManage.month;
//    self.chineseYear = _calendarManage.chineseYear;
//    self.chineseMonth = _calendarManage.chineseMonth;
//    self.theDayInMonth = _calendarManage.todayInMonth;
//    self.chineseCalendarDay = _calendarManage.chineseCalendarDay;
//    self.chineseCalendarDate = _calendarManage.chineseCalendarDate;
//    self.monthBackgroundLabel.text = [NSString stringWithFormat:@"%@年%@月", @(self.calendarManage.year),@(self.calendarManage.month)];
//    self.lastMonth = _calendarManage.month - 1;
//    self.nextMonth = _calendarManage.month + 1;
}

#pragma mark - 获取节日&节气
//- (NSString *)getHolidayAndSolarTermsWithChineseDay:(NSString *)chineseDay
//{
////    NSString * result = @"";
////    NSUInteger row = 0;
////    if (self.selectedRow < 0) {
////        row = self.todayInMonth;// 默认今天
////    } else {
////        row = self.selectedRow;
////    }
////    NSString * date = getNoneNil(self.calendarManage.chineseCalendarDate[row]);
////    if (![chineseDay isEqualToString:date]) {
////        result = date;
////    }
////    return getNoneNil(result);
//}

#pragma mark - Reload

- (void)reloadWithSelectTime:(NSString *)hourMinute day:(NSString *)day {
    
    NSArray *tempDay = [day componentsSeparatedByString:@"-"];
   
    NSString *days= tempDay.lastObject;
    if (days.integerValue<10) {
        days=[days substringFromIndex:days.length-1];
    }
    NSString *month = tempDay[1];
    if (month.integerValue<10) {
        month=[month substringFromIndex:month.length-1];
    }
    
    if (_currentCalendarManage.theMonth ==month.integerValue ) {
        [self.cureRecordDictionary setValue:hourMinute forKey:days];
         [self.extraCollectionView reloadData];
    }else{
        [self.nextRecordDictionary setValue:hourMinute forKey:days];
        [self.calendarCollectionView reloadData];
    }
    
    
}


#pragma mark - collectionView
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.aWeekValue count] == _nextCalendarManage.calendarDate.count) {
        if(_nextCalendarManage.dayInWeek>5 &&_nextCalendarManage.days==31){
            return 42;
        }else{
            return 35;
        }
       
        
    }
    else {
        if (collectionView == self.extraCollectionView) {
            if(_currentCalendarManage.dayInWeek>5 &&_currentCalendarManage.days==31){
                return  42;
            }else{
                return 35;
            }

        }
        else {
            if(_nextCalendarManage.dayInWeek>5 &&_nextCalendarManage.days==31){
                return  42;
            }else{
                return 35;
            }
           
        }
    }
    
    return self.currentCalendarManage.weekList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.aWeekValue count] == _nextCalendarManage.calendarDate.count) {
        // 日期
        if (collectionView == self.calendarCollectionView) {
            LXCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Calendar" forIndexPath:indexPath];
            
            cell.dateLabel.text = getNoneNil(self.currentCalendarManage.calendarDate[indexPath.row]);
            
            if (self.nextRecordDictionary) {
                if ([self.nextRecordDictionary.allKeys containsObject:cell.dateLabel.text]) {
                    cell.hourMinuteL.text = self.nextRecordDictionary[cell.dateLabel.text];
                }
                else {
                    cell.hourMinuteL.text = @"";
                }
            }
            
            if ([self.aWeekValue containsObject:cell.dateLabel.text.numberValue]) {
                [cell.dateLabel setTextColor:LXColorHex(0x4c4c4c)];
            }
            else {
                [cell.dateLabel setTextColor:LXColorHex(0xb2b2b2)];
            }
            
            return cell;
        }
        else {
            // 周
            SKWeekCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Week" forIndexPath:indexPath];
            cell.week = getNoneNil(self.currentCalendarManage.weekList[indexPath.row]);
            cell.weekBackgroundColor = self.weekCollectionView.backgroundColor;
            cell.enableLine = NO;
            
            if (indexPath.row == 0 || indexPath.row == self.currentCalendarManage.weekList.count - 1) {
                cell.weekColor = LXMainColor;
            } else {
                cell.weekColor = LXColorHex(0x4c4c4c);
            }
            
            return cell;
        }
    }
    else {
        //下个月
        if (collectionView == self.calendarCollectionView) {
            LXCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Calendar2" forIndexPath:indexPath];
            
            cell.dateLabel.text = getNoneNil(self.nextCalendarManage.calendarDate[indexPath.row]);
            
            if (self.nextRecordDictionary) {
                if ([self.nextRecordDictionary.allKeys containsObject:cell.dateLabel.text]) {
                    cell.hourMinuteL.text = self.nextRecordDictionary[cell.dateLabel.text];
                }
                else {
                    cell.hourMinuteL.text = @"";
                }
            }
            
            if ([self.aWeekValueExtra containsObject:cell.dateLabel.text.numberValue]) {
                [cell.dateLabel setTextColor:LXColorHex(0x4c4c4c)];
            }
            else {
                [cell.dateLabel setTextColor:LXColorHex(0xb2b2b2)];
            }
            
            return cell;
        }
        else if (collectionView == self.extraCollectionView) {
        //本月
            LXCalendarCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Calendar1" forIndexPath:indexPath];
            
            
            cell.dateLabel.text = getNoneNil(self.currentCalendarManage.calendarDate[indexPath.row]);
            
            if (self.cureRecordDictionary) {
                if ([self.cureRecordDictionary.allKeys containsObject:cell.dateLabel.text]) {
                    cell.hourMinuteL.text = self.cureRecordDictionary[cell.dateLabel.text];
                }
                else {
                    cell.hourMinuteL.text = @"";
                }
            }
            
            if ([self.aWeekValue containsObject:cell.dateLabel.text.numberValue]) {
                [cell.dateLabel setTextColor:LXColorHex(0x4c4c4c)];
            }
            else {
                [cell.dateLabel setTextColor:LXColorHex(0xb2b2b2)];
            }
        
            return cell;
        }
        else if (collectionView == self.weekCollectionView) {
            // 周
            SKWeekCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Week" forIndexPath:indexPath];
            cell.week = getNoneNil(self.currentCalendarManage.weekList[indexPath.row]);
            cell.weekBackgroundColor = self.weekCollectionView.backgroundColor;
            cell.enableLine = NO;
            
            if (indexPath.row == 0 || indexPath.row == self.currentCalendarManage.weekList.count - 1) {
                cell.weekColor = LXMainColor;
            } else {
                cell.weekColor = LXColorHex(0x4c4c4c);
            }
            
            return cell;
        }
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.wholeCell = (LXCalendarCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.wholeCell.dateLabel.textColor isEqual:LXColorHex(0xb2b2b2)]) {
        if ([self.delegate respondsToSelector:@selector(cannotSelectDateWithRow:)]) {
            [self.delegate cannotSelectDateWithRow:indexPath.row];
        }
        return;
    }
    else {
        [self.wholeCell.dateLabel setTextColor:LXColorHex(0x4c4c4c)];
        
        NSString *yearMonthDay = nil;
        
        if ([self.aWeekValue count] == _nextCalendarManage.calendarDate.count) {
            yearMonthDay = [NSString stringWithFormat:@"%ld-%ld-%@", _nextCalendarManage.year,_nextCalendarManage.month, _nextCalendarManage.calendarDate[indexPath.row]];
            
             LXLog(@"%@ ", yearMonthDay);
        }
        else {
            if (collectionView == self.calendarCollectionView) {
                //下月
                yearMonthDay = [NSString stringWithFormat:@"%lu-%lu-%@", (unsigned long)self.nextCalendarManage.year, (unsigned long)self.nextCalendarManage.month, self.nextCalendarManage.calendarDate[indexPath.row]];
                
                 LXLog(@"%@ ", yearMonthDay);
            }
            else if (collectionView == self.extraCollectionView) {
                //本月
                //NSInteger arrayIndex = self.currentCalendarManage.calendarDate.count - 7 * 2 + indexPath.row;
                yearMonthDay = [NSString stringWithFormat:@"%lu-%lu-%@", (unsigned long)self.currentCalendarManage.year, (unsigned long)self.currentCalendarManage.month, self.currentCalendarManage.calendarDate[indexPath.row]];
                
                LXLog(@"%@", yearMonthDay);
                
            }
        }
        // 选择时间
        if ([self.delegate respondsToSelector:@selector(selectDateWithDate:)]) {
            [self.delegate selectDateWithDate:yearMonthDay];
        }
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.frame.size.width / 7, self.frame.size.height / 7);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


@end
