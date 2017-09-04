//
//  JMStatus.h
//  JMModelExample
//
//  Created by Jianmei on 2017/9/4.
//  Copyright © 2017年 Jianmei. All rights reserved.
//

#import "JMModel.h"
#import "JMUser.h"
@interface JMStatus : JMModel
/** 微博文本内容 */
@property (copy, nonatomic) NSString *text;
/** 微博作者 */
@property (strong, nonatomic) JMUser *user;
/** 转发的微博 */
@property (strong, nonatomic) JMStatus *retweetedStatus;
@end
