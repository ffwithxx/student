//
//  TestScoresCell.m
//  Teacher
//
//  Created by 冯丽 on 2018/1/10.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "TestScoresCell.h"

@implementation TestScoresCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)showDict:(NSDictionary *)dict {
    self.oneLab.text = [NSString stringWithFormat:@"%@%@%@",@"《",[dict valueForKey:@"examTypeName"],@"》"];
    self.twoLab.text = [dict valueForKey:@"projectName"];
    self.threeLab.text = [dict valueForKey:@"examName"];
    self.fourLab.text = [dict valueForKey:@"achievement"];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
