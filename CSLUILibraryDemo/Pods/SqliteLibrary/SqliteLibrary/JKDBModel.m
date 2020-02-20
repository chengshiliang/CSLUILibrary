//
//  JKBaseModel.m
//  JKBaseModel
//
//  Created by zx_04 on 15/6/27.
//  Copyright (c) 2015年 joker. All rights reserved.
//

#import "JKDBModel.h"
#import "JKDBHelper.h"

#import <objc/runtime.h>
@interface JKDBModel()
@end

@implementation JKDBModel

#pragma mark - override method
+ (void)initialize
{
    if (self != [JKDBModel self]) {
        [self createTable];
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [self.class getAllProperties];
        _columeNames = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"name"]];
        _columeTypes = [[NSMutableArray alloc] initWithArray:[dic objectForKey:@"type"]];
    }
    
    return self;
}

+ (NSSet *)bolbset{
    return [NSSet setWithObjects:@"NSData",@"NSMutableData",@"NSArray",@"NSMutableArray",@"NSDictionary",@"NSMutableDictionary", nil];
}

+ (NSSet *)textset{
    return [NSSet setWithObjects:@"NSString",@"NSMutableString",@"NSDate", nil];
}
#pragma mark 数据库中是否存在表
+ (BOOL)isExistInTable
{
    __block BOOL res = NO;
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
         res = [db tableExists:tableName];
    }];
    return res;
}
#pragma mark 获取数据库中的字段名
+ (NSArray *)getColumns
{
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *columns = [NSMutableArray array];
     [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
         NSString *tableName = NSStringFromClass(self.class);
         FMResultSet *resultSet = [db getTableSchema:tableName];
         while ([resultSet next]) {
             NSString *column = [resultSet stringForColumn:@"name"];
             [columns addObject:column];
         }
     }];
    return [columns copy];
}

#pragma mark 创建表
+ (BOOL)createTable
{
    FMDatabase *db = [FMDatabase databaseWithPath:[JKDBHelper dbPath]];
    if (![db open]) {
        NSLog(@"数据库打开失败!");
        return NO;
    }
    
    NSString *tableName = NSStringFromClass(self.class);
    NSString *columeAndType = [self.class getColumeAndTypeString];
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@);",tableName,columeAndType];
    if (![db executeUpdate:sql]) {
        return NO;
    }
    
    NSArray *columns = [self.class getColumns];
    NSDictionary *dict = [self.class getAllProperties];
    NSArray *properties = [dict objectForKey:@"name"];
    NSPredicate *filterPredicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",columns];
    //过滤数组
    NSArray *resultArray = [properties filteredArrayUsingPredicate:filterPredicate];

    for (NSString *column in resultArray) {
        NSUInteger index = [properties indexOfObject:column];
        NSString *proType = [self.class getSqliteTypeFromProType:[[dict objectForKey:@"type"] objectAtIndex:index]];
        NSString *fieldSql = [NSString stringWithFormat:@"%@ %@",column,proType];
        NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ ",tableName,fieldSql];
        if (![db executeUpdate:sql]) {
            return NO;
        }
    }
    [db close];
    return YES;
}

- (BOOL)saveOrUpdate
{
    id primaryValue = [self valueForKey:primaryId];
    if ([primaryValue intValue] <= 0) {
        return [self save];
    }
    
    return [self updateObject];
}
#pragma mark save
- (BOOL)save
{
    NSString *tableName = NSStringFromClass(self.class);
    NSMutableString *keyString = [NSMutableString string];
    NSMutableString *valueString = [NSMutableString string];
    NSMutableArray *insertValues = [NSMutableArray  array];
    for (int i = 0; i < self.columeNames.count; i++) {
        NSString *proname = [self.columeNames objectAtIndex:i];
        if ([proname isEqualToString:primaryId]) {
            continue;
        }
        [keyString appendFormat:@"%@,", proname];
        [valueString appendString:@"?,"];
        id value = [self valueForKey:proname]?[self valueForKey:proname]:@"";
        if ([self valueIsKindOfSet:value]) {
            BOOL isJKDBModel = NO;
            NSMutableArray *arrM = [NSMutableArray array];
            for (id newValue in value) {
                if ([newValue isKindOfClass:[JKDBModel class]]) {
                    [newValue save];
                    isJKDBModel = YES;
                    [arrM addObject:[JKDBModel dictWithModel:newValue]];
                }
            }
            if (!isJKDBModel) {
                value = [NSKeyedArchiver archivedDataWithRootObject:value];
            } else {
                value = [NSJSONSerialization dataWithJSONObject:arrM options:NSJSONWritingPrettyPrinted error:NULL];
            }
        } else if ([value isKindOfClass:[JKDBModel class]]) {
            [value save];
            value = [NSJSONSerialization dataWithJSONObject:[JKDBModel dictWithModel:value] options:NSJSONWritingPrettyPrinted error:NULL];
        }
        [insertValues addObject:value];
    }
    
    [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
    [valueString deleteCharactersInRange:NSMakeRange(valueString.length - 1, 1)];
    
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@(%@) VALUES (%@);", tableName, keyString, valueString];
        res = [db executeUpdate:sql withArgumentsInArray:insertValues];
        self.pk = res?[NSNumber numberWithLongLong:db.lastInsertRowId].intValue:0;
        NSLog(res?@"插入成功":@"插入失败");
    }];
    return res;
}

/** 批量保存用户对象 */
+ (BOOL)saveObjects:(NSArray *)array
{
    //判断是否是JKBaseModel的子类
    for (JKDBModel *model in array) {
        if (![model isKindOfClass:[JKDBModel class]]) {
            return NO;
        }
    }
    __block BOOL res = YES;
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    // 如果要支持事务
    [jkDB.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (JKDBModel *model in array) {
            BOOL flag = [model save];
            if (!flag) {
                res = NO;
                *rollback = YES;
                return;
            }
        }
    }];
    return res;
}

#pragma mark update
//重新对主键排序
- (BOOL)reupdate{
    __block BOOL res = NO;
    int i = 0;
    
    for (JKDBModel *model in [self.class findAllModel]) {
        i++;
        JKDBHelper *jkDB = [JKDBHelper shareInstance];
        [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
            NSString *tableName = NSStringFromClass(model.class);
            id primaryValue = [model valueForKey:primaryId];
            if (!primaryValue || primaryValue <= 0) {
                return;
            }
            NSMutableString *keyString = [NSMutableString string];
            NSMutableArray *updateValues = [NSMutableArray  array];
            id value = @(i);
            [keyString appendFormat:@" %@=?,", primaryId];
            [updateValues addObject:value];
            
            //删除最后那个逗号
            [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
            NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryId];
            [updateValues addObject:primaryValue];
            res = [db executeUpdate:sql withArgumentsInArray:updateValues];
            NSLog(res?@"更新成功":@"更新失败");
        }];
    }
    return res;
}

- (BOOL)updateObject
{
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSMutableString *keyString = [NSMutableString string];
        NSMutableArray *updateValues = [NSMutableArray  array];
        for (int i = 0; i < self.columeNames.count; i++) {
            NSString *proname = [self.columeNames objectAtIndex:i];
            if ([proname isEqualToString:primaryId]) {
                continue;
            }
            
            id value = [self valueForKey:proname];
            if (!value) {
                continue;
            }
            [keyString appendFormat:@" %@=?,", proname];
            if ([self valueIsKindOfSet:value]) {
                BOOL isJKDBModel = NO;
                NSMutableArray *arrM = [NSMutableArray array];
                for (id newValue in value) {
                    if ([newValue isKindOfClass:[JKDBModel class]]) {
                        [newValue updateObject];
                        isJKDBModel = YES;
                        [arrM addObject:[JKDBModel dictWithModel:newValue]];
                    }
                }
                if (!isJKDBModel) {
                    value = [NSKeyedArchiver archivedDataWithRootObject:value];
                } else {
                    value = [NSJSONSerialization dataWithJSONObject:arrM options:NSJSONWritingPrettyPrinted error:NULL];
                }
            } else if ([value isKindOfClass:[JKDBModel class]]) {
                [value updateObject];
                value = [NSJSONSerialization dataWithJSONObject:[JKDBModel dictWithModel:value] options:NSJSONWritingPrettyPrinted error:NULL];
            }
            [updateValues addObject:value];
        }
        
        //删除最后那个逗号
        [keyString deleteCharactersInRange:NSMakeRange(keyString.length - 1, 1)];
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET %@ WHERE %@ = ?;", tableName, keyString, primaryId];
        [updateValues addObject:primaryValue];
        res = [db executeUpdate:sql withArgumentsInArray:updateValues];
        NSLog(res?@"更新成功":@"更新失败");
    }];
    return res;
}
+ (BOOL)updateObjects:(NSArray *)array
{
    for (JKDBModel *model in array) {
        if (![model isKindOfClass:[JKDBModel class]]) {
            return NO;
        }
    }
    BOOL res = NO;
    for (JKDBModel *model in array) {
        res = [model updateObject];
    }
    
    return res;
}

#pragma mark delete
- (BOOL)deleteObject
{
    return [self deleteObjectsByCriteria:[NSString stringWithFormat:@" WHERE %@ = ?",primaryId]];
}

+ (BOOL)deleteObjects:(NSArray *)array
{
    for (JKDBModel *model in array) {
        if (![model isKindOfClass:[JKDBModel class]]) {
            return NO;
        }
    }
    BOOL res = NO;
    for (JKDBModel *model in array) {
        res = [model deleteObjectsByCriteria:[NSString stringWithFormat:@" WHERE %@ = ?",primaryId]];
    }
    return res;
}

- (BOOL)deleteObjectsByCriteria:(NSString *)criteria
{
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    __block BOOL res = NO;
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        id primaryValue = [self valueForKey:primaryId];
        if (!primaryValue || primaryValue <= 0) {
            return ;
        }
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ %@ ",tableName,criteria];
        res = [db executeUpdate:sql withArgumentsInArray:criteria.length>0?@[primaryValue]:nil];
        NSLog(res?@"删除成功":@"删除失败");
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self reupdate];
    });
    return res;
}

/** 清空表 */
+ (BOOL)clearTable
{
    return [[[self.class alloc]init] deleteObjectsByCriteria:@""];
}
#pragma mark find
/** 查询全部数据 */
+ (NSArray *)findAll{
    return [self findByCriteria:@""];
}

/** 查找某条数据 */
+ (instancetype)findFirstByCriteria:(NSString *)criteria
{
    NSArray *results = [self.class findByCriteria:criteria];
    if (results.count < 1) {
        return nil;
    }
    
    return [results firstObject];
}

+ (instancetype)findByPK:(int)inPk
{
    NSString *condition = [NSString stringWithFormat:@"WHERE %@=%d",primaryId,inPk];
    return [self.class findFirstByCriteria:condition];
}

/** 通过条件查找数据 */
+ (NSArray *)findByCriteria:(NSString *)criteria
{
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@ %@",tableName,criteria];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JKDBModel *model = [[self.class alloc] init];
            model = [self.class getModelFromModel:model resultSet:resultSet];
            [users addObject:model];
            FMDBRelease(model);
        }
    }];
    return users;
}
+ (NSArray *)findAllModel{
    JKDBHelper *jkDB = [JKDBHelper shareInstance];
    NSMutableArray *users = [NSMutableArray array];
    [jkDB.dbQueue inDatabase:^(FMDatabase *db) {
        NSString *tableName = NSStringFromClass(self.class);
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
        FMResultSet *resultSet = [db executeQuery:sql];
        while ([resultSet next]) {
            JKDBModel *model = [[self.class alloc] init];
            NSString *columeName = primaryId;
            [model setValue:[NSNumber numberWithLong:[resultSet intForColumn:columeName]] forKey:columeName];
            [users addObject:model];
        }
    }];
    return users;
}
#pragma mark - util method
+ (JKDBModel *)getModelFromModel:(JKDBModel *)model resultSet:(FMResultSet *)resultSet{
    for (int i=0; i< model.columeNames.count; i++) {
        NSString *columeName = [model.columeNames objectAtIndex:i];
        NSString *columeType = [model.columeTypes objectAtIndex:i];
        NSString *sqliteType = [self.class getSqliteTypeFromProType:columeType];
        if ([columeType isEqualToString:[NSString stringWithFormat:@"%@ %@",SQLINTEGER,PrimaryKey]]) {
            [model setValue:[NSNumber numberWithLong:[resultSet intForColumn:columeName]] forKey:columeName];
            continue;
        }
        if ([sqliteType isEqualToString:SQLTEXT]) {
            [model setValue:[resultSet stringForColumn:columeName] forKey:columeName];
        } else if ([sqliteType isEqualToString:SQLREAL]) {
            [model setValue:[NSNumber numberWithDouble:[resultSet doubleForColumn:columeName]] forKey:columeName];
        } else if ([sqliteType isEqualToString:SQLINTEGER]) {
            [model setValue:[NSNumber numberWithLong:[resultSet longForColumn:columeName]] forKey:columeName];
        } else if ([sqliteType isEqualToString:SQLBLOB]) {
            NSRange range = [columeType rangeOfString:@"\""];
            if (range.location!=NSNotFound) {
                columeType = [columeType substringFromIndex:range.location+range.length];
                range = [columeType rangeOfString:@"\""];
                columeType = [columeType substringToIndex:range.location];
                Class class = NSClassFromString(columeType);
                NSData *data = [resultSet dataForColumn:columeName];
                if ([class isSubclassOfClass:[NSData class]]) {
                    [model setValue:data forKey:columeName];
                } else if ([[[self alloc]init]classIsSubOfSetClass:class]){
                    
                    NSDictionary *dict = [self.class arrayOfModelName];
                    if (dict[columeName]) {
                        Class classModel = NSClassFromString(dict[columeName]);
                        NSMutableArray *arrM = [NSMutableArray array];
                        NSArray *value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                        for (NSDictionary *dictValue in value) {
                            JKDBModel *subModel = [classModel.class modelWithDict:dictValue];
                            [arrM addObject:subModel];
                        }
                        [model setValue:arrM forKey:columeName];
                    } else {
                        id value = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        [model setValue:value forKey:columeName];
                    }
                } else if ([class isSubclassOfClass:[JKDBModel class]]) {
                    NSDictionary *value = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
                    JKDBModel *subModel = [class.class modelWithDict:value];
                    [model setValue:subModel forKey:columeName];
                } 
            } 
        }
    }
    return model;
}

+ (NSString *)getSqliteTypeFromProType:(NSString *)proType{
    NSRange range = [proType rangeOfString:@"\""];
    if ([proType isEqualToString:[NSString stringWithFormat:@"%@ %@",SQLINTEGER,PrimaryKey]]) {
        return proType;
    } else if (range.location!=NSNotFound) {
        proType = [proType substringFromIndex:range.location+range.length];
        range = [proType rangeOfString:@"\""];
        proType = [proType substringToIndex:range.location];
        if ([[self bolbset] containsObject:proType]) {
            return SQLBLOB;
        } else if ([[self textset] containsObject:proType]) {
            return SQLTEXT;
        } else {
            Class class = NSClassFromString(proType);
            if ([class isSubclassOfClass:[JKDBModel class]]) {
                return SQLBLOB;
            }
            return SQLNULL;
        }
    } else if ([proType hasPrefix:@"Ti"]
               ||[proType hasPrefix:@"TI"]
               ||[proType hasPrefix:@"Ts"]
               ||[proType hasPrefix:@"TS"]
               ||[proType hasPrefix:@"TB"]) {
        return SQLINTEGER;
    } else if ([proType hasPrefix:@"Tf"]
               ||[proType hasPrefix:@"Td"]) {
        return SQLREAL;
    }
    return SQLNULL;
}
/**
 *  获取该类的所有属性
 */
+ (NSDictionary *)getPropertys
{
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    NSArray *theTransients = [[self class] transients];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        //获取属性名
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([theTransients containsObject:propertyName]) {
            continue;
        }
        [proNames addObject:propertyName];
        //获取属性类型等参数
        NSString *propertyType = [NSString stringWithCString: property_getAttributes(property) encoding:NSUTF8StringEncoding];
        [proTypes addObject:propertyType];
    }
    free(properties);
    
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}

/** 获取所有属性，包含主键pk */
+ (NSDictionary *)getAllProperties
{
    NSDictionary *dict = [self.class getPropertys];
    
    NSMutableArray *proNames = [NSMutableArray array];
    NSMutableArray *proTypes = [NSMutableArray array];
    [proNames addObject:primaryId];
    [proTypes addObject:[NSString stringWithFormat:@"%@ %@",SQLINTEGER,PrimaryKey]];
    [proNames addObjectsFromArray:[dict objectForKey:@"name"]];
    [proTypes addObjectsFromArray:[dict objectForKey:@"type"]];
    return [NSDictionary dictionaryWithObjectsAndKeys:proNames,@"name",proTypes,@"type",nil];
}
+ (NSString *)getColumeAndTypeString
{
    NSMutableString* pars = [NSMutableString string];
    NSDictionary *dict = [self.class getAllProperties];
    
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    NSMutableArray *proTypes = [dict objectForKey:@"type"];
    
    for (int i=0; i< proNames.count; i++) {
        [pars appendFormat:@"%@ %@",[proNames objectAtIndex:i],[self.class getSqliteTypeFromProType:[proTypes objectAtIndex:i]]];
        if(i+1 != proNames.count)
        {
            [pars appendString:@","];
        }
    }
    return pars;
}
- (BOOL)valueIsKindOfSet:(id)value{//是集合类型
    if ([value isKindOfClass:[JKDBModel class]]) {
        return NO;
    }
    if ([value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSSet class]]) {
        return YES;
    }
    return NO;
}
- (BOOL)classIsSubOfSetClass:(Class)class{
    if ([class isSubclassOfClass:[JKDBModel class]]) {
        return NO;
    }
    if ([class isSubclassOfClass:[NSArray class]]||[class isSubclassOfClass:[NSSet class]]) {
        return YES;
    }
    return NO;
}
- (NSString *)description
{
    NSString *result = @"";
    NSDictionary *dict = [self.class getAllProperties];
    NSMutableArray *proNames = [dict objectForKey:@"name"];
    for (int i = 0; i < proNames.count; i++) {
        NSString *proName = [proNames objectAtIndex:i];
        id  proValue = [self valueForKey:proName];
        result = [result stringByAppendingFormat:@"%@:%@\n",proName,proValue];
    }
    return result;
}
+ (NSDictionary *)dictWithModel:(JKDBModel *)model{
    unsigned int count;
    
    // 获取类中的所有成员属性
    Ivar *ivarList = class_copyIvarList(model.class, &count);
    NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
    for (int i = 0; i < count; i++) {
        // 根据角标，从数组取出对应的成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员属性名
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        if ([key hasPrefix:@"_"]) {
            key = [key substringFromIndex:1];
        }
        id value = [model valueForKey:key];
        
        // 二级转换:如果字典中还有字典，也需要把对应的字典转换成模型
        // 判断下value是否是字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 字典转模型
            // 获取模型的类对象，调用modelWithDict
            // 模型的类名已知，就是成员属性的类型
            
            // 获取成员属性类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            // 生成的是这种@"@\"User\"" 类型 -》 @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
            // 裁剪类型字符串
            NSRange range = [type rangeOfString:@"\""];
            
            type = [type substringFromIndex:range.location + range.length];
            
            range = [type rangeOfString:@"\""];
            
            // 裁剪到哪个角标，不包括当前角标
            type = [type substringToIndex:range.location];
            
            
            // 根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            
            
            if (modelClass) { // 有对应的模型才需要转
                
                // 把字典转模型
                value  =  [modelClass dictWithModel:value];
            }
        }
        // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
        // 判断值是否是数组
        if ([value isKindOfClass:[NSArray class]]) {
            // 获取数组中字典对应的模型
            NSDictionary *dict = [model.class arrayOfModelName];
            NSString *type =  dict[key];
            if (type) {
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (JKDBModel *subModel in value) {
                    // 字典转模型
                    id model =  [classModel dictWithModel:subModel];
                    [arrM addObject:model];
                }
                
                // 把模型数组赋值给value
                value = arrM;
            }
        }
        if (value) { // 有值，才需要给模型的属性赋值
            // 利用KVC给模型中的属性赋值
            [dicM setValue:value forKey:key];
        }
    }
    return [dicM copy];
}

+ (instancetype)modelWithDict:(NSDictionary *)dict//完整的字典转模型方法
{
    // 思路：遍历模型中所有属性-》使用运行时
    
    // 0.创建对应的对象
    id objc = [[self alloc] init];
    unsigned int count;
    
    // 获取类中的所有成员属性
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        // 根据角标，从数组取出对应的成员属性
        Ivar ivar = ivarList[i];
        
        // 获取成员属性名
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 处理成员属性名->字典中的key
        // 从第一个角标开始截取
        NSString *key = [name substringFromIndex:1];
        
        // 根据成员属性名去字典中查找对应的value
        id value = dict[key];
        
        // 二级转换:如果字典中还有字典，也需要把对应的字典转换成模型
        // 判断下value是否是字典
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 字典转模型
            // 获取模型的类对象，调用modelWithDict
            // 模型的类名已知，就是成员属性的类型
            
            // 获取成员属性类型
            NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
            // 生成的是这种@"@\"User\"" 类型 -》 @"User"  在OC字符串中 \" -> "，\是转义的意思，不占用字符
            // 裁剪类型字符串
            NSRange range = [type rangeOfString:@"\""];
            
            type = [type substringFromIndex:range.location + range.length];
            
            range = [type rangeOfString:@"\""];
            
            // 裁剪到哪个角标，不包括当前角标
            type = [type substringToIndex:range.location];
            
            
            // 根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            
            
            if (modelClass) { // 有对应的模型才需要转
                
                // 把字典转模型
                value  =  [modelClass modelWithDict:value];
            }
            
            
        }
        
        // 三级转换：NSArray中也是字典，把数组中的字典转换成模型.
        // 判断值是否是数组
        if ([value isKindOfClass:[NSArray class]]) {
            // 获取数组中字典对应的模型
            NSDictionary *dict = [self arrayOfModelName];
            NSString *type =  dict[key];
            if (type) {
                // 生成模型
                Class classModel = NSClassFromString(type);
                NSMutableArray *arrM = [NSMutableArray array];
                // 遍历字典数组，生成模型数组
                for (NSDictionary *dict in value) {
                    // 字典转模型
                    id model =  [classModel modelWithDict:dict];
                    [arrM addObject:model];
                }
                
                // 把模型数组赋值给value
                value = arrM;
            }
        }
        
        
        if (value) { // 有值，才需要给模型的属性赋值
            // 利用KVC给模型中的属性赋值
            [objc setValue:value forKey:key];
        }
        
    }
    
    return objc;
}
#pragma mark - must be override method
/** 如果子类中有一些property不需要创建数据库字段，那么这个方法必须在子类中重写
 */
+ (NSArray *)transients
{
    return [NSArray array];
}

+ (NSDictionary *)arrayOfModelName{
    return [NSDictionary dictionary];
}

@end
