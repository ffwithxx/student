 //
//  AFClient.m
//  noteMan
//
//  Created by 周博 on 16/12/12.
//  Copyright © 2016年 BogoZhou. All rights reserved.
//

#import "AFClient.h"
#import "BGControl.h"
#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import <AVFoundation/AVFoundation.h>
@interface AFClient ()
{
    NSString *_url;
    NSDictionary *_dict;
    NSString *idStr;
    NSURL  *_filePathURL;
    NSString * _fileName;
    NSProgress *_progressone;
    NSString *token;
    NSString *jobCode;
    NSDictionary *userInfoDict;
   
  
}
@end

@implementation AFClient


+(instancetype)shareInstance{
    static AFClient *defineAFClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defineAFClient = [[AFClient alloc] init];
    });
    return defineAFClient;
}

- (NSData *)resetSizeOfImageData:(UIImage *)source_image maxSize:(NSInteger)maxSize
{
    //先调整分辨率
    CGSize newSize = CGSizeMake(source_image.size.width, source_image.size.height);
    
    CGFloat tempHeight = newSize.height / 1024;
    CGFloat tempWidth = newSize.width / 1024;
    
    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(source_image.size.width / tempWidth, source_image.size.height / tempWidth);
    }
    else if (tempHeight > 1.0 && tempWidth < tempHeight){
        newSize = CGSizeMake(source_image.size.width / tempHeight, source_image.size.height / tempHeight);
    }
    
    UIGraphicsBeginImageContext(newSize);
    [source_image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整大小
    NSData *imageData = UIImageJPEGRepresentation(newImage,1.0);
    NSUInteger sizeOrigin = [imageData length];
    NSUInteger sizeOriginKB = sizeOrigin / 1024;
    if (sizeOriginKB > maxSize) {
        NSData *finallImageData = UIImageJPEGRepresentation(newImage,0.50);
        return finallImageData;
    }
    
    return imageData;
}

- (AFHTTPSessionManager *)creatManager{
    AFHTTPSessionManager* mgr = [AFHTTPSessionManager manager];
    token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    jobCode =  [[NSUserDefaults standardUserDefaults] valueForKey:@"jobCode"];
    NSString *jsonString = [[NSUserDefaults standardUserDefaults]valueForKey:@"loginData"];
    userInfoDict = [[BGControl dictionaryWithJsonString:jsonString] valueForKey:@"userInfo"];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    mgr.securityPolicy  = securityPolicy;
    mgr.requestSerializer=[AFHTTPRequestSerializer serializer];
    mgr.responseSerializer=[AFHTTPResponseSerializer serializer];
    mgr.requestSerializer.timeoutInterval = 20.f;
    return mgr;
}
- (void)loginWithUserName:(NSString *)userName passWord:(NSString *)passWord   progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"sysuser/login"];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"username",passWord,@"password", nil];
    AFHTTPSessionManager *manager = [self creatManager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/xml", @"text/xml",@"text/html",@"text/plain",@"application/json", nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:_dict options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    AFURLSessionManager *manager1 = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:_url parameters:nil error:nil];
    req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager1 dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error) {
        if (!error) { NSLog(@"Reply JSON: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if (success) {
                    success(responseObject);
                    NSLog(@"%@",responseObject);
                }
                
            }
        } else {
            
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if (failure) {
                failure(error);
            }
            
        } }] resume];
    
}

//1.课表查询接口
- (void)TeacherScheduleBystudentId:(NSString *)studentId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"StudentSchedules/get"];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"id"],@"studentId", nil];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager GET:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            success(dict);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)UpdatePasswordwithDict:(NSDictionary *)dataDict progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure{
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"sysuser/updatePassword"];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager POST:_url parameters:dataDict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            success(dict);
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

//6.app查询消息公告
- (void)noticeWithId:(NSString  *)idStr witnPage:(NSString *)page withLimit:(NSString *)limit  progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"notice/get"];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"schoolId"],@"schoolId",page,@"page",limit,@"limit", nil];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            success(dict);
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//成绩查询接口
- (void)getResultwithUrlStr:(NSString *)urlStr withDict:(NSDictionary *)dict progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,urlStr];
    
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"schoolPid"],@"schoolPid", nil];
    [manager POST:_url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            success(dict);
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//查询学生成绩
-(void)achievementByStudent:(NSString *)studentId schoolyearId:(NSString *)schoolyearId schooltermId:(NSString *)schooltermId examtypeId:(NSString *)examtypeId projectId:(NSString *)projectId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"achievement/Students/get"];
    
     _dict = [NSDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"id"],@"studentId",schoolyearId,@"schoolyearId",schooltermId,@"schooltermId",examtypeId,@"examtypeId",projectId,@"projectId", nil];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            success(dict);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)studentAttendanceWithStudent:(NSString *)studentId withStime:(NSString *)stime progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"student/attendance/get"];
    _dict = [NSDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"id"],@"studentId",stime,@"stime" ,nil];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    [manager GET:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            success(dict);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSLog(@"%@",jsonString);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)feedbackWithteacherId:(NSString *)studentId withType:(NSString *)type progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"feedstudentget/query"];
    
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    _dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"id"],@"studentId",type,@"type", nil];
    [manager GET:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            success(dict);
            
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//4.1查询回复发布详情
-(void)FeedbackWithDetailWithDict:(NSDictionary *)dict progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"feedbackreply/get"];
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [manager POST:_url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (void)techerFeedBackWithTeacher:(NSString *)teacherId withContent:(NSString *)content withFeedbackId:(NSString *)feedbackId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"feedback/studentFeedBack"];
    
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    _dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:teacherId,@"teacherId",[userInfoDict valueForKey:@"id"],@"studentId",content,@"content", feedbackId,@"feedbackId",nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (void)getAchievementWithSchoolyearIdWith:(NSString *)schoolyearId withschooltermId:(NSString *)schooltermId progressBlock:(ProgressBlock)progress success:(SuccessBlock)success failure:(FailureBlcok)failure {
    _url = [NSString stringWithFormat:@"%@%@",kHttpHeader,@"achievement/student/get"];
    
    AFHTTPSessionManager *manager = [self creatManager];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    _dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:[userInfoDict valueForKey:@"id"],@"studentId",schoolyearId,@"schoolyearId", schooltermId,@"schooltermId",nil];
    [manager POST:_url parameters:_dict progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            //             获取所有数据报头信息
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)task.response;
            NSDictionary *fields = [HTTPResponse allHeaderFields];// 原生NSURLConnection写法
            NSLog(@"fields = %@", [fields description]);
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            success(dict);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
