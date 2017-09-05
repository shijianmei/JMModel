//
//  JMModel.m
//  JMModelExample
//
//  Created by Jianmei on 2017/9/4.
//  Copyright © 2017年 Jianmei. All rights reserved.
//

#import "JMModel.h"
#import <objc/runtime.h>

#define PropertyNameAttributesKey @"PropertyNameAttributes"

@interface HTPropertyAttributes : JMModel
@property (nonatomic, assign) Class cls;
@end

@implementation HTPropertyAttributes
@end


@implementation JMModel

+ (NSDictionary *)propertyMeta
{
    NSMutableDictionary *propertyMeta = [NSMutableDictionary new];
    
    unsigned count;
    objc_property_t *propertyArray = class_copyPropertyList(self, &count);
    for (int i = 0; i < count; i++) {
        
        HTPropertyAttributes *attribute = [HTPropertyAttributes new];
        unsigned int attrCount;
        objc_property_attribute_t *attrs = property_copyAttributeList(propertyArray[i], &attrCount);
        if (attrs[0].name[0] == 'T' && attrs[0].value[0] == '@') {
            unsigned long len = strlen(attrs[0].value);
            if (len > 3) {
                char className[len - 2];
                className[len - 3] = '\0';
                memcpy(className, attrs[0].value + 2, len - 3);
                attribute.cls = objc_getClass(className);
            }
        }
        free(attrs);
        
        const char *name = property_getName(propertyArray[i]);
        propertyMeta[@(name)] = attribute;
    }
    free(propertyArray);
    
    return [propertyMeta copy];
}

+ (NSDictionary *)propertyNameAttributes
{
   	NSDictionary *dict = objc_getAssociatedObject(self, PropertyNameAttributesKey);
    if (!dict) {
        dict = [self propertyMeta];
        objc_setAssociatedObject(self, PropertyNameAttributesKey, dict, OBJC_ASSOCIATION_COPY);
    }
    NSMutableDictionary *allProperty = [dict mutableCopy];
    if ([[self superclass] isSubclassOfClass:[JMModel class]]) {
        NSDictionary *superProperty = [[self superclass] propertyNameAttributes];
        [allProperty setValuesForKeysWithDictionary:superProperty];
    }
    return [allProperty copy];
}

+ (NSDictionary *)keyMapper
{
    return nil;
}

+ (NSDictionary *)arrayMapper
{
    return nil;
}
+ (Class)arrayItemClassMapper:(NSDictionary *)dict
{
    return self;
}
+ (NSArray<__kindof JMModel *> *)modelArrayWithDictArray:(NSArray<NSDictionary *> *)array
{
    NSMutableArray<JMModel *> *modelArray = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        Class aClass = [self arrayItemClassMapper:dict];
        aClass = aClass ?: self;
        JMModel *model = [[aClass alloc] initWithDict:dict];
        [modelArray addObject:model];
    }
    return [modelArray copy];
}

+ (NSArray<NSDictionary *> *)dictArrayWithModelArray:(NSArray<__kindof JMModel *> *)array
{
    NSMutableArray<NSDictionary *> *dictArray = [NSMutableArray new];
    for (JMModel *model in array) {
        [dictArray addObject:[model propertyDict]];
    }
    return [dictArray copy];
}


#pragma mark - member method
- (instancetype)initWithDict:(NSDictionary *)dict
{
    //if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [self setValuesForKeysWithDictionary:dict];
            NSDictionary *mapper = [[self class] keyMapper];
            for (NSString *propertyName in mapper) {
                NSString *keyPath = mapper[propertyName];
                if ([keyPath componentsSeparatedByString:@"."].count > 1) {
                    [self setValue:[dict valueForKeyPath:keyPath] forKey:propertyName];
                }
            }
        }
    }
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    NSDictionary *mapper = [[self class] keyMapper];
    for (NSString *propertyName in mapper) {
        if ([mapper[propertyName] isEqualToString:key]) {
            key = propertyName;
            break;
        }
    }
    
    NSDictionary *propertyMeta = [[self class] propertyNameAttributes];
    HTPropertyAttributes *attribute = propertyMeta[key];
    
    if ([attribute.cls isSubclassOfClass:[JMModel class]] && [value isKindOfClass:[NSDictionary class]]) {
        
        [self setValue:[[attribute.cls alloc] initWithDict:value] forKey:key];
        
    } else if ([attribute.cls isSubclassOfClass:[NSArray class]] && [value isKindOfClass:[NSArray class]]) {
        
        NSDictionary *mapper = [[self class] arrayMapper];
        Class cls = mapper[key];
        if ([cls isSubclassOfClass:[JMModel class]]) {
            
            NSArray *modelArray = [cls modelArrayWithDictArray:value];
            [super setValue:modelArray forKey:key];
            
        } else {
            if (value)
            {
                [super setValue:value forKey:key];
            }
        }
        
    } else {
        if (!attribute.cls && ![value isKindOfClass:[NSValue class]]) {
            if ([value isKindOfClass:[NSString class]]) {
                value = @([value doubleValue]);
            }
        }
        if (value)
        {
            [super setValue:value forKey:key];
        }
    }
}

- (NSDictionary *)propertyDict
{
    NSDictionary *modelDict = [self dictionaryWithValuesForKeys:[[self class] propertyNameAttributes].allKeys];
    NSMutableDictionary *propertyDict = [NSMutableDictionary new];
    [propertyDict setValuesForKeysWithDictionary:modelDict];   //去除nsnull对象
    
    NSMutableDictionary *mappedDict = [NSMutableDictionary new];
    for (NSString *dictKey in propertyDict.allKeys) {
        NSString *mappedKey = [[self class] keyMapper][dictKey]?:dictKey;
        mappedDict[mappedKey] = propertyDict[dictKey];
    }
    return [mappedDict copy];
}

- (id)valueForKey:(NSString *)key
{
    NSDictionary *propertyMeta = [[self class] propertyNameAttributes];
    HTPropertyAttributes *attribute = propertyMeta[key];
    if ([attribute.cls isSubclassOfClass:[JMModel class]]) {
        return [[super valueForKey:key] propertyDict];
    } else if ([attribute.cls isSubclassOfClass:[NSArray class]]) {
        NSDictionary *mapper = [[self class] arrayMapper];
        Class cls = mapper[key];
        if ([cls isSubclassOfClass:[JMModel class]]) {
            return [cls dictArrayWithModelArray:[super valueForKey:key]];
        } else {
            return [super valueForKey:key];
        }
    } else {
        return [super valueForKey:key];
    }
}

- (NSString *)readableString
{
    NSArray *propertyNameArray = [[self class] propertyNameAttributes].allKeys;
    
    NSMutableString *content = [NSMutableString stringWithFormat:@"%@:\n", [self class]];
    for (NSString *propertyName in propertyNameArray) {
        
        NSObject *value = [self valueForKey:propertyName];
        if ([value isKindOfClass:[NSString class]]) {
            value = [NSString stringWithFormat:@"\"%@\"", value];
        }
        NSString *keyValue = [NSString stringWithFormat:@"%@ = %@", propertyName, value];
        
        NSArray *array = [keyValue componentsSeparatedByString:@"\n"];
        NSMutableArray *mutableArray = [NSMutableArray new];
        for (NSString *str in array) {
            NSString *lineString = [@"\t" stringByAppendingString:str];
            [mutableArray addObject:lineString];
        }
        keyValue = [mutableArray componentsJoinedByString:@"\n"];
        
        if (propertyNameArray.lastObject == propertyName) {   //not thread safe
            [content appendFormat:@"%@\n", keyValue];
        } else {
            [content appendFormat:@"%@,\n", keyValue];
        }
    }
    return [content copy];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //NSLog(@"undefinedKey %@, value %@", key, value);
}

- (NSString *)description
{
    return [self readableString];
}

- (NSString *)debugDescription
{
    return [self readableString];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithDict:[self propertyDict]];
}
@end
