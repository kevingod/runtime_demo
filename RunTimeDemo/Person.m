//
//  Person.m
//  RunTimeDemo
//
//  Created by kevingao on 16/7/18.
//  Copyright © 2016年 kevingao. All rights reserved.
//

#import "Person.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation Person

-(void)eat
{
    NSLog(@"吃饭");
}
-(void)sleep
{
    NSLog(@"睡觉");
}
-(NSString *)doSomeThing
{
    return @"我要去爬山";
}
-(NSString *)doSomeOtherThing
{
    return @"我要去唱歌";
}

+ (instancetype)getPerson{

    Person* obj = [[Person alloc] init];
    
    return obj;
}

//准守<NSCoding>协议，实现以下2个方法
- (void)encodeWithCoder:(NSCoder *)encoder{

    unsigned int count = 0;

    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([Person class], &count);

    for (int i = 0; i < count; i++) {
        
        //获得属性
        objc_property_t property = properties[i];
        
        //c字符
        const char *name = property_getName(property);
        
        //c转oc字符串
        NSString* key = [NSString stringWithUTF8String:name];
        
        //编码每个属性
        [encoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    //归档存储
    unsigned int count = 0;

    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([Person class], &count);

    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        const char* name = property_getName(property);
        
        NSString* key = [NSString stringWithUTF8String:name];
        
        //解码
        [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
    }
    
    return self;
}

//初始化方法
- (id)initWithDict:(NSDictionary*)dict{

    self = [super init];
    if (self) {
        
        unsigned int count = 0;
        
        objc_property_t *properties = class_copyPropertyList([Person class], &count);

        for (int i = 0; i < count; i++) {
            
            objc_property_t property = properties[i];
            
            const char* name = property_getName(property);
            
            NSString* key = [NSString stringWithUTF8String:name];
            
            [self setValue:[dict objectForKey:key] forKey:key];
        }
    }
    
    return self;
}

@end
