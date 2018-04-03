//
//  TestScoresCell.h
//  Teacher
//
//  Created by 冯丽 on 2018/1/10.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestScoresCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *levelLab;
@property (strong, nonatomic) IBOutlet UILabel *scoreLab;
@property (strong, nonatomic) IBOutlet UILabel *oneLab;
@property (strong, nonatomic) IBOutlet UILabel *twoLab;
@property (strong, nonatomic) IBOutlet UILabel *threeLab;
@property (strong, nonatomic) IBOutlet UILabel *fourLab;


- (void)showDict:(NSDictionary *)dict;
@end
