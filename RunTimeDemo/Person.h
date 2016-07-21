//
//  Person.h
//  RunTimeDemo
//
//  Created by kevingao on 16/7/18.
//  Copyright © 2016年 kevingao. All rights reserved.
//

#import <Foundation/Foundation.h>

//代理方法

@protocol personPlayDelegate <NSObject>

-(void)giveMeBall:(NSString *)ball;

@end

//个人基类

@interface Person : NSObject <NSCoding>

@property(nonatomic,assign)id<personPlayDelegate> delegate;

@property(nonatomic,copy)NSString *name;            //名字
@property(nonatomic,copy)NSString *sex;             //性别
@property(nonatomic,assign)NSInteger age;           //年龄
@property(nonatomic,assign)float height;            //身高
@property(nonatomic,copy)NSString *job;             //工作
@property(nonatomic,copy)NSString *native;          //本地人-地点

-(void)eat;                                         //吃饭
-(void)sleep;                                       //睡觉

-(NSString *)doSomeThing;                           //做些事情
-(NSString *)doSomeOtherThing;                      //做些其他事情

+ (instancetype)getPerson;                          //获得一个对象

//初始化方法
- (id)initWithDict:(NSDictionary*)dict;

@end

