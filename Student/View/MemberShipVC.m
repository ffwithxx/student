//
//  MemberShipVC.m
//  Teacher
//
//  Created by 冯丽 on 2018/1/4.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "MemberShipVC.h"
#import "BGControl.h"
#import "AFClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface MemberShipVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MemberShipVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topView.frame = CGRectMake(0, 0, kScreenSize.width, 1180);
    [self.bigTableView setTableHeaderView:self.topView];
//    if (kiPhoneX) {
//        self.navView.frame = CGRectMake(0, 0, kScreenSize.width, kNavHeight);
        self.bigTableView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//    }
    self.bigTableView.showsVerticalScrollIndicator = NO;
    self.bigTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        self.navigationItem.title = @"个人信息";
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bg_shadow@2x"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)first {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginData"];
    NSDictionary *dict = [[BGControl dictionaryWithJsonString:jsonString] valueForKey:@"userInfo"];
   [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict valueForKey:@"photoUrl"]]] placeholderImage:[UIImage imageNamed:@"icon_moren(1).png"]];
    self.nameLab.text = [BGControl textIsNull: [dict valueForKey:@"nameCn"]];
    self.eNameLab.text =  [BGControl textIsNull: [dict valueForKey:@"nameEn"]];
    self.pinyinLab.text =[BGControl textIsNull: [dict valueForKey:@"namePinyin"]];
    
    self.sexLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"sex"]] ];
    self.guojiLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"country"]] ];
     self.birthdayLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"birthday"]]];
    self.ageLab.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"age"]];
self.shenfenLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"idCard"]]] ;
    self.huzhaoLab.text =[NSString stringWithFormat:@"%@",[BGControl textIsNull:[NSString stringWithFormat:@"%@",[dict valueForKey:@"passport"]]]] ;
    self.emailLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"email"]]] ;
self.adressLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"address"]]] ;
    self.tongxinLab.text =  [NSString stringWithFormat:@"%@",[BGControl textIsNull:[dict valueForKey:@"mailingAddr"]]] ;
    self.xuehaoLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull:[NSString stringWithFormat:@"%@",[dict valueForKey:@"code"]]]] ;
    self.xiangmuLab.text = [NSString stringWithFormat:@"%@", [BGControl textIsNull:[dict valueForKey:@"projectName"]]] ;
    self.xiaoquLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull: [dict valueForKey:@"schoolName"]]];;
    self.ruxueDateLab.text = [NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",[BGControl textIsNull: [dict valueForKey:@"admissionDate"]]]];
    self.nianjiLab.text = [BGControl textIsNull: [dict valueForKey:@"gradeName"]];
    self.banjiLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull: [dict valueForKey:@"className"]]];
    self.zhuangtaiLab.text = [NSString stringWithFormat:@"%@",[BGControl textIsNull: [dict valueForKey:@"status"]]];
}
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdetifider];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    return cell;
}
- (IBAction)buttonClick:(UIButton *)sender {
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
