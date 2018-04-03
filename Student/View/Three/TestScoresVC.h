//
//  TestScoresVC.h
//  Teacher
//
//  Created by 冯丽 on 2018/1/10.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "JJBaseController.h"

@interface TestScoresVC : JJBaseController
@property (strong, nonatomic) IBOutlet UIView *naVie;
@property (strong, nonatomic) IBOutlet UILabel *kemuLab;
@property (strong, nonatomic) IBOutlet UILabel *scoresLab;
@property (strong, nonatomic) IBOutlet UILabel *testTypeLab;

@property (strong, nonatomic) IBOutlet UILabel *xuenianLab;
@property (strong, nonatomic) IBOutlet UILabel *xueqiLab;
@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UILabel *zongLab;
@property (strong, nonatomic) IBOutlet UILabel *deFenLab;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIScrollView *bigScrollView;
@property (strong, nonatomic) NSString *schoolyearId;
@property (strong, nonatomic) NSString *schooltermId;
@property (strong, nonatomic) NSDictionary *dataDict;
@end
