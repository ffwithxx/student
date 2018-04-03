//
//  OneCell.m
//  Teacher
//
//  Created by 冯丽 on 2017/12/28.
//  Copyright © 2017年 chenghong. All rights reserved.
//

#import "OneCell.h"


@implementation OneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonClick:(UIButton *)sender {
    if ( _signDelegate && [_signDelegate respondsToSelector:@selector(postStr:)]) {
        [_signDelegate postStr:@"1"];
    }
}
-(void)showModelWithDict:(NSDictionary *)dict{
    self.timeLab.text = [NSString stringWithFormat:@"%@-%@",[dict valueForKey:@"timeStart"],[dict valueForKey:@"timeOff"]];
    self.adressLab.text = [dict valueForKey:@"classroomName"];
    self.nameLab.text =  [dict valueForKey:@"leaderName"];
     self.kemuLab.text =  [dict valueForKey:@"courseName"];
    self.signBth.layer.cornerRadius = 5.f;
    self.signBth.layer.borderColor = KTabBarColor.CGColor;
    self.signBth.layer.borderWidth = 2.f;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
