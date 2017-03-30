



//
//  RCDataManager.m
//  RCIM
//
//  Created by 郑文明 on 15/12/30.
//  Copyright © 2015年 郑文明. All rights reserved.
//

#import "RCDataManager.h"
#import "RCUserInfo+Addition.h"

@implementation RCDataManager{
        NSMutableArray *dataSoure;
}

- (instancetype)init{
    if (self = [super init]) {
        [RCIM sharedRCIM].userInfoDataSource = self;
    }
    return self;
}

+ (RCDataManager *)shareManager{
    static RCDataManager* manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}
/**
 *  从服务器同步好友列表
 */
-(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion
{
    dataSoure = [[NSMutableArray alloc]init];

    for (NSInteger i = 1; i<7; i++) {
        if(i==1){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"文明" portrait:@"http://weixin.ihk.cn/ihkwx_upload/fodder/20151210/1449727866527.jpg" QQ:@"740747055" sex:@"男"];
            [dataSoure addObject:aUserInfo];
        }else if (i==2) {
          RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"张全蛋" portrait:@"http://weixin.ihk.cn/ihkwx_upload/fodder/20151210/1449727755947.jpg" QQ:@"张全蛋的QQ信息" sex:@"男"];
            [dataSoure addObject:aUserInfo];
        }else if(i==3){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"怕瓦落地" portrait:@"http://pic.ihk.cn/head/base/ihk/2014/04/30/213816839.jpg" QQ:@"帕瓦落地的QQ信息" sex:@"男"];
            [dataSoure addObject:aUserInfo];

        }else if(i==4){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"凤姐" portrait:@"http://weixin.ihk.cn/ihkwx_upload/fodder/20151218/1450420944608.jpg" QQ:@"凤姐的QQ信息" sex:@"女"];
            [dataSoure addObject:aUserInfo];
            
        }else if(i==5){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"猴塞雷" portrait:@"http://pic.ihk.cn/head/80_93/ihk/2015/05/20/104331022.jpg" QQ:@"猴塞雷的QQ信息" sex:@"男"];
            [dataSoure addObject:aUserInfo];
            
        }else if(i==6){
            RCUserInfo *aUserInfo =[[RCUserInfo alloc]initWithUserId:[NSString stringWithFormat:@"%ld",i] name:@"犀利哥" portrait:@"" QQ:@"犀利哥的QQ信息" sex:@"男"];
            [dataSoure addObject:aUserInfo];
            
        }
        
        
    }

    
   
    //limeng delete , 后面要加上的，这个是给appdelegate里面的朋友数组赋值的。
    //[AppDelegate shareAppDelegate].friendsArray = dataSoure;
    completion(dataSoure,YES);

}
/**
 *  从服务器同步群组列表
 */
-(void) syncGroupList:(void (^)(NSMutableArray * groups,BOOL isSuccess))completion{
  
}

#pragma mark
#pragma mark 根据userId获取RCUserInfo
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId{
        return nil;
}
#pragma mark
#pragma mark 根据userId获取RCGroup
-(RCGroup *)currentGroupInfoWithGroupId:(NSString *)groupId{
        return nil;
}
-(NSString *)currentNameWithUserId:(NSString *)userId{
        return nil;
}
#pragma mark
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString*)userId completion:(void (^)(RCUserInfo*))completion
{
    NSLog(@"getUserInfoWithUserId ----- %@", userId);
    
    if (userId == nil || [userId length] == 0 )
    {
        [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
            
        }];
        
        completion(nil);
        return ;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        RCUserInfo *myselfInfo = [[RCUserInfo alloc]initWithUserId:[RCIM sharedRCIM].currentUserInfo.userId name:[RCIM sharedRCIM].currentUserInfo.name portrait:[RCIM sharedRCIM].currentUserInfo.portraitUri QQ:[RCIM sharedRCIM].currentUserInfo.QQ sex:[RCIM sharedRCIM].currentUserInfo.sex];
        completion(myselfInfo);
        
    }
    
    }
#pragma mark
#pragma mark - RCIMGroupInfoDataSource
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    }
-(void)loginRongCloudWithUserInfo:(RCUserInfo *)userInfo withToken:(NSString *)token{
                [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {
                    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor redColor];
                    NSLog(@"login success with userId %@",userId);
                    //同步好友列表
                    [self syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
                        NSLog(@"%@",friends);
                        if (isSuccess) {
                            [self syncGroupList:^(NSMutableArray *groups, BOOL isSuccess) {
                                if (isSuccess) {
                                    NSLog(@" success 发送通知");
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"alreadyLogin" object:nil];
                                }
                            }];
                           
                        }
                    }];
                    

                    [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                    [[RCDataManager shareManager] refreshBadgeValue];
                } error:^(RCConnectErrorCode status) {
                    NSLog(@"status = %ld",(long)status);
                } tokenIncorrect:^{
                    
                    NSLog(@"token 错误");
                }];
            
            
        
   
}

-(void)refreshBadgeValue{
    
   
}
-(BOOL)hasTheFriendWithUserId:(NSString *)userId{
    
    return NO;
}
@end

