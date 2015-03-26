//
//  LVModal.h
//  LVDatabaseDemo
//
//  Created by 刘春牢 on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LVModal : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger ID_No;


+ (instancetype)modalWith:(NSString *)name age:(NSInteger)age no:(NSInteger)ID_No;

@end
