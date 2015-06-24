# LVDatabaseDemo
FMDB数据库的使用演示和封装工具类，希望能帮助到用到的朋友，谢谢！
##使用步骤。。。

将FMDB框架及LVFmdbTool拉入项目中，导入头文件,根据需要修改表名《在LVFmdbTool.m》文件中查找models，替换为需要的表明。
```
    #improt "LVFmdbTool.h"
```

## 插入数据
```
    [LVFmdbTool insertModel:model]
```

## 查询数据
```
    [LVFmdbTool queryData:nil]
```

## 删除数据
```
    [LVFmdbTool deleteData:delesql];
```

## 修改数据
```
    [LVFmdbTool modifyData:nil];
```


## 效果图
![](https://github.com/liuchunlao/ImageCache/raw/master/gifResource/LVDatabaseDemo.gif)

## 期待
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢！