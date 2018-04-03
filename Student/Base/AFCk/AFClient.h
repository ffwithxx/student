//
//  AFClient.h
//  noteMan
//
//  Created by 周博 on 16/12/12.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kHttpHeader @"http://101.231.72.22:8080/rest/"
#define KHeader @"2DD8F2D2-4C62-4593-B745-AE4254BCBE4C"
@interface AFClient : NSObject

typedef void(^ProgressBlock)(NSProgress *progress);
typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlcok)(NSError *error);

@property (nonatomic,strong)ProgressBlock progressBolck;
@property (nonatomic,strong)SuccessBlock successBlock;
@property (nonatomic,strong)FailureBlcok failureBlock;


+(instancetype)shareInstance;
- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord   progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//1.课表查询接口
- (void)TeacherScheduleBystudentId:(NSString *)studentId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//个人密码
- (void)UpdatePasswordwithDict:(NSDictionary *)dataDict progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;
//6.app查询消息公告
//6.app查询消息公告
- (void)noticeWithId:(NSString  *)idStr witnPage:(NSString *)page withLimit:(NSString *)limit  progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;
//查询学生成绩
-(void)achievementByStudent:(NSString *)studentId schoolyearId:(NSString *)schoolyearId schooltermId:(NSString *)schooltermId examtypeId:(NSString *)examtypeId projectId:(NSString *)projectId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

- (void)studentAttendanceWithStudent:(NSString *)studentId withStime:(NSString *)stime progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//4.查询发布
- (void)feedbackWithteacherId:(NSString *)studentId withType:(NSString *)type progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//4.1查询回复发布详情
-(void)FeedbackWithDetailWithDict:(NSDictionary *)dict progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;
- (void)techerFeedBackWithTeacher:(NSString *)teacherId withContent:(NSString *)content withFeedbackId:(NSString *)feedbackId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

//成绩查询接口
- (void)getResultwithUrlStr:(NSString *)urlStr withDict:(NSDictionary *)dict progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;

- (void)getAchievementWithSchoolyearIdWith:(NSString *)schoolyearId withschooltermId:(NSString *)schooltermId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure;
@end
