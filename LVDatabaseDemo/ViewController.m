//
//  ViewController.m
//  LVDatabaseDemo
//
//  Created by PBOC CS on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"


#define LVSQLITE_NAME @"modals.sqlite"


@interface ViewController ()

/** 姓名 */
@property (weak, nonatomic) IBOutlet UITextField *nameField;

/** 年龄 */
@property (weak, nonatomic) IBOutlet UITextField *ageField;

/** 身份证号码 */
@property (weak, nonatomic) IBOutlet UITextField *idField;

/** 插入数据按钮 */
@property (weak, nonatomic) IBOutlet UIButton *insertBtn;

/** 查询数据按钮 */
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;

/** 删除数据按钮 */
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

/** 修改数据按钮 */
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;

- (IBAction)insertBtnDidClick:(UIButton *)sender;

- (IBAction)queryBtnDidClick:(UIButton *)sender;

- (IBAction)deleteBtnDidClick:(UIButton *)sender;

- (IBAction)updateBtnDidClick:(UIButton *)sender;


@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 调整按钮风格
    [self setupControl:@[self.insertBtn, self.queryBtn, self.deleteBtn, self.updateBtn]];
    
    // 创建数据库
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:LVSQLITE_NAME];
    self.fmdb = [FMDatabase databaseWithPath:filePath];
    
    // 打开数据库
    [self.fmdb open];
    
#warning 必须先打开数据库才能创建表。。。否则提示数据库没有打开
    
    // 创建表
    [self.fmdb executeUpdate:@"CREATE TABLE IF NOT EXISTS t_modals(id INTEGER PRIMARY KEY, name TEXT NOT NULL, age INTEGER NOT NULL, ID_No INTEGER NOT NULL);"];
}

- (void)setupControl:(NSArray *)array {
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton *)obj;
        btn.layer.cornerRadius = 7;
    }];
}

- (IBAction)insertBtnDidClick:(UIButton *)sender {
    
    if (self.nameField.text.length == 0 || self.ageField.text.length == 0 || self.idField.text.length == 0)     return;
    
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO t_modals(name, age, ID_No) VALUES ('%@', '%d', '%d');", self.nameField.text, self.ageField.text.intValue , self.idField.text.intValue];
    
    [self.fmdb executeUpdate:insertSql];
}

- (IBAction)queryBtnDidClick:(UIButton *)sender {
    NSLog(@"查询数据");
    
    NSString *querySql = @"SELECT * FROM t_modals;";
    FMResultSet *set = [self.fmdb executeQuery:querySql];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSString *age = [set stringForColumn:@"age"];
        NSString *ID_No = [set stringForColumn:@"ID_No"];
        NSLog(@"%@   %@   %@", name, age, ID_No);
    }
    
}
- (IBAction)deleteBtnDidClick:(UIButton *)sender {
    NSLog(@"删除数据");
    
    NSString *deleteSql = @"DELETE FROM t_modals WHERE name = 'www'";
    
    [self.fmdb executeUpdate:deleteSql];
}

- (IBAction)updateBtnDidClick:(UIButton *)sender {
    NSLog(@"修改数据");
    
    NSString *updataSql = @"UPDATE t_modals SET age = '100' WHERE name = 'ww'";
    
    [self.fmdb executeUpdate:updataSql];
}
@end
