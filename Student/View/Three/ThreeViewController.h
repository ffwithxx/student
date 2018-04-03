//
//  ThreeViewController.h
//  Teacher
//
//  Created by 冯丽 on 2017/12/28.
//  Copyright © 2017年 chenghong. All rights reserved.
//

#import "JJBaseController.h"

@interface ThreeViewController : JJBaseController
@property (strong, nonatomic) IBOutlet UITableView *bigTableView;

@property (strong, nonatomic) IBOutlet UILabel *xuenianLab;
@property (strong, nonatomic) IBOutlet UILabel *xueqiLab;
@property (strong, nonatomic) IBOutlet UILabel *xiaoquLab;
@property (strong, nonatomic) IBOutlet UILabel *xiangmuLab;
@property (strong, nonatomic) IBOutlet UILabel *nianjiLab;
@property (strong, nonatomic) IBOutlet UILabel *banjiLab;
@property (strong, nonatomic) IBOutlet UILabel *kechengLab;
@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UIButton *searchBth;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *oneView;
@property (strong, nonatomic) IBOutlet UIView *twoView;
@property (strong, nonatomic) IBOutlet UIView *threeView;
@property (strong, nonatomic) IBOutlet UIView *fourView;
@property (strong, nonatomic) IBOutlet UIButton *signBth;
@property (strong, nonatomic) IBOutlet UIScrollView *oneScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *twoScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *threeScroll;
@property (strong, nonatomic) IBOutlet UIScrollView *fourScroll;
@property (strong, nonatomic) IBOutlet UIView *topViewOne;

@end
