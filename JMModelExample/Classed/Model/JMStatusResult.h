//
//  JMStatusResult.h
//  JMModelExample
//
//  Created by Jianmei on 2017/9/4.
//  Copyright © 2017年 Jianmei. All rights reserved.
//

#import "JMModel.h"
#import "JMStatus.h"
#import "JMAd.h"

@interface JMStatusResult : JMModel
/** 存放着某一页微博数据（里面都是Status模型） */
@property (strong, nonatomic) NSMutableArray<JMStatus *> *statuses;
/** 存放着一堆的广告数据（里面都是MJAd模型） */
@property (strong, nonatomic) NSArray<JMAd *> *ads;
/** 总数 */
@property (strong, nonatomic) NSNumber *totalNumber;
/** 上一页的游标 */
@property (assign, nonatomic) long long previousCursor;
/** 下一页的游标 */
@property (assign, nonatomic) long long nextCursor;
@end
