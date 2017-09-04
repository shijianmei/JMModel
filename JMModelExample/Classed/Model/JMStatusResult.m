//
//  JMStatusResult.m
//  JMModelExample
//
//  Created by Jianmei on 2017/9/4.
//  Copyright © 2017年 Jianmei. All rights reserved.
//

#import "JMStatusResult.h"

@implementation JMStatusResult

+ (NSDictionary *)arrayMapper {
    return @{
             @"ads" : [JMAd class],
             @"statuses":[JMStatus class]
             };
}
@end
