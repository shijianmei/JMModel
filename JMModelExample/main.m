//
//  main.m
//  JMModelExample
//
//  Created by Jianmei on 2017/9/4.
//  Copyright © 2017年 Jianmei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "main.h"
#import "JMUser.h"
#import "JMStatus.h"
#import "JMStatusResult.h"
#import "JMStudent.h"

int main(int argc, char * argv[]) {
    
    /**
     1.JMModel是一套“字典和模型之间互相转换”的轻量级框架
     2.JMModel能完成的功能
     * 字典 --> 模型
     * 模型 --> 字典
     * 字典数组 --> 模型数组
     * 模型数组 --> 字典数组
     * 一行打印模型属性
     * 一行模型深拷贝
     3.具体用法主要参考 main.m中各个函数
     */
    @autoreleasepool {
//        execute(keyValues2object, @"简单的字典 -> 模型");
//        execute(keyValues2object2, @"复杂的字典 -> 模型");
//        execute(keyValues2object3, @"复杂的字典 -> 模型 (模型的数组属性里面又装着模型)");
        execute(keyValues2object4, @"简单的字典 -> 模型（key替换，比如ID和id，支持多级映射）");
//        execute(keyValuesArray2objectArray, @"字典数组 -> 模型数组");
//        execute(object2keyValues, @"模型转字典");
//        execute(objectArray2keyValuesArray, @"模型数组 -> 字典数组");

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}



/**
 *  简单的字典 -> 模型
 */
void keyValues2object()
{
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"name" : @"Jack",
                           @"icon" : @"lufy.png",
                           @"age" : @"20",
                           @"height" : @1.55,
                           @"money" : @"100.9",
                           @"sex" : @(SexFemale),
                           @"gay" : @"1",
//                             @"gay" : @"NO"
                           //  @"gay" : @"true"
                           };
    
    // 2.将字典转为JMUser模型
    JMUser *user = [[JMUser alloc]initWithDict:dict];
    
    // 3.打印JMUser模型的属性
    NSLog(@"%@",user);

}

/**
 *  复杂的字典 -> 模型 (模型里面包含了模型)
 */
void keyValues2object2()
{
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"text" : @"是啊，今天天气确实不错！",
                           
                           @"user" : @{
                                   @"name" : @"Jack",
                                   @"icon" : @"lufy.png"
                                   },
                           
                           @"retweetedStatus" : @{
                                   @"text" : @"今天天气真不错！",
                                   
                                   @"user" : @{
                                           @"name" : @"Rose",
                                           @"icon" : @"nami.png"
                                           }
                                   }
                           };
    
    // 2.将字典转为Status模型
    JMStatus *status = [[JMStatus alloc]initWithDict:dict];
    
    // 3.打印status的属性
    NSLog(@"%@", status);
    
  }

/**
 *  复杂的字典 -> 模型 (模型的数组属性里面又装着模型)
 */
void keyValues2object3()
{
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"statuses" : @[
                                   @{
                                       @"text" : @"今天天气真不错！",
                                       
                                       @"user" : @{
                                               @"name" : @"Rose",
                                               @"icon" : @"nami.png"
                                               }
                                       },
                                   
                                   @{
                                       @"text" : @"明天去旅游了",
                                       
                                       @"user" : @{
                                               @"name" : @"Jack",
                                               @"icon" : @"lufy.png"
                                               }
                                       }
                                   
                                   ],
                           
                           @"ads" : @[
                                   @{
                                       @"image" : @"ad01.png",
                                       @"url" : @"http://www.小码哥ad01.com"
                                       },
                                   @{
                                       @"image" : @"ad02.png",
                                       @"url" : @"http://www.小码哥ad02.com"
                                       }
                                   ],
                           
                           @"totalNumber" : @"2014",
                           @"previousCursor" : @"13476589",
                           @"nextCursor" : @"13476599"
                           };
    
    // 2.将字典转为JMStatusResult模型
    JMStatusResult *result = [[JMStatusResult alloc ]initWithDict:dict];
    
    // 3.打印JMStatusResult模型的简单属性
    NSLog(@"%@",result);
}

/**
 * 简单的字典 -> 模型（key替换，比如ID和id。多级映射，比如 oldName 和 name.oldName）
 */
void keyValues2object4()
{
    // 1.定义一个字典
    NSDictionary *dict = @{
                           @"id" : @"20",
                           @"desciption" : @"好孩子",
                           @"name" : @{
                                   @"newName" : @"lufy",
                                   @"oldName" : @"kitty",
                                   @"info" : @[
                                           @"test-data",
                                           @{@"nameChangedTime" : @"2013-08-07"}
                                           ]
                                   },
                           @"other" : @{
                                   @"bag" : @{
                                           @"name" : @"小书包",
                                           @"price" : @100.7
                                           }
                                   }
                           };
    
    // 2.将字典转为JMStudent模型
    JMStudent *stu = [[JMStudent alloc ]initWithDict:dict];
    
    // 3.打印JMStudent模型的属性
    NSLog(@"%@",stu);
//        CFTimeInterval begin = CFAbsoluteTimeGetCurrent();
//        for (int i = 0; i< 10000; i++) {
//            [[JMStudent alloc ]initWithDict:dict];
//        }
//        CFTimeInterval end = CFAbsoluteTimeGetCurrent();
//        NSLog(@"%f", end - begin);
}

/**
 *  字典数组 -> 模型数组
 */
void keyValuesArray2objectArray()
{
    // 1.定义一个字典数组
    NSArray *dictArray = @[
                           @{
                               @"name" : @"Jack",
                               @"icon" : @"lufy.png",
                               },
                           
                           @{
                               @"name" : @"Rose",
                               @"icon" : @"nami.png",
                               }
                           ];
    
    // 2.将字典数组转为JMUser模型数组
    NSArray *userArray = [JMUser modelArrayWithDictArray:dictArray];
    
    // 3.打印userArray数组中的JMUser模型属性
    for (JMUser *user in userArray) {
        NSLog(@"%@", user);
    }
}

/**
 *  模型 -> 字典
 */
void object2keyValues()
{
    // 1.新建模型
    JMUser *user = [[JMUser alloc] init];
    user.name = @"Jack";
    user.icon = @"lufy.png";
    
    JMStatus *status = [[JMStatus alloc] init];
    status.user = user;
    status.text = @"今天的心情不错！";
    
    // 2.将模型转为字典
    NSDictionary *statusDict = status.propertyDict;
    NSLog(@"%@", statusDict);
    NSLog(@"copy 后:%@", user );
    
    // 3.新建多级映射的模型
    JMStudent *stu = [[JMStudent alloc] init];
    stu.ID = @"123";
    stu.oldName = @"rose";
    stu.nowName = @"jack";
    stu.desc = @"handsome";
    stu.nameChangedTime = @"2018-09-08";
    stu.books = @[@"Good book", @"Red book"];
    
    JMBag *bag = [[JMBag alloc] init];
    bag.name = @"小书包";
    bag.price = 205;
    stu.bag = bag;
    
    NSDictionary *stuDict = stu.propertyDict;
    NSLog(@"%@", stuDict);

    }

/**
 *  模型数组 -> 字典数组
 */
void objectArray2keyValuesArray()
{
    // 1.新建模型数组
    JMUser *user1 = [[JMUser alloc] init];
    user1.name = @"Jack";
    user1.icon = @"lufy.png";
    
    JMUser *user2 = [[JMUser alloc] init];
    user2.name = @"Rose";
    user2.icon = @"nami.png";
    
    NSArray *userArray = @[user1, user2];
    
    // 2.将模型数组转为字典数组
    NSArray *dictArray = [JMUser dictArrayWithModelArray:userArray];
    NSLog(@"%@", dictArray);
}

void execute(void (*fn)(), NSString *comment)
{
    fn();

}
