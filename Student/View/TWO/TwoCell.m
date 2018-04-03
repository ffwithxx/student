//
//  TwoCell.m
//  Teacher
//
//  Created by 冯丽 on 2018/1/8.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "TwoCell.h"

@implementation TwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonClick:(UIButton *)sender {
    if (_attendanceDelegate && [_attendanceDelegate respondsToSelector:@selector(postTagStr:)]) {
        [_attendanceDelegate postTagStr:[NSString stringWithFormat:@"%ld",sender.tag]];
    }
}
- (void)showModelWithDict:(NSDictionary *)dict{

    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"timeStart"],[dict valueForKey:@"timeOff"]];
    self.kemuLab.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"courseName"]];
    NSInteger attendanceStatus = [[dict valueForKey:@"attendanceStatus"] integerValue];
    if (attendanceStatus == 0) {
        [self.signBth setTitle:@"上课" forState:UIControlStateNormal];
        [self.signBth setTitleColor:KTextgrayColor forState:UIControlStateNormal];
    }else if (attendanceStatus == 1){
        [self.signBth setTitle:@"请假" forState:UIControlStateNormal];
        [self.signBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
    }else if (attendanceStatus == 2){
        [self.signBth setTitle:@"迟到" forState:UIControlStateNormal];
        [self.signBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
    }else if (attendanceStatus == 3){
        [self.signBth setTitle:@"早退" forState:UIControlStateNormal];
        [self.signBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
    }else if (attendanceStatus == 4){
        [self.signBth setTitle:@"旷课" forState:UIControlStateNormal];
        [self.signBth setTitleColor:KTabBarColor forState:UIControlStateNormal];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
