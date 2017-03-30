//
//  RCDHttpTool.m
//  RCloudMessage
//
//  Created by Liv on 15/4/15.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RCDHttpTool.h"
#import "AFHttpTool.h"


#import "RCDUserInfo.h"
//#import "RCDUtilities.h"

//#import "SortForTime.h"
//#import "RCDUserInfoManager.h"

@implementation RCDHttpTool

+ (RCDHttpTool *)shareInstance {
  static RCDHttpTool *instance = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    instance = [[[self class] alloc] init];
    instance.allGroups = [NSMutableArray new];
    instance.allFriends = [NSMutableArray new];
  });
  return instance;
}

//创建群组
- (void)createGroupWithGroupName:(NSString *)groupName
                 GroupMemberList:(NSArray *)groupMemberList
                        complete:(void (^)(NSString *))userId {
  [AFHttpTool createGroupWithGroupName:groupName
      groupMemberList:groupMemberList
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          NSDictionary *result = response[@"result"];
          userId(result[@"id"]);
        } else {
          userId(nil);
        }
      }
      failure:^(NSError *err) {
        userId(nil);
      }];
}

//设置群组头像
- (void)setGroupPortraitUri:(NSString *)portraitUri
                    groupId:(NSString *)groupId
                   complete:(void (^)(BOOL))result {
  [AFHttpTool setGroupPortraitUri:portraitUri
      groupId:groupId
      success:^(id response) {
        if ([response[@"code"] intValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}


//设置用户头像上传到demo server
- (void)setUserPortraitUri:(NSString *)portraitUri
                  complete:(void (^)(BOOL))result {
  [AFHttpTool setUserPortraitUri:portraitUri
      success:^(id response) {
        if ([response[@"code"] intValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}



//加入群组(暂时没有用到这个接口)
- (void)joinGroupWithGroupId:(NSString *)groupID
                    complete:(void (^)(BOOL))result {
  [AFHttpTool joinGroupWithGroupId:groupID
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}

//添加群组成员
- (void)addUsersIntoGroup:(NSString *)groupID
                  usersId:(NSMutableArray *)usersId
                 complete:(void (^)(BOOL))result {
  [AFHttpTool addUsersIntoGroup:groupID
      usersId:usersId
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}

//将用户踢出群组
- (void)kickUsersOutOfGroup:(NSString *)groupID
                    usersId:(NSMutableArray *)usersId
                   complete:(void (^)(BOOL))result {
  [AFHttpTool kickUsersOutOfGroup:groupID
      usersId:usersId
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}

//退出群组
- (void)quitGroupWithGroupId:(NSString *)groupID
                    complete:(void (^)(BOOL))result {
  [AFHttpTool quitGroupWithGroupId:groupID
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}

//解散群组
- (void)dismissGroupWithGroupId:(NSString *)groupID
                       complete:(void (^)(BOOL))result {
  [AFHttpTool dismissGroupWithGroupId:groupID
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}

//修改群组名称
- (void)renameGroupWithGoupId:(NSString *)groupID
                    groupName:(NSString *)groupName
                     complete:(void (^)(BOOL))result {
  [AFHttpTool renameGroupWithGroupId:groupID
      GroupName:groupName
      success:^(id response) {
        if ([response[@"code"] integerValue] == 200) {
          result(YES);
        } else {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        result(NO);
      }];
}

- (void)getSquareInfoCompletion:(void (^)(NSMutableArray *result))completion {
  [AFHttpTool getSquareInfoSuccess:^(id response) {
    if ([response[@"code"] integerValue] == 200) {
      completion(response[@"result"]);
    } else {
      completion(nil);
    }
  }
      Failure:^(NSError *err) {
        completion(nil);
      }];
}


- (void)requestFriend:(NSString *)userId complete:(void (^)(BOOL))result {
  [AFHttpTool inviteUser:userId
      success:^(id response) {
        if (result && [response[@"code"] intValue] == 200) {
          dispatch_async(dispatch_get_main_queue(), ^(void) {
            result(YES);
          });
        } else if (result) {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        if(result) {
          result(NO);
        }
      }];
}

- (void)processInviteFriendRequest:(NSString *)userId
                          complete:(void (^)(BOOL))result {
  [AFHttpTool processInviteFriendRequest:userId
      success:^(id response) {
        if (result && [response[@"code"] intValue] == 200) {
          dispatch_async(dispatch_get_main_queue(), ^(void) {
            result(YES);
          });
        } else if (result){
          result(NO);
        }
      }
      failure:^(id response) {
        if (result) {
          result(NO);
        }
      }];
}

- (void)AddToBlacklist:(NSString *)userId
              complete:(void (^)(BOOL result))result {
  [AFHttpTool addToBlacklist:userId
      success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (result && [code isEqualToString:@"200"]) {
          result(YES);
        } else if(result) {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        if (result) {
          result(NO);
        }
      }];
}

- (void)RemoveToBlacklist:(NSString *)userId
                 complete:(void (^)(BOOL result))result {
  [AFHttpTool removeToBlacklist:userId
      success:^(id response) {
        NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
        if (result && [code isEqualToString:@"200"]) {
          result(YES);
        } else if(result) {
          result(NO);
        }
      }
      failure:^(NSError *err) {
        if (result) {
          result(NO);
        }
      }];
}

- (void)getBlacklistcomplete:(void (^)(NSMutableArray *))blacklist {
  [AFHttpTool getBlacklistsuccess:^(id response) {
    NSString *code = [NSString stringWithFormat:@"%@", response[@"code"]];
    if (blacklist && [code isEqualToString:@"200"]) {
      NSMutableArray *result = response[@"result"];
      blacklist(result);
    } else if(blacklist) {
      blacklist(nil);
    }
  }
      failure:^(NSError *err) {
        if(blacklist) {
          blacklist(nil);
        }
      }];
}

- (void)updateName:(NSString *)userName
           success:(void (^)(id response))success
           failure:(void (^)(NSError *err))failure {
  [AFHttpTool updateName:userName
      success:^(id response) {
        success(response);
      }
      failure:^(NSError *err) {
        failure(err);
      }];
}

- (void)uploadImageToQiNiu:(NSString *)userId
                 ImageData:(NSData *)image
                   success:(void (^)(NSString *url))success
                   failure:(void (^)(NSError *err))failure {
  [AFHttpTool uploadFile:image
      userId:userId
      success:^(id response) {
        if ([response[@"key"] length] > 0) {
          NSString *key = response[@"key"];
          NSString *QiNiuDomai = [DEFAULTS objectForKey:@"QiNiuDomain"];
          NSString *imageUrl =
              [NSString stringWithFormat:@"http://%@/%@", QiNiuDomai, key];
          success(imageUrl);
        }
      }
      failure:^(NSError *err) {
        failure(err);
      }];
}

- (void)getVersioncomplete:(void (^)(NSDictionary *))versionInfo {
  [AFHttpTool getVersionsuccess:^(id response) {
    if (response) {
      NSDictionary *iOSResult = response[@"iOS"];
      NSString *sealtalkBuild = iOSResult[@"build"];
      NSString *applistURL = iOSResult[@"url"];
      
      NSDictionary *result;
      NSString *currentBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
      
      NSDate *currentBuildDate = [self stringToDate:currentBuild];
      NSDate *buildDtate = [self stringToDate:sealtalkBuild];
      NSTimeInterval secondsInterval= [currentBuildDate timeIntervalSinceDate:buildDtate];
      if (secondsInterval < 0) {
        result = [NSDictionary dictionaryWithObjectsAndKeys:@"YES",@"isNeedUpdate",applistURL,@"applist", nil];
      }
      else
      {
        result = [NSDictionary dictionaryWithObjectsAndKeys:@"NO",@"isNeedUpdate", nil];
      }
      versionInfo(result);
    }
  } failure:^(NSError *err) {
    versionInfo(nil);
  }];
}
-(NSDate *)stringToDate:(NSString *)build
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
  NSDate *date = [dateFormatter dateFromString:build];
  return date;
}

//设置好友备注
- (void)setFriendDisplayName:(NSString *)friendId
                 displayName:(NSString *)displayName
                     complete:(void (^)(BOOL))result {
  [AFHttpTool setFriendDisplayName:friendId
                       displayName:displayName
                           success:^(id response) {
                             if ([response[@"code"] integerValue] == 200) {
                               result(YES);
                             } else {
                               result(NO);
                             }
                           } failure:^(NSError *err) {
                             result(NO);
                           }];
}


@end
