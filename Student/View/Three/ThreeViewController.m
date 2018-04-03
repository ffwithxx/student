//
//  ThreeViewController.m
//  Teacher
//
//  Created by 冯丽 on 2017/12/28.
//  Copyright © 2017年 chenghong. All rights reserved.
//

#import "ThreeViewController.h"
#import "TestScoresVC.h"
#import "TestScoresCell.h"
#import "AFClient.h"
#import "BGControl.h"
#define  kCellName @"TestScoresCell"

@interface ThreeViewController ()<UITableViewDelegate,UITableViewDataSource> {
    TestScoresCell *_cell;
    NSString *xuenianStr;
    NSString *xueqiStr;
    NSString *kemuStr;
    NSString *typeStr;
    NSMutableArray *oneArr;
    NSMutableArray *twoArr;
    NSMutableArray *threeArr;
    NSMutableArray *fourArr;
    NSDictionary  *userInfoDict;
    NSString *schoolYearId;
    NSString *xueQiId;
     NSString *kemuId;
    NSString  *typeId;
    NSInteger selectOneIndex;
    NSInteger selectTwoIndex;
    NSInteger selectThreeIndex;
    NSInteger selectFourIndex;
}


@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    oneArr = [NSMutableArray array];
    twoArr = [NSMutableArray array];
    threeArr = [NSMutableArray array];
    fourArr = [NSMutableArray array];
    self.bigTableView.dataSource = self;
    self.bigTableView.delegate = self;
    self.oneScroll.delegate = self;
    self.oneScroll.showsHorizontalScrollIndicator = NO;
    self.oneScroll.scrollEnabled = YES;
    self.signBth.layer.cornerRadius = 20.f;
    
    self.topViewOne.frame = CGRectMake(0, 0, kScreenSize.width, 60);
   
   
    [self.bigTableView setTableHeaderView:self.topViewOne];
    self.searchBth.layer.cornerRadius = 8.f;
    self.bigTableView.showsVerticalScrollIndicator = NO;
    self.bigTableView.separatorStyle = UITableViewCellSelectionStyleNone;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.dataArray = [[NSMutableArray alloc] init];
    self.navigationItem.title = @"考试成绩";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = YES;
    selectOneIndex = 0;
    selectTwoIndex = 0;
    selectThreeIndex = 0;
    selectFourIndex = 0;
    kemuStr = @"全部科目";
    typeStr = @"全部类型";
    [self createTopOneView];
    NSString *jsonString = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginData"];
    userInfoDict = [[BGControl dictionaryWithJsonString:jsonString] valueForKey:@"userInfo"];
    [self first];
    [self three];
    [self four];
    
   
}
- (void)createTopOneView {
    for (UIView *view in [self.topViewOne subviews]) {
        if (view.tag == 100 || view.tag == 101) {
             [view removeFromSuperview];
        }
       
        
    }
    UILabel *oneLab = [[UILabel alloc] init];
    oneLab.tag = 100;
    oneLab.text = kemuStr;
    oneLab.font = [UIFont systemFontOfSize:15];
    oneLab.textAlignment = NSTextAlignmentCenter;
    oneLab.textColor = KTabBarColor;
    oneLab.clipsToBounds = YES;
    oneLab.layer.cornerRadius = 10.f;
    oneLab.layer.borderColor = KTabBarColor.CGColor;
    oneLab.layer.borderWidth = 1.f;
    CGFloat oneWidth = [self calculateRowWidth:oneLab.text];
    oneLab.frame = CGRectMake(15, 10, oneWidth+10, 30);
    [self.topViewOne addSubview:oneLab];
    
    UILabel *twoLab = [[UILabel alloc] init];
    twoLab.tag = 101;
    twoLab.text = typeStr;
    twoLab.font = [UIFont systemFontOfSize:15];
    twoLab.textAlignment = NSTextAlignmentCenter;
    twoLab.textColor = KTabBarColor;
    twoLab.clipsToBounds = YES;
    twoLab.layer.cornerRadius = 10.f;
    twoLab.layer.borderColor = KTabBarColor.CGColor;
    twoLab.layer.borderWidth = 1.f;
    CGFloat twoWidth = [self calculateRowWidth:twoLab.text];
    twoLab.frame = CGRectMake(CGRectGetMaxX(oneLab.frame)+15,10 , twoWidth+10, 30);
    [self.topViewOne addSubview:twoLab];
    
    
}
- (void)first {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *jsonString = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginData"];
   NSDictionary *userDict = [[BGControl dictionaryWithJsonString:jsonString] valueForKey:@"userInfo"];
    [dict setObject:[NSString stringWithFormat:@"%@",[userDict valueForKey:@"schoolPid"]] forKey:@"schoolPid"];
    
    [self show];
    [[AFClient shareInstance] getResultwithUrlStr:@"schoolyear/get" withDict:dict progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([[responseBody valueForKey:@"code"] integerValue] == 0) {
            NSArray *arr = [responseBody valueForKey:@"data"];
            [oneArr removeAllObjects];
            for (int i = 0; i< arr.count; i++) {
                NSDictionary *dict = arr[i];
                if (i == 0) {
                    xuenianStr = [NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"startYear"],[dict valueForKey:@"endYear"]];
                    schoolYearId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                    
                    [self two];
                }
                [oneArr addObject:dict];
            }
            for (UIButton *findLabel in self.oneScroll.subviews) {
                [findLabel removeFromSuperview];
            }
            CGFloat oneBthWith = 15;
            for (int i =0; i<oneArr.count; i++) {
                UIButton *button = [[UIButton alloc] init];
                NSDictionary *dict = oneArr[i];
                [button setTitle:[NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"startYear"],[dict valueForKey:@"endYear"]] forState:UIControlStateNormal];
                
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.tag = 700 +i;
                if (i == 0) {
                    selectOneIndex = button.tag;
                    [button setTitleColor:KTabBarColor forState:UIControlStateNormal];
                    button.layer.cornerRadius = 15.f;
                    button.layer.borderColor = KTabBarColor.CGColor;
                    button.layer.borderWidth = 1.f;
                }else{
                    [button setTitleColor:KTextgrayColor forState:UIControlStateNormal];
                }
                CGFloat oneWidt = [self calculateRowWidth:button.titleLabel.text]+10;
                [button setFrame:CGRectMake(oneBthWith, 15, oneWidt, 30)];
                oneBthWith = oneBthWith +oneWidt +15;
                [self.oneScroll addSubview:button];
                
                [button addTarget:self action:@selector(oneClick:) forControlEvents:UIControlEventTouchUpInside];
                self.oneScroll.contentSize = CGSizeMake(oneBthWith+50,20);
            }
        }else{
            [self Alert:responseBody[@"msg"]];
        }
        
        
        [self dismiss];
    } failure:^(NSError *error) {
        [self dismiss];
    }];
    
    
}
- (void)two {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSString stringWithFormat:@"%@",schoolYearId] forKey:@"schoolYearId"];
    [self show];
    [[AFClient shareInstance] getResultwithUrlStr:@"schoolterm/get" withDict:dict progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([[responseBody valueForKey:@"code"] integerValue] == 0) {
            NSArray *arr = [responseBody valueForKey:@"data"];
            
            
            [twoArr removeAllObjects];
            
            for (int i = 0; i< arr.count; i++) {
                NSDictionary *dict = arr[i];
                if (i == 0) {
                    xuenianStr =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
                }
                [twoArr addObject:dict];
            }
            for (UIButton *findLabel in self.twoScroll.subviews) {
                [findLabel removeFromSuperview];
            }
            CGFloat twoBthWith = 15;
            for (int i =0; i<twoArr.count; i++) {
                UIButton *button = [[UIButton alloc] init];
                NSDictionary *dict = twoArr[i];
                xueQiId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                [self getData];
                [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.tag = 800 +i;
                if (i == 0) {
                    selectTwoIndex = button.tag;
                    [button setTitleColor:KTabBarColor forState:UIControlStateNormal];
                    button.layer.cornerRadius = 15.f;
                    button.layer.borderColor = KTabBarColor.CGColor;
                    button.layer.borderWidth = 1.f;
                }else{
                    [button setTitleColor:KTextgrayColor forState:UIControlStateNormal];
                }
                CGFloat oneWidt = [self calculateRowWidth:button.titleLabel.text]+10;
                [button setFrame:CGRectMake(twoBthWith, 15, oneWidt, 30)];
                twoBthWith = twoBthWith +oneWidt +15;
                [self.twoScroll addSubview:button];
                
                [button addTarget:self action:@selector(twoClick:) forControlEvents:UIControlEventTouchUpInside];
                self.twoScroll.contentSize = CGSizeMake(twoBthWith+50,20);
            }
            
        }else{
            [self Alert:responseBody[@"msg"]];
        }
        
        
        [self dismiss];
    } failure:^(NSError *error) {
        [self dismiss];
    }];
    
}
- (void)three {
    [self show];
    NSMutableDictionary *dictOne = [[NSMutableDictionary alloc] init];
    [dictOne setObject:[NSString stringWithFormat:@"%@",[userInfoDict valueForKey:@"schoolId"]] forKey:@"schoolId"];
    [[AFClient shareInstance] getResultwithUrlStr:@"course/get" withDict:dictOne progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([[responseBody valueForKey:@"code"] integerValue] == 0) {
            NSArray *arr = [responseBody valueForKey:@"data"];
            
            
            [threeArr removeAllObjects];
            
            for (int i = 0; i< arr.count; i++) {
                NSDictionary *dict = arr[i];
                //                    if (i == 0) {
                //                        kemuStr =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
                //                        [self createTopOneView];
                //                    }
                [threeArr addObject:dict];
            }
            [threeArr insertObject:@"全部科目" atIndex:0];
            for (UIButton *findLabel in self.threeScroll.subviews) {
                [findLabel removeFromSuperview];
            }
            CGFloat threeBthWith = 15;
            for (int i =0; i<threeArr.count; i++) {
                UIButton *button = [[UIButton alloc] init];
                if (i==0) {
                    [button setTitle:threeArr[i] forState:UIControlStateNormal];
                }else{
                    NSDictionary *dict = threeArr[i];
                    [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
                }
                
                
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.tag = 900 +i;
                if (i == 0) {
                    //                    kemuId = [[dict valueForKey:@"id"] integerValue];
                    selectThreeIndex = button.tag;
                    [button setTitleColor:KTabBarColor forState:UIControlStateNormal];
                    button.layer.cornerRadius = 15.f;
                    button.layer.borderColor = KTabBarColor.CGColor;
                    button.layer.borderWidth = 1.f;
                }else{
                    [button setTitleColor:KTextgrayColor forState:UIControlStateNormal];
                }
                CGFloat oneWidt = [self calculateRowWidth:button.titleLabel.text]+10;
                [button setFrame:CGRectMake(threeBthWith, 15, oneWidt, 30)];
                threeBthWith = threeBthWith +oneWidt +15;
                [self.threeScroll addSubview:button];
                
                [button addTarget:self action:@selector(threeClick:) forControlEvents:UIControlEventTouchUpInside];
                self.threeScroll.contentSize = CGSizeMake(threeBthWith+50,20);
            }
            
        }else{
            [self Alert:responseBody[@"msg"]];
        }
        
        
        [self dismiss];
    } failure:^(NSError *error) {
        [self dismiss];
    }];
}

- (void)four {
    NSMutableDictionary *dictTwo = [[NSMutableDictionary alloc] init];
    [dictTwo setObject:[NSString stringWithFormat:@"%@",[userInfoDict valueForKey:@"schoolPid"]] forKey:@"schoolPid"];
    [self show];
    [[AFClient shareInstance] getResultwithUrlStr:@"examTypeApp/get" withDict:dictTwo progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([[responseBody valueForKey:@"code"] integerValue] == 0) {
            NSArray *arr = [responseBody valueForKey:@"data"];
            
            [fourArr removeAllObjects];
            for (int i = 0; i< arr.count; i++) {
                NSDictionary *dict = arr[i];
                //                    if (i == 0) {
                //                        typeStr =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"name"]];
                //                        [self createTopOneView];
                //                    }
                [fourArr addObject:dict];
            }
            [fourArr insertObject:@"全部类型" atIndex:0];
            for (UIButton *findLabel in self.fourScroll.subviews) {
                [findLabel removeFromSuperview];
            }
            CGFloat fourBthWith = 15;
            for (int i =0; i<fourArr.count; i++) {
                UIButton *button = [[UIButton alloc] init];
                
                if (i==0) {
                    [button setTitle:fourArr[i] forState:UIControlStateNormal];
                }else{
                    NSDictionary *dict = fourArr[i];
                    [button setTitle:[dict valueForKey:@"name"] forState:UIControlStateNormal];
                }
                
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                button.tag = 1000 +i;
                if (i == 0) {
                    //                    typeId = [[dict valueForKey:@"id"] integerValue];
                    selectFourIndex = button.tag;
                    [button setTitleColor:KTabBarColor forState:UIControlStateNormal];
                    button.layer.cornerRadius = 15.f;
                    button.layer.borderColor = KTabBarColor.CGColor;
                    button.layer.borderWidth = 1.f;
                }else{
                    [button setTitleColor:KTextgrayColor forState:UIControlStateNormal];
                }
                CGFloat oneWidt = [self calculateRowWidth:button.titleLabel.text]+10;
                [button setFrame:CGRectMake(fourBthWith, 15, oneWidt, 30)];
                fourBthWith = fourBthWith +oneWidt +15;
                [self.fourScroll addSubview:button];
                
                [button addTarget:self action:@selector(fourClick:) forControlEvents:UIControlEventTouchUpInside];
                self.fourScroll.contentSize = CGSizeMake(fourBthWith+50,20);
            }
            
            
        }else{
            [self Alert:responseBody[@"msg"]];
        }
        
        
        [self dismiss];
    } failure:^(NSError *error) {
        [self dismiss];
    }];
    
}


- (void)getData {
    [self show];
    [[AFClient shareInstance] achievementByStudent:@"str" schoolyearId:schoolYearId schooltermId:xueQiId examtypeId:typeId projectId:kemuId   progressBlock:^(NSProgress *progress) {
        
    } success:^(id responseBody) {
        if ([[responseBody valueForKey:@"code"] integerValue] == 0) {
            self.dataArray = [[NSMutableArray alloc] init];
            self.dataArray = responseBody[@"data"];
             [self.bigTableView reloadData];
             [self dismiss];
        }else{
           [self Alert:responseBody[@"msg"]];
        }
        
         [self dismiss];
    } failure:^(NSError *error) {
        [self dismiss];
    }];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!_cell) {
        _cell = [[TestScoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    CGRect cellFrame = _cell.contentView.frame;
    cellFrame.size.width = kScreenSize.width;
    [_cell.contentView setFrame:cellFrame];
    NSDictionary *dict = self.dataArray[indexPath.row];
//        XyModel *model = self.dataArray[indexPath.row];
    
    [_cell showDict:dict];
    return _cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}
- (IBAction)buttonClick:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TestScoresVC *testScore = [storyboard instantiateViewControllerWithIdentifier:@"TestScoresVC"];
    [self.navigationController pushViewController:testScore animated:YES];
}
- (IBAction)choiceClick:(UIButton *)sender {
    [self.bigTableView setTableHeaderView:self.topView];
}
- (IBAction)okClick:(UIButton *)sender {
    [self createTopOneView];
    [self.bigTableView setTableHeaderView:self.topViewOne];
    [self getData];
}
- (CGFloat)calculateRowWidth:(NSString *)string {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}
- (void)oneClick:(UIButton *)bth {
    for (UIButton *findLabel in self.oneScroll.subviews) {
        if (findLabel.tag == selectOneIndex)
        {
            findLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            findLabel.layer.borderWidth=0;
            [findLabel setTitleColor:KTextgrayColor forState:UIControlStateNormal];
            
        }
    }
    NSDictionary *dict = oneArr[bth.tag - 700];
    for (UIButton *findLabel in self.oneScroll.subviews) {
        if (findLabel.tag == bth.tag)
            schoolYearId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        {   findLabel.clipsToBounds = YES;
            findLabel.layer.borderColor = KTabBarColor.CGColor;
            findLabel.layer.borderWidth=1;
            [findLabel setTitleColor:KTabBarColor forState:UIControlStateNormal];
            findLabel.layer.cornerRadius = 15.f;
            selectOneIndex = bth.tag;
        }
    }
   
    
    
    
}
- (void)twoClick:(UIButton *)bth {
    for (UIButton *findLabel in self.twoScroll.subviews) {
        if (findLabel.tag == selectTwoIndex)
        {
            findLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            findLabel.layer.borderWidth=0;
             [findLabel setTitleColor:KTextgrayColor forState:UIControlStateNormal];
            
        }
    }
    NSDictionary *dict = twoArr[bth.tag - 800];
    for (UIButton *findLabel in self.twoScroll.subviews) {
        if (findLabel.tag == bth.tag)
        {
            xueQiId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            findLabel.clipsToBounds = YES;
            findLabel.layer.borderColor = KTabBarColor.CGColor;
            findLabel.layer.borderWidth=1;
            [findLabel setTitleColor:KTabBarColor forState:UIControlStateNormal];
            findLabel.layer.cornerRadius = 15.f;
            selectTwoIndex = bth.tag;
        }
    }
}
- (void)threeClick:(UIButton *)bth {
    for (UIButton *findLabel in self.threeScroll.subviews) {
        if (findLabel.tag == selectThreeIndex)
        {
            findLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            findLabel.layer.borderWidth=0;
            [findLabel setTitleColor:KTextgrayColor forState:UIControlStateNormal];
            
        }
    }
    NSDictionary *dict = threeArr[bth.tag - 900];
    for (UIButton *findLabel in self.threeScroll.subviews) {
        if (findLabel.tag == bth.tag)
        {
            if (bth.tag == 900) {
                kemuId = [NSString stringWithFormat:@"%@",@""];
                kemuStr = @"全部科目";
            }else {
            kemuId =[NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                kemuStr = [dict valueForKey:@"name"] ;
            }
            findLabel.clipsToBounds = YES;
            findLabel.layer.borderColor = KTabBarColor.CGColor;
            findLabel.layer.borderWidth=1;
            [findLabel setTitleColor:KTabBarColor forState:UIControlStateNormal];
            findLabel.layer.cornerRadius = 15.f;
             selectThreeIndex = bth.tag;
        }
    }
}
- (void)fourClick:(UIButton *)bth {
    for (UIButton *findLabel in self.fourScroll.subviews) {
        if (findLabel.tag == selectFourIndex)
        {
            findLabel.layer.borderColor = [UIColor whiteColor].CGColor;
            findLabel.layer.borderWidth=0;
            [findLabel setTitleColor:KTextgrayColor forState:UIControlStateNormal];
            
        }
    }
     NSDictionary *dict = fourArr[bth.tag - 1000];
    for (UIButton *findLabel in self.fourScroll.subviews) {
        if (findLabel.tag == bth.tag)
        {
            if (bth.tag == 1000) {
                typeId = [NSString stringWithFormat:@"%@",@""];
                typeStr = @"全部类型";
                
            }else {
                typeId = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
                typeStr = [dict valueForKey:@"name"] ;
                
            }
           
            findLabel.clipsToBounds = YES;
            findLabel.layer.borderColor = KTabBarColor.CGColor;
            findLabel.layer.borderWidth=1;
            [findLabel setTitleColor:KTabBarColor forState:UIControlStateNormal];
            findLabel.layer.cornerRadius = 15.f;
            selectFourIndex = bth.tag;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TestScoresVC *testVC = [storyboard instantiateViewControllerWithIdentifier:@"TestScoresVC"];
    testVC.schoolyearId = [NSString stringWithFormat:@"%ld",(long)schoolYearId];
    testVC.schooltermId = [NSString stringWithFormat:@"%ld",(long)xueQiId];
    testVC.dataDict = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:testVC animated:YES];
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
