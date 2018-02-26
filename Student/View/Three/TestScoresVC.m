//
//  TestScoresVC.m
//  Teacher
//
//  Created by 冯丽 on 2018/1/10.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "TestScoresVC.h"
#import "TestScoresCell.h"
#define  kCellName @"TestScoresCell"
@interface TestScoresVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate> {
        TestScoresCell *_cell;
}

@end

@implementation TestScoresVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bigScrollView.hidden = YES;
//    if (kiPhoneX) {
//        self.naVie.frame = CGRectMake(0, 0, kScreenSize.width, kNavHeight);
        self.bigScrollView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        self.bigTableView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//    }
    self.topView.frame = CGRectMake(0, 0, kScreenSize.width, 100);
    [self.bigTableView setTableHeaderView:self.topView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.title = @"考试成绩";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg_shadow@2x"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = NO;
}
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (sender.tag == 310 ||sender.tag == 311) {
        [self.bigScrollView removeFromSuperview];
        self.bigScrollView.hidden = YES;
        self.blackButton.hidden = YES;
    }
}
- (void)blackButtonClick {
    [self.bigScrollView removeFromSuperview];
    self.bigScrollView.hidden = YES;
    self.blackButton.hidden = YES;
}
#pragma 展示筛选条件
- (IBAction)tiaoClick:(UIButton *)sender {
    self.blackButton.hidden = NO;
    self.bigScrollView.delegate = self;
    self.bigScrollView.showsVerticalScrollIndicator = NO;
    self.bigScrollView.contentSize = CGSizeMake(kScreenSize.width,550);
    self.bigScrollView.scrollEnabled = YES;
    self.bigScrollView.hidden = NO;
    self.cancleBth.layer.cornerRadius = 5.f;
    self.cancleBth.layer.borderColor = KTabBarColor.CGColor;
    self.cancleBth.layer.borderWidth = 1.f;
    self.searchBth.layer.cornerRadius = 5.f;
    [self.view addSubview:self.bigScrollView];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:kCellName];
    if (!_cell) {
        _cell = [[TestScoresCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellName];
    }
    CGRect cellFrame = _cell.contentView.frame;
    cellFrame.size.width = kScreenSize.width;
    [_cell.contentView setFrame:cellFrame];
    //    XyModel *model = self.dataArray[indexPath.row];
    
    
    return _cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
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
