//
//  TwoViewController.m
//  Teacher
//
//  Created by 冯丽 on 2017/12/28.
//  Copyright © 2017年 chenghong. All rights reserved.
//

#import "TwoViewController.h"
#import "TwoCell.h"
#define kCellName @"TwoCell"
#import "sign.h"
#import "SZCalendarPicker.h"
#import "BGControl.h"
@interface TwoViewController ()<UITableViewDelegate,UITableViewDataSource,attendanceDelegate,choiceDelegate,UITextViewDelegate>{
    TwoCell *_cell;
    sign *signView;
    NSString *typeStr;
    NSString *today;
    NSDate *choiceDate;
     NSInteger selectIndex;
  
}

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    choiceDate = [NSDate date];
    typeStr = @"301";
  

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
      [self createTimeView];
}
- (IBAction)deteClick:(UIButton *)sender {
        self.topView.frame = CGRectMake(0, 0, kScreenSize.width, 130);
        [self.bigTableView setTableHeaderView:self.topView];
        self.bigTableView.showsVerticalScrollIndicator = NO;
        self.bigTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
        calendarPicker.today = [NSDate date];
        calendarPicker.date = calendarPicker.today;
        calendarPicker.frame = CGRectMake(0, 135, self.view.frame.size.width, 0.5*self.view.frame.size.height);
    
        calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
            NSString *str = [NSString stringWithFormat:@"%i-%i-%i", year,month,day];
             choiceDate = [BGControl stringToDate:str];
            [self createTimeView];
        };
}
- (void)createTimeView {
    for (UIView *view in [self.timeView subviews]) {
        if (view.tag == 301 || view.tag == 302) {
        }else{
        [view removeFromSuperview];
        }
    }
    NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat weekLabWidth = kScreenSize.width/7;
    NSArray *dateOneArr = [self getCurrentWeekWithDate:choiceDate];
    NSArray *arr = [[NSArray alloc] init];
    arr = [today componentsSeparatedByString:@"-"];
    NSString *todayDayStr = arr[2];
    for (int i =0; i < weekArr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(weekLabWidth*i, 0, weekLabWidth, 40)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.text = weekArr[i];
        lab.textColor = [UIColor colorWithRed:164/255.0 green:174/255.0 blue:190/255.0 alpha:1.0];
        lab.font = [UIFont systemFontOfSize:15];
        [self.timeView addSubview:lab];
        UIButton *bthLab =  [[UIButton alloc] initWithFrame:CGRectMake(weekLabWidth*i + (weekLabWidth-30)/2, 45, 30, 30)];
         bthLab.titleLabel.textAlignment = NSTextAlignmentCenter;
         [bthLab addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *timeArr = [dateOneArr[i] componentsSeparatedByString:@"-"];
        [bthLab setTitle:timeArr[1] forState:UIControlStateNormal] ;
         bthLab.tag = 500+i;
        if ([todayDayStr intValue] == [timeArr[1]intValue]) {
            [bthLab setBackgroundImage:[UIImage imageNamed:@"navi_bg_shadow@2x"] forState:UIControlStateNormal];
            bthLab.titleLabel.textColor = [UIColor whiteColor];
            bthLab.clipsToBounds = YES;
            bthLab.layer.cornerRadius = 15.f;
             selectIndex = bthLab.tag;
        }else{
            
            [bthLab setTitleColor:KTextBlackColor forState:UIControlStateNormal];
            [bthLab setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            
        }
        [self.timeView addSubview:bthLab];
        
        
    }
}
- (void)dateClick:(UIButton *)bth {
    UIButton *find_bth = (UIButton *)[self.view viewWithTag:selectIndex];
  
    [find_bth setTitleColor:KTextgrayColor forState:UIControlStateNormal];
    [find_bth setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [find_bth setTitleColor:KTextBlackColor forState:UIControlStateNormal];
    UIButton *select_bth = (UIButton *)[self.view viewWithTag:bth.tag];
    [select_bth setBackgroundImage:[UIImage imageNamed:@"navi_bg_shadow@2x"] forState:UIControlStateNormal];
    select_bth.titleLabel.textColor = [UIColor whiteColor];
    [select_bth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    select_bth.clipsToBounds = YES;
    select_bth.layer.cornerRadius = 15.f;
    selectIndex = bth.tag;
    
}
/**
 *  获取当前时间所在一周的第一天和最后一天
 */
- (NSArray *)getCurrentWeekWithDate:(NSDate *)dateTime
{
    NSDate *now = dateTime;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday
                                         fromDate:now];
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld  day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 7 - weekDay;
    }
    
    NSArray *currentWeeks = [self getCurrentWeeksWithFirstDiff:firstDiff lastDiff:lastDiff];
    
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    today = [formater stringFromDate:now];
    NSLog(@"一周开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"一周结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    NSLog(@"%@",currentWeeks);
    return currentWeeks;
}
//获取一周时间 数组
- (NSMutableArray *)getCurrentWeeksWithFirstDiff:(NSInteger)first lastDiff:(NSInteger)last{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    for (NSInteger i = first; i < last + 1; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeInterval:secondsPerDay sinceDate:choiceDate];
       
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"M-d"];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        //        NSString *dateStr = @"5月31日";
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    return eightArr;
}
/**
 topview点击

 @param sender
 */
- (IBAction)buttonClick:(UIButton *)sender {
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!_cell) {
        _cell = [[TwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    //    XyModel *model = self.dataArray[indexPath.row];
    
    CGRect cellFrame = _cell.contentView.frame;
    cellFrame.size.width = kScreenSize.width;
    _cell.attendanceDelegate = self;
    [_cell.contentView setFrame:cellFrame];
    [_cell showModel];
    return _cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

#pragma  点击事件代理

- (void)postTagStr:(NSString *)tagStr {
    if ([tagStr isEqualToString:@"301"]) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"sign" owner:self options:nil];
        signView = [nib firstObject];
        self.blackButton.hidden = NO;
        signView.choiceDelegate =self;
        [self.view addSubview:signView];
        signView.center = self.view.center;
        signView.clipsToBounds = YES;
        signView.layer.cornerRadius = 10.f;
        signView.remarkTextView.delegate = self;
        
        [self changeTwo:signView];
    }
}

- (void)postChoiceStr:(NSString *)choiceStr withRemarkStr:(NSString *)remarkStr withtypeStr:(NSString *)type {
    
    if ([choiceStr isEqualToString:@"305"]) {
        signView.hidden = YES;
        self.blackButton.hidden = YES;
      
    }else if ([choiceStr isEqualToString:@"306"]){
        typeStr = type;
        signView.hidden = YES;
        self.blackButton.hidden = YES;
    }
}

- (void)changeTwo:(sign *)test{
    
    
    if ([typeStr isEqualToString:@"301"] ) {
        [test.oneBth setBackgroundColor:KTabBarColor];
        [test.twoBth setBackgroundColor:[UIColor whiteColor]];
        test.twoBth.layer.cornerRadius = 5.f;
        test.twoBth.layer.borderColor = KTabBarColor.CGColor;
        test.twoBth.layer.borderWidth = 1.f;
        [test.threeBth setBackgroundColor:[UIColor whiteColor]];
        [test.fourBth setBackgroundColor:[UIColor whiteColor]];
        test.threeBth.layer.cornerRadius = 5.f;
        test.threeBth.layer.borderColor = KTabBarColor.CGColor;
        test.threeBth.layer.borderWidth = 1.f;
        [test.twoBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.oneBth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [test.threeBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.fourBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        test.fourBth.layer.cornerRadius = 5.f;
        test.fourBth.layer.borderColor = KTabBarColor.CGColor;
        test.fourBth.layer.borderWidth = 1.f;
        test.oneBth.layer.cornerRadius =5.f;
    }else if ([typeStr isEqualToString:@"302"]) {
        [test.twoBth setBackgroundColor:KTabBarColor];
        [test.oneBth setBackgroundColor:[UIColor whiteColor]];
        test.oneBth.layer.cornerRadius = 5.f;
        test.oneBth.layer.borderColor = KTabBarColor.CGColor;
        test.oneBth.layer.borderWidth = 1.f;
        [test.threeBth setBackgroundColor:[UIColor whiteColor]];
        [test.fourBth setBackgroundColor:[UIColor whiteColor]];
        test.threeBth.layer.cornerRadius = 5.f;
        test.threeBth.layer.borderColor = KTabBarColor.CGColor;
        test.threeBth.layer.borderWidth = 1.f;
        [test.oneBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.twoBth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [test.threeBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.fourBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        test.fourBth.layer.cornerRadius = 5.f;
        test.fourBth.layer.borderColor = KTabBarColor.CGColor;
        test.fourBth.layer.borderWidth = 1.f;
        test.twoBth.layer.cornerRadius = 5.f;
        
        
    }else if ([typeStr isEqualToString:@"303"]) {
        [test.threeBth setBackgroundColor:KTabBarColor];
        [test.oneBth setBackgroundColor:[UIColor whiteColor]];
        test.oneBth.layer.cornerRadius = 5.f;
        test.oneBth.layer.borderColor = KTabBarColor.CGColor;
        test.oneBth.layer.borderWidth = 1.f;
        [test.twoBth setBackgroundColor:[UIColor whiteColor]];
        [test.fourBth setBackgroundColor:[UIColor whiteColor]];
        test.twoBth.layer.cornerRadius = 5.f;
        test.twoBth.layer.borderColor = KTabBarColor.CGColor;
        test.twoBth.layer.borderWidth = 1.f;
        [test.oneBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.threeBth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [test.twoBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.fourBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        test.fourBth.layer.cornerRadius = 5.f;
        test.fourBth.layer.borderColor = KTabBarColor.CGColor;
        test.fourBth.layer.borderWidth = 1.f;
        test.threeBth.layer.cornerRadius = 5.f;
    }else if ([typeStr isEqualToString:@"304"]) {
        [test.fourBth setBackgroundColor:KTabBarColor];
        [test.oneBth setBackgroundColor:[UIColor whiteColor]];
        test.oneBth.layer.cornerRadius = 5.f;
        test.oneBth.layer.borderColor = KTabBarColor.CGColor;
        test.oneBth.layer.borderWidth = 1.f;
        [test.threeBth setBackgroundColor:[UIColor whiteColor]];
        [test.twoBth setBackgroundColor:[UIColor whiteColor]];
        test.twoBth.layer.cornerRadius = 5.f;
        test.twoBth.layer.borderColor = KTabBarColor.CGColor;
        test.twoBth.layer.borderWidth = 1.f;
        [test.oneBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.fourBth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [test.threeBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        [test.twoBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
        test.threeBth.layer.cornerRadius = 5.f;
        test.threeBth.layer.borderColor = KTabBarColor.CGColor;
        test.threeBth.layer.borderWidth = 1.f;
        test.fourBth.layer.cornerRadius = 5.f;
    }
    
    
    
}


-(void)blackButtonClick {
    signView.hidden = YES;
    self.blackButton.hidden = YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (!textView.text.length) {
        signView.placLab.alpha = 1;
    }else {
        signView.placLab.alpha = 0;
    }
}
- (void) dismissKeyBoard {
    [signView.remarkTextView resignFirstResponder];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![signView.remarkTextView isExclusiveTouch]) {
        [signView.remarkTextView resignFirstResponder];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
