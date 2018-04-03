//
//  TestScoresVC.m
//  Teacher
//
//  Created by 冯丽 on 2018/1/10.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "TestScoresVC.h"
#import "TestScoresCell.h"
#import "AFClient.h"
#define  kCellName @"TestScoresCell"
@interface TestScoresVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
        TestScoresCell *_cell;
}

@end

@implementation TestScoresVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    if (kiPhoneX) {
        self.naVie.frame = CGRectMake(0, 0, kScreenSize.width, kNavHeight);
        self.bigScrollView.frame = CGRectMake(0, kNavHeight, kScreenSize.width, 800);
    
    }
    [self first];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"考试成绩";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg_shadow@2x"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)first {
    self.testTypeLab.text = [self.dataDict valueForKey:@"examName"];
    self.scoresLab.text = [self.dataDict valueForKey:@"achievement"];
    self.xuenianLab.text = [NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"syName"]];
    self.xueqiLab.text = [self.dataDict valueForKey:@"stName"];
    self.kemuLab.text = [self.dataDict valueForKey:@"projectName"];
    self.typeLab.text = [self.dataDict valueForKey:@"examTypeName"];
    self.zongLab.text = [NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"tScore"]];
    self.deFenLab.text = [NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"score"]];
//    [self show];
//    [[AFClient shareInstance] getAchievementWithSchoolyearIdWith:self.schoolyearId withschooltermId:self.schooltermId progressBlock:^(NSProgress *progress) {
//
//    } success:^(id responseBody) {
//        if ([[responseBody valueForKey:@"code"] integerValue] == 0) {
//
//
//            [self dismiss];
//        }else{
//            [self Alert:responseBody[@"msg"]];
//        }
//
//        [self dismiss];
//    } failure:^(NSError *error) {
//        [self dismiss];
//    }];
}
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
