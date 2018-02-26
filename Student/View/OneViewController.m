//
//  OneViewController.m
//  Teacher
//
//  Created by 冯丽 on 2017/12/28.
//  Copyright © 2017年 chenghong. All rights reserved.
//

#import "OneViewController.h"
#import "OneCell.h"
#define kCellName @"OneCell"
#import "CourseAttendanceVC.h"
@interface OneViewController ()<UITableViewDelegate,UITableViewDataSource,siginDelegate>{
      OneCell *_cell;
    NSString *today;
    NSInteger selectIndex;
    
}

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTimeView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)createTimeView {
    NSArray *weekArr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
     NSArray *weekOneArr = @[@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday"];
    
    CGFloat weekLabWidth = kScreenSize.width/7;
    NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
    [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
    NSString *weekStr = [weekFormatter stringFromDate:[NSDate date]];
    NSString *todayWeekStr;
    for (int j = 0; j < weekOneArr.count; j++) {
        if ([weekStr isEqualToString:weekOneArr[j]]) {
            todayWeekStr = weekArr[j];
        }
    }
    NSArray *dateOneArr = [self getCurrentWeek];
    NSArray *arr = [[NSArray alloc] init];
    arr = [today componentsSeparatedByString:@"-"];
    NSString *todayDayStr = arr[2];
    for (int i =0; i < weekArr.count; i++) {
        UIButton *lab = [[UIButton alloc] initWithFrame:CGRectMake(weekLabWidth*i, 0, weekLabWidth, 50)];
        lab.titleLabel.textAlignment = NSTextAlignmentCenter;
        [lab setTitle:weekArr[i] forState:UIControlStateNormal];
        lab.tag = 500+i;
        [lab addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
        if ([todayWeekStr isEqualToString:weekArr[i]]) {
            [lab setTitleColor:KTextBlackColor forState:UIControlStateNormal];
            [lab setBackgroundColor:KBgColor];
            selectIndex = lab.tag;
          
        }else{
            
            [lab setTitleColor:KTextgrayColor forState:UIControlStateNormal];
            [lab setBackgroundColor:[UIColor whiteColor]];
            
        }
        
  
        [self.timeView addSubview:lab];
       
   
    }
}
- (void)dateClick:(UIButton *)bth {
    UIButton *find_bth = (UIButton *)[self.view viewWithTag:selectIndex];
    [find_bth setTitleColor:KTextgrayColor forState:UIControlStateNormal];
    [find_bth setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *select_bth = (UIButton *)[self.view viewWithTag:bth.tag];
    [select_bth setTitleColor:KTextBlackColor forState:UIControlStateNormal];
    [select_bth setBackgroundColor:KBgColor];
     selectIndex = bth.tag;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!_cell) {
        _cell = [[OneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    //    XyModel *model = self.dataArray[indexPath.row];
    
    CGRect cellFrame = _cell.contentView.frame;
    cellFrame.size.width = kScreenSize.width;
    [_cell.contentView setFrame:cellFrame];
    _cell.signDelegate = self;
    [_cell showModel];
    return _cell;
    
    
}
- (void)postStr:(NSString *)Str {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CourseAttendanceVC *detail = [storyboard instantiateViewControllerWithIdentifier:@"CourseAttendanceVC"];
    [self.navigationController pushViewController:detail animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return 50 ;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
/**
 *  获取当前时间所在一周的第一天和最后一天
 */
- (NSArray *)getCurrentWeek
{
    NSDate *now = [NSDate date];
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
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
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
