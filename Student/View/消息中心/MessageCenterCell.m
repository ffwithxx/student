//
//  MessageCenterCell.m
//  Teacher
//
//  Created by 冯丽 on 2018/1/9.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import "MessageCenterCell.h"

@implementation MessageCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)showModel {
    self.detailView.layer.cornerRadius = 5.f;
    self.detailLaB.numberOfLines = 2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
