//
//  LVModal.m
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVModel.h"

@implementation LVModel

+ (instancetype)modalWith:(NSString *)name age:(NSInteger)age no:(NSInteger)ID_No {
    LVModel *model = [[self alloc] init];
    model.name = name;
    model.age = age;
    model.ID_No = ID_No;
    return model;
}

@end
