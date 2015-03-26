//
//  ViewController.m
//  LVDatabaseDemo
//
//  Created by PBOC CS on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"
#import "LVModal.h"


#define LVSQLITE_NAME @"modals.sqlite"


@interface ViewController () <UITableViewDataSource>

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

/** 显示数据 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *modalsArrM;

- (IBAction)insertBtnDidClick:(UIButton *)sender;

- (IBAction)queryBtnDidClick:(UIButton *)sender;

- (IBAction)deleteBtnDidClick:(UIButton *)sender;

- (IBAction)updateBtnDidClick:(UIButton *)sender;


@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation ViewController

- (NSMutableArray *)modalsArrM {
    if (!_modalsArrM) {
        _modalsArrM = [[NSMutableArray alloc] init];
    }
    return _modalsArrM;
}


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
    
    BOOL isInsert = [self.fmdb executeUpdate:insertSql];
    
    if (isInsert) {
        
        LVModal *modal = [LVModal modalWith:self.nameField.text age:self.ageField.text.intValue no:self.idField.text.intValue];

        [self.modalsArrM addObject:modal];
        [self.tableView reloadData];
    } else {
        NSLog(@"插入数据失败");
    }
    
    
}

- (IBAction)queryBtnDidClick:(UIButton *)sender {
    
    [self.modalsArrM removeAllObjects];
    
    NSString *querySql = @"SELECT * FROM t_modals;";
    FMResultSet *set = [self.fmdb executeQuery:querySql];
    while ([set next]) {
        NSString *name = [set stringForColumn:@"name"];
        NSString *age = [set stringForColumn:@"age"];
        NSString *ID_No = [set stringForColumn:@"ID_No"];
        NSLog(@"%@   %@   %@", name, age, ID_No);
        
        LVModal *modal = [LVModal modalWith:name age:age.intValue no:ID_No.intValue];
        [self.modalsArrM addObject:modal];
    }
    [self.tableView reloadData];
    
}
- (IBAction)deleteBtnDidClick:(UIButton *)sender {
    NSLog(@"删除数据");
    
    NSString *deleteSql = @"DELETE FROM t_modals WHERE name = 'zhangsan'";
    
    [self.fmdb executeUpdate:deleteSql];
    
#warning 删除数据后执行一次查询工作刷新表格
    [self queryBtnDidClick:nil];
}

- (IBAction)updateBtnDidClick:(UIButton *)sender {
    NSLog(@"修改数据");
    
    NSString *updataSql = @"UPDATE t_modals SET ID_No = '789789' WHERE name = 'lisi'";
    
    [self.fmdb executeUpdate:updataSql];
#warning 删除数据后执行一次查询工作刷新表格
    [self queryBtnDidClick:nil];
}


#pragma mark - UITableViewDataSource 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modalsArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    LVModal *modal = self.modalsArrM[indexPath.row];
    cell.textLabel.text = modal.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", modal.ID_No];
    return cell;

}
@end
