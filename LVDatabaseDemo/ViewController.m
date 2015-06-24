//
//  ViewController.m
//  LVDatabaseDemo
//
//  Created by PBOC CS on 15/3/26.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import "ViewController.h"
#import "LVModel.h"

#import "LVFmdbTool.h"


#define LVSQLITE_NAME @"modals.sqlite"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

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
    
    // 模糊查询
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

#pragma mark - 模糊查询功能演示
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    [self.modalsArrM removeAllObjects];
    
    NSString *fuzzyQuerySql = [NSString stringWithFormat:@"SELECT * FROM t_modals WHERE name LIKE '%%%@%%' OR ID_No LIKE '%%%@%%'", searchText, searchText];
    NSArray *modals = [LVFmdbTool queryData:fuzzyQuerySql];
    
    [self.modalsArrM addObjectsFromArray:modals];
    
    [self.tableView reloadData];
}



- (void)setupControl:(NSArray *)array {
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = (UIButton *)obj;
        btn.layer.cornerRadius = 7;
    }];
}

- (IBAction)insertBtnDidClick:(UIButton *)sender {
    
    if (self.nameField.text.length == 0 || self.ageField.text.length == 0 || self.idField.text.length == 0)     return;
    
    LVModel *model = [LVModel modalWith:self.nameField.text age:self.ageField.text.intValue no:self.idField.text.intValue];
    
    BOOL isInsert = [LVFmdbTool insertModel:model];
    
    if (isInsert) {
        
        [self.modalsArrM addObject:model];
        [self.tableView reloadData];
        
    } else {
        NSLog(@"插入数据失败");
    }
}

- (IBAction)queryBtnDidClick:(UIButton *)sender {
    
    [self.modalsArrM removeAllObjects];
    
    NSArray *modals = [LVFmdbTool queryData:nil];
    [self.modalsArrM addObjectsFromArray:modals];
    
    [self.tableView reloadData];
    
}
- (IBAction)deleteBtnDidClick:(UIButton *)sender {

    NSString *delesql = @"DELETE FROM t_modals WHERE name = 'zhangsan'";
    [LVFmdbTool deleteData:delesql];
    
#warning 删除数据后执行一次查询工作刷新表格
    [self queryBtnDidClick:nil];
}

- (IBAction)updateBtnDidClick:(UIButton *)sender {
    
    [LVFmdbTool modifyData:nil];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    
    LVModel *model = self.modalsArrM[indexPath.row];
    cell.textLabel.text = model.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%zd", model.ID_No];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

@end
