//
//  ViewController.m
//  RunTimeDemo
//
//  Created by kevingao on 16/7/14.
//  Copyright © 2016年 kevingao. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "Person.h"
#import "Person+addProperty.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //设置视图
    [self setUpView];
}

//设置视图
- (void)setUpView{

    //背景颜色
    self.view.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];

    //标题数组
    NSArray* title_array = [NSArray arrayWithObjects:
                            @"1.获取类的成员变量",
                            @"2.获取类的成员属性",
                            @"3.获取类的全部方法",
                            @"4.获取类遵循的全部协议",
                            @"5.动态改变成员变量",
                            @"6.动态交换类方法",
                            @"7.动态添加方法",
                            @"8.动态为Categrory扩展方法",
                            @"9.归档",
                            @"10.字典转Model",
                            @"11.动态生成类，调用方法",
                            nil];
    
    //创建10个按钮
    NSInteger index = 0;
    
    for (index = 0; index < [title_array count]; index++) {
        
        CGRect temp_rect = CGRectMake(30 + (index%2)*160, 60 + (index/2)*80, 150, 40);
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    
        button.tag = index;
        
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        [button setTitle:[title_array objectAtIndex:index] forState:UIControlStateNormal];
        
        button.frame = temp_rect;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
        
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [self.view addSubview:button];
    }
    
}

//按钮点击事件
- (void)buttonClicked:(UIButton*)button{
    
    //标题数组
    NSArray* title_array = [NSArray arrayWithObjects:
                            @"1.获取类的成员变量",
                            @"2.获取类的成员属性",
                            @"3.获取类的全部方法",
                            @"4.获取类遵循的全部协议",
                            @"5.动态改变成员变量",
                            @"6.动态交换类方法",
                            @"7.动态添加方法",
                            @"8.动态为Categrory扩展方法",
                            @"9.归档",
                            @"10.字典转Model",
                            @"11.动态生成类，调用方法",
                            nil];
    
    NSLog(@"%@",[title_array objectAtIndex:button.tag]);
    
    switch (button.tag) {
        case 0: //1.获取类的成员变量
        {
            //成员变量名称
            [self getClassMember];
        }
            break;
        case 1: //2.获取类的成员属性
        {
            //属性
            [self getClassProperty];
        }
            break;
        case 2: //3.获取类的全部方法
        {
            
            [self getClassMethod];
        }
            break;
        case 3: //4.获取类遵循的全部协议
        {
            
            [self getClassProtocol];
        }
            break;
        case 4: //5.动态改变成员变量
        {
            
            [self changeClassMember];
        }
            break;
        case 5: //6.动态交换类方法
        {
            
            [self ClassExchangeMethod];
        }
            break;
        case 6: //7.动态添加方法
        {
         
            [self CategroryAddMethod];
        }
            break;
        case 7: //8.动态为Categrory扩展方法
        {
            
            [self CategroryExtensionProperty];
        }
            break;
        case 8: //9.归档
        {
            
            [self archive];
        }
            break;
        case 9: //10.字典转Model
        {
            
            [self dicToModel];
        }
            break;
        case 10:   //11.动态生成类，调用方法
        {
            [self getDynamic];
        }
            break;
        default:
            break;
    }
}

//1.获得所有属性
- (void)getClassMember{

    unsigned int count = 0;
    
    //获得成员变量数组指针
    Ivar *ivars = class_copyIvarList([Person class], &count);

    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivars[i];
        
        //获得对应ivar的名称
        const char* name = ivar_getName(ivar);
        
        //c字符串转换为oc的字符串
        NSString* key = [NSString stringWithUTF8String:name];
        
        NSLog(@"成员变量名称 %d : %@",i,key);
    }
    
    //如果你的成员私有，也可以获取到 比如_education
    
    //记得释放
    free(ivars);
}

//2.获取类的成员属性
- (void)getClassProperty{

    unsigned int count = 0;
    
    //获得指向该类所有属性的指针
    objc_property_t* propertys = class_copyPropertyList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        //获得该类的一个属性的指针
        objc_property_t temp = propertys[i];
        
        //获得属性名称
        const char* name = property_getName(temp);
        
        //c转化oc字符串
        NSString* key = [NSString stringWithUTF8String:name];
        
        NSLog(@"属性名称 %d : %@",i,key);
    }
    
    //记得释放
    free(propertys);
}

//3.获取类的全部方法
- (void)getClassMethod{

    unsigned int count = 0;
    
    //获取该类的所有方法的数组指针
    Method* methods = class_copyMethodList([Person class], &count);
    
    //遍历
    for (int i = 0; i < count; i++) {
        
        //获得该类的一个方法指针
        Method method = methods[i];
        
        //获得方法
        SEL methodSEL = method_getName(method);
        
        //将方法转化成为c字符串
        const char* name = sel_getName(methodSEL);
        
        //c转化oc字符串
        NSString* methodName = [NSString stringWithUTF8String:name];
        
        //获取方法参数个数
        int arguments = method_getNumberOfArguments(method);
        
        NSLog(@"方法名称 : %@ ,参数个数 : %d",methodName,arguments);
    }

    //释放内存
    free(methods);
}

//4.获取类遵循的全部协议
- (void)getClassProtocol{

    unsigned int count = 0;
    
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([Person class], &count);

    for (int i = 0; i < count; i++) {
        
        //获取该类的一个协议指针
        Protocol* temp_protocol = protocols[i];
        
        //c字符串
        const char* name = protocol_getName(temp_protocol);
        
        //c字符串转oc字符串
        NSString* protocolName = [NSString stringWithUTF8String:name];
        
        NSLog(@"协议名称 : %@",protocolName);
    }
    
    //释放内存
    free(protocols);
}

//5.动态改变成员变量
- (void)changeClassMember{

    //初始化一个对象
    Person* object = [[Person alloc] init];
    object.name = @"张三";
    
    NSLog(@"旧名字 : %@",object.name);
    
    unsigned int count = 0;
    
    //获得成员变量的数组指针
    Ivar *ivar = class_copyIvarList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        
        Ivar var = ivar[i];
        
        //根据ivar获得成员变量名称
        const char* varName = ivar_getName(var);
        
        //c转换成oc字符串
        NSString* name = [NSString stringWithUTF8String:varName];
        
        //当属性变量为name，改变为李四
        if ([name isEqualToString:@"_name"]) {
            //设置变量值
            object_setIvar(object, var, @"李四");
            break;
        }
        
    }
    
    //释放内存
    free(ivar);
    
    //打印新名字
    NSLog(@"新名字 : %@",object.name);
}

//6.动态交换类方法
- (void)ClassExchangeMethod{
    
    //获得对象
    Person* object = [Person new];
    
    NSLog(@"交换之前 student do something:%@",[object doSomeThing]);
    NSLog(@"交换之前 student do doSomeOtherThing:%@",[object doSomeOtherThing]);

    //首先获取Person的2个方法
    Method method_1= class_getInstanceMethod([Person class], @selector(doSomeThing));
    Method method_2 = class_getInstanceMethod([Person class], @selector(doSomeOtherThing));

    //交换方法
    method_exchangeImplementations(method_1, method_2);
    
    NSLog(@"交换之后 student do something:%@",[object doSomeThing]);
    NSLog(@"交换之后 student do doSomeOtherThing:%@",[object doSomeOtherThing]);
    
    //runtime 修改的是类，下次编译前，都是有效的。

    Person *student2 = [Person new];
    
    NSLog(@"运行时改变后student do something:%@",[student2 doSomeThing]);
    NSLog(@"运行时改变后student do doSomeOtherThing:%@",[student2 doSomeOtherThing]);
    
    //类别中替换方法
    [student2 sleep];
}

//7.动态添加方法
- (void)CategroryAddMethod{

    class_addMethod([Person class], @selector(fromCity:), (IMP)fromCityAnswer, "v@:@");

    Person* object = [Person new];
    
    if ([object respondsToSelector:@selector(fromCity:)]) {
        
        [object performSelector:@selector(fromCity:) withObject:@"广州"];
        
    }else{
        
        NSLog(@"无法告诉你我从哪里来");
    }
}

void fromCityAnswer(id self,SEL _cmd,NSString *str){
    
    NSLog(@"我来自:%@",str);
}

- (void)fromCity:(id)sender{



}

//8.动态为Categrory扩展方法
- (void)CategroryExtensionProperty{
    /*
     Category提供了一种比继承（inheritance）更为简洁的方法来对class进行扩展，无需创建对象类的子类就能为现有的类添加新方法，可以为任何已经存在的class添加方法，包括哪些没有源代码的类（如某些框架类）。
     
     类别的局限性
     （1）无法向类中添加新的实例变量，类别没有位置容纳实例变量。
     （2）名称冲突，即当类别中的方法与原生类方法名称冲突时，类别具有更高的优先级。类别方法将完全取代初始方法从而无法再使用初始方法。
     
     */
    //通过runtime 可以让category添加属性
    
    Person* object = [[Person alloc] init];
    
    object.englishName = @"xiaoMu Wang";
    
    NSLog(@"英文名字 is %@",object.englishName);
}

//9.归档
- (void)archive{
    
    //获得对象
    Person *person = [[Person alloc] init];
    person.name = @"JX—boy";
    person.sex = @"男";
    person.age = 25;
    person.height = 170;
    person.job = @"iOS工程师";
    person.native = @"深圳";
    
    //压缩对象
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/archive2",docPath];
    [NSKeyedArchiver archiveRootObject:person toFile:path];
    
    //解压对象
    Person *unarchiverPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"unarchiverPerson == %@ %@",path,unarchiverPerson);
    
    //打印
    unsigned int count = 0;
    
    objc_property_t* properties = class_copyPropertyList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        const char* name = property_getName(property);
        
        NSString* key = [NSString stringWithUTF8String:name];
        
        NSLog(@"%@ : %@",key,[unarchiverPerson valueForKey:key]);
    }
}

//10.字典转换model
- (void)dicToModel{

    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"JX—boy",@"name",
                          @"男",@"sex",
                          @"25",@"age",
                          @"170",@"height",
                          @"iOS工程师",@"job",
                          @"深圳",@"native",
                          nil];

    Person* object = [[Person alloc] initWithDict:dict];

    //打印值
    unsigned int count = 0;
    
    objc_property_t* properties = class_copyPropertyList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = properties[i];
        
        const char* name = property_getName(property);
        
        //c转oc
        NSString* key = [NSString stringWithUTF8String:name];
        
        //打印
        NSLog(@"%@ : %@",key,[object valueForKey:key]);
    }
}

//11.动态生成类，调用方法

- (void)getDynamic{

    //获得类名
    Class temp_obj = NSClassFromString(@"Person");
    
    //获得方法
    SEL method = NSSelectorFromString(@"getPerson");
    
    //获得对象
    id person = objc_msgSend(temp_obj, method);
    
    //打印
    NSLog(@"person : %@",person);
    
    //获得方法名称
    SEL doSomeThing = NSSelectorFromString(@"doSomeThing");
    
    //获得方法返回值
    NSString* result =  objc_msgSend(person,doSomeThing);

    //打印
    NSLog(@"result : %@",result);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
