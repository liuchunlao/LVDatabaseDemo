//
//  LVModal.m
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "LVModal.h"

@implementation LVModal

+ (instancetype)modalWith:(NSString *)name age:(NSInteger)age no:(NSInteger)ID_No {
    LVModal *modal = [[LVModal alloc] init];
    modal.name = name;
    modal.age = age;
    modal.ID_No = ID_No;
    return modal;
}

@end
