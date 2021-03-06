//
//  ManagementCell.h
//  Teacher
//
//  Created by 冯丽 on 2018/1/11.
//  Copyright © 2018年 chenghong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol maxHeiDelegate <NSObject>

@optional

-(void)getHei:(CGFloat)maxHei  withIndex:(NSInteger)index;
@end
@interface ManagementCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *detailLab;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@property(nonatomic,weak) id<maxHeiDelegate> maxdelegate;
- (void)showWithDict:(NSDictionary *)dict withTeacher:(NSString *)teacher withIndex:(NSInteger)index;
@end
