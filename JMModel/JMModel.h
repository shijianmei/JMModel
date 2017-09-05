//
//  JMModel.h
//  JMModelExample
//
//  Created by Jianmei on 2017/9/4.
//  Copyright © 2017年 Jianmei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMModel : NSObject<NSCopying>
- (instancetype)initWithDict:(NSDictionary *)dict;

//convert to dict without NSNull
- (NSDictionary *)propertyDict;

// convert dict array to model array
+ (NSArray<__kindof JMModel *> *)modelArrayWithDictArray:(NSArray<NSDictionary *> *)array;

// convert model array to dict array
+ (NSArray<NSDictionary *> *)dictArrayWithModelArray:(NSArray<__kindof JMModel *> *)array;

// overwrite this method
// if your property names don't match keys in dict
// @{ propertyName : dictKey }
+ (NSDictionary *)keyMapper;

// overwrite this method to tell the class of element in NSArray
// if your property is kind of NSArray
// @{ propertyName : class }
+ (NSDictionary *)arrayMapper;


+ (Class)arrayItemClassMapper:(NSDictionary *)dict;
@end
