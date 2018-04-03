//
//  LeftViewController.m
//  Teacher
//
//  Created by 冯丽 on 2017/12/18.
//  Copyright © 2017年 chenghong. All rights reserved.
//

#import "LeftViewController.h"
#import "SettingPswController.h"
#import "AppDelegate.h"
#import "MemberShipVC.h"
#import "BGControl.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self first];
    // Do any additional setup after loading the view.
}


- (void)first {
    NSString *jsonString = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginData"];
    NSDictionary *userInfoDict = [[BGControl dictionaryWithJsonString:jsonString] valueForKey:@"userInfo"];
    self.nameLab.text =[NSString stringWithFormat:@"%@ %@",@"HI",[userInfoDict valueForKey:@"nameCn"]];
    self.IdNumLab.text = [NSString stringWithFormat:@"%@",[userInfoDict valueForKey:@"code"]];
    self.positionLab.text = @"学生";
}
/**
 点击事件

 @param sender 201个人信息
 
 202 修改密码
 
 203 版本更新
 204退出登录
 */
- (IBAction)buttonClick:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];//关闭左侧抽屉
    if (sender.tag == 201) {
        MemberShipVC *memberVC = [storyboard instantiateViewControllerWithIdentifier:@"MemberShipVC"];
        [tempAppDelegate.mainNavigationController pushViewController:memberVC animated:NO];
    }else if (sender.tag == 202){
        SettingPswController *pswVC = [storyboard instantiateViewControllerWithIdentifier:@"SettingPswController"];
        [tempAppDelegate.mainNavigationController pushViewController:pswVC animated:NO];
    }else if (sender.tag == 203){
       
    }else if (sender.tag == 204){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tLogin" object:nil];
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
