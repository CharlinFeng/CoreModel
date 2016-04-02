
![image](https://github.com/CharlinFeng/Resource/blob/master/CoreModel/logo.jpg)<br/><br/>


#### 不需要懂sql，一键数据库存储工具（[成都时点软件开发有限公司](http://ios-android.cn)原创出品）
##### 列表终结者框架即将开源：一键实现一个列表，含有上拉下拉与分页，全自动数据解析，加载视图，动态缓存。


<br/><br/><br/>
一、CoreModel使用前言
==========

<br/>
#### 1.为什么要重制？
在推出了CoreModel感谢大量朋友对我的框架的喜欢，同时也提出了各种问题和要求，最重要的有以下：<br/>
> (1). 不支持NSData。<br/>
> (2). 不支持NSArray。<br/>
> (3). 全部主线程操作，对性能有一定的影响。<br/>

<br/>
#### 1.本次更新了什么新特性？
> (1). Reflect全面抛弃MJExtension，此框架在CoreModel中有大量崩溃。目前框架全面原创，自有Reflect，从此CoreModel再无崩溃。 <br/>
> (2). 无hostID可以全自动创建。不会再触发断言。不过不建议无hostID的数据插入，可能会造成大量重复数据。<br/>

注： 有很多朋友提到hostID需要字符串化，因为有的服务器的id是一个特别的字符串，现在你可以把这个类似id的字符串存为一个普通字段，然后无hostID存入即可。后面CURD直接根据此字段来关联操作即可。

<br/>
#### 3.框架依赖
> (1). CoreFMDB 数据库操作。<br/>




<br/>
#### 3.其他说明（持续关注[信息公告牌](https://github.com/CharlinFeng/Show)）
> (1). 强烈建议关注：`信息公告牌`以便获取最实时的框架更新动态。<br/>
> (2). 开源第四季一键列表的条件为：`CoreModel的Star数据超过1000`。<br/>
> (3). 之前有朋友过于喜欢我的框架，导致在没有任何说明的情况下借用我的代码，所以本次框架去除了所有的中文注释。从使用的角度上来说对您没有任何影响。<br/>
> (4). 请添加异常断点，以便捕获我提供的大量断言。<br/>
> (5). 特别提醒：示例程序有强烈的先后顺序，最好不要随便乱点，比如一个数据都没有insert，你点击了update或者delete等操作会达到你难以理解的结果。<br/>



<br/>
#### 4.最终申明
在开始之前，请您注意以下几点：<br/>
>(1). 导入了sqlite3.lib 动态库。<br/>
>(2). 拖拽CoreModel及FrameWorks文件夹到您的项目。<br/>
>(3). 安装了Navicat Preminum。<br/>
>(4). Swift使用，不能Swift中的Model继承CoreModel。

<br/><br/><br/>
二、基本使用
==========
<br/>
####新建模型Person，继承自CoreModel，模型加入以下属性：

    #import "CoreModel.h"
    
    @interface Person : CoreModel
    
    @property (nonatomic,copy) NSString *name;
    
    @property (nonatomic,assign) NSInteger age;
    
    @end


<br/><br/><br/>
三、全自动创表
==========
<br/>
#### 框架全自动创表触发的条件：调用CoreModel子类的任意一个方法。
##### 本功能请参考项目中：Test2VC.m
现在，我们随意调用Person的任意一个方法，这里我们以实例化一个Person实例说明：

    /** 全自动创表 */
    Person *person = [[Person alloc] init];

,查看控制台输出，已经发现成功创建了数据库，成功创建表，并写入了字段信息：

        sqlite> PRAGMA table_info (Person);
        +------+--------+---------+---------+------------+------+
        | cid  | name   | type    | notnull | dflt_value | pk   |
        +------+--------+---------+---------+------------+------+
        | 0    | id     | INTEGER | 1       | 0          | 1    |
        | 1    | name   | TEXT    | 1       | ''         | 0    |
        | 2    | age    | INTEGER | 1       | 0          | 0    |
        | 3    | hostID | INTEGER | 1       | 0          | 0    |
        | 4    | pModel | TEXT    | 1       | ''         | 0    |
        | 5    | pid    | INTEGER | 1       | 0          | 0    |
        +------+--------+---------+---------+------------+------+
        6 rows in set (0.02 sec)

说明：<br/>
>(1). 框架在控制台输出的第一条信息就是您的DB位置：dbPath:path.sql，请注意因为iOS沙盒机制有变化，这个Path会不停的变化，你使用Navicat Preminum查看数据库文件的时候，最好是每次都更新path（在数据库连接上右键，修改当前DB的path）。<br/>
>(2). 有您不熟悉的字段如pid,pModel是框架辅助字段，请不要删除。<br/>
>(3). 核心字段：hostID是服务器主键，任何使用CoreModel的模型必须拥有唯一的hostID，如果您没有hostID，请构建。<br/>



<br/><br/><br/>
四、调试模式与非调试模式
==========
<br/>
#### 框架有极其全面的Debug信息与断言帮助您正确的使用CoreModel
##### 如果您不喜欢控制台大量输出Debug信息，请到CoreModelConst.h文件，修改以下宏定义：

    /** Debug */
    #define CoreModelDeBug 1

，如果您修改为1，即是Debug模式，控制台会有大量输出，如果您不需要显示，改为0即可。


<br/><br/><br/>
五、全部子线程运行 + Block回调，性能卓越！
==========
<br/>
#### 我们还是打开Debug模式，请查看控制台各种关于线程的输入.<br/>
##### 不仅仅是创建是这样，后面所有关于数据库的CURD操作，全部是在子线程中完成的，基本Operation，同时有并发限制，多线程在本框架得到完美展现，性能不再是问题！<br/>

    2015-09-09 10:58:44.291 CoreModel[3427:3903] dbPath:/Users/Charlin/Library/Developer/CoreSimulator/Devices/E1B1C2D8-DC98-4571-AF45-8A6D76F07497/data/Applications/9174CFF6-3EA1-4BDB-904C-C5373E0E00E0/Documents/CoreModel/CoreModel.sql
    2015-09-09 10:58:44.293 CoreModel[3427:3903] 表创建完毕<NSThread: 0x7a679c80>{name = (null), num = 2}
    2015-09-09 10:58:44.293 CoreModel[3427:3903] 字段检查所在线程：<NSThread: 0x7a679c80>{name = (null), num = 2}
    2015-09-09 10:58:44.294 CoreModel[3427:3903] 字段也检查完毕<NSThread: 0x7a679c80>{name = (null), num = 2}
    2015-09-09 10:58:44.294 CoreModel[3427:3903] 创表所在线程：<NSThread: 0x7a679c80>{name = (null), num = 2}

#### 注意：因为是子线程，所以您的block回调，全部是子线程，如果你在block里面更新UI，或者Push界面，需要自行回到主线程。你可能会问我的block为什么不在主线程中回调，因为有的时候block回调需要可能还有一定的数据处理，在主线程中执行同样会有一定的性能浪费。这一点在第四季和第五季中有强烈的展现。所以，决定权交给您自己。


<br/><br/><br/>
五、模型字段检查，全自动增加字段
==========
<br/>
有时候你可能有这样的需求，开发到一定阶段或者版本，需要增加模型字段。CoreModel已经完全为您考虑了这种情况，下面我们修改Person模型，增加一个Height字段，结果如下：

    @interface Person : CoreModel
    
    @property (nonatomic,copy) NSString *name;
    
    @property (nonatomic,assign) NSInteger age;
    
    @property (nonatomic,assign) CGFloat height;
    
    @end
 
 ,此时我们再向Person发送任意消息，并查看控制台输出：
 
    2015-09-09 11:06:47.269 CoreModel[3474:3903] 注意：模型 Person 有新增加的字段 height,已经实时添加到数据库中！
    
,我们打开数据库查看表结构：

    sqlite> PRAGMA table_info (Person);
    +------+--------+---------+---------+------------+------+
    | cid  | name   | type    | notnull | dflt_value | pk   |
    +------+--------+---------+---------+------------+------+
    | 0    | id     | INTEGER | 1       | 0          | 1    |
    | 1    | name   | TEXT    | 1       | ''         | 0    |
    | 2    | age    | INTEGER | 1       | 0          | 0    |
    | 3    | hostID | INTEGER | 1       | 0          | 0    |
    | 4    | pModel | TEXT    | 1       | ''         | 0    |
    | 5    | pid    | INTEGER | 1       | 0          | 0    |
    | 6    | height | REAL    | 1       | 0.0        | 0    |
    +------+--------+---------+---------+------------+------+
    7 rows in set (0.04 sec)

我们发现，字段已经成功增加。

##### 你可能会问，如果我想删除一个属性，框架会自动删除字段吗？答案是否定的，原因有以下：

>(1). 如果删除字段，之前的有关此字段的数据全部丢失，如果你后期又想使用此字段，就造成了遗憾。<br/>
>(2). Sqlite 3本身无删除字段语法，有技术可以实现，但对有大量数据的表来说有极大的操作风险。<br/>


<br/><br/><br/>
五、无hostID操作
==========
<br/>
##### 本功能请参考项目中：Test3VC.m
#### 为了让您正确的使用CoreModel，框架做了大量的断言帮助您正确的使用，最容易出现的错误就是对HostID认识不够深刻，假如您的模型没有设置HostID，现在框架会自动创建hostID,请一定要注意这种情况下可能会有重复数据出现。

此外，以下不合法操作均会触发断言：
>(1). 模型混用，比如使用Cat类方法对Person执行数据操作如[Cat insert:person resBlock:nil];<br/>
>(2). 数组支持中，数组申明OC数组成员为NSInteger、CGFloat、Bool等（后面会有详细介绍）。<br/>


注意：

>(1). HostID是对应服务器表的主键，在CoreModel中hostID会自动映射解析服务器json里面的id字段，你无需手动映射。<br/>




<br/><br/><br/>
六、基本模型 + 单条数据插入
==========
<br/>

#### 我们构建合法的Person对象，并执行Insert操作：
##### 本功能请参考项目中：Test4VC.m

    Person *person = [[Person alloc] init];
    person.hostID = 1;
    person.name = @"冯成林";
    person.age = 28;
    person.height = 174.0;
    /** Insert */
    [Person insert:person resBlock:^(BOOL res) {
        [self show:res];
    }];

，运行结果提示成功，并且控制台输出全部是在子线程中完成，我们查看数据库：

    sqlite> select * from Person;
    +----+-----------+-----+--------+--------+-----+--------+
    | id | name      | age | hostID | pModel | pid | height |
    +----+-----------+-----+--------+--------+-----+--------+
    | 1  | 冯成林    | 28  | 1      |        | 0   | 174.0  |
    +----+-----------+-----+--------+--------+-----+--------+
    1 rows in set (0.05 sec)

##### 注： 当你再次运行Test4VC.m，会发现提示失败，那是因为hostID为1的数据已经存在，

    错误：Person表中hostID=1的数据记录已经存在！
    
你也可以通过查看控制台,能够看到上面的Debug输出，明白这是合理的。


<br/><br/><br/>
七、基本模型 + 批量数据插入
==========
<br/>
##### 本功能请参考项目中：Test5VC.m

    Person *p1 = [[Person alloc] init];
    p1.hostID = 2;
    p1.name = @"jack";
    p1.age = 25;
    p1.height = 180;
    
    Person *p2 = [[Person alloc] init];
    p2.hostID = 3;
    p2.name = @"jim";
    p2.age = 22;
    p2.height = 172;
    

    [Person inserts:@[p1,p2] resBlock:^(BOOL res) {
        [self show:res];
    }];

#### 提示成功，数据库返回结果如下：

    sqlite> select * from Person;
    +----+-----------+-----+--------+--------+--------+-----+
    | id | name      | age | height | hostID | pModel | pid |
    +----+-----------+-----+--------+--------+--------+-----+
    | 1  | 冯成林    | 28  | 174.0  | 1      |        | 0   |
    | 2  | jack      | 25  | 180.0  | 2      |        | 0   |
    | 3  | jim       | 22  | 172.0  | 3      |        | 0   |
    +----+-----------+-----+--------+--------+--------+-----+
    3 rows in set (0.01 sec)


<br/><br/><br/>
八、基本模型 + 单条数据修改
==========
<br/>
##### 本功能请参考项目中：Test6VC.m
##### 这里我修改了我的姓名和身高字段值，请注意前后对比：

    Person *person = [[Person alloc] init];
    person.hostID = 1;
    person.name = @"Charlin Feng";
    person.age = 28;
    person.height = 173.5;
    [Person update:person resBlock:^(BOOL res) {
        [self show:res];
    }];

#### 执行结果：

    sqlite> select * from Person;
    +----+--------------+-----+--------+--------+--------+-----+
    | id | name         | age | height | hostID | pModel | pid |
    +----+--------------+-----+--------+--------+--------+-----+
    | 1  | Charlin Feng | 28  | 173.5  | 1      |        | 0   |
    | 2  | jack         | 25  | 180.0  | 2      |        | 0   |
    | 3  | jim          | 22  | 172.0  | 3      |        | 0   |
    +----+--------------+-----+--------+--------+--------+-----+
    3 rows in set (0.01 sec)



<br/><br/><br/>
九、基本模型 + 批量数据修改
==========
<br/>
##### 本功能请参考项目中：Test7VC.m
##### 这里我修改了姓名字段值，请注意前后对比：

    Person *p1 = [[Person alloc] init];
    p1.hostID = 2;
    p1.name = @"杰克";
    p1.age = 25;
    p1.height = 180;
    Person *p2 = [[Person alloc] init];
    p2.hostID = 3;
    p2.name = @"吉姆";
    p2.age = 22;
    p2.height = 172;
    [Person updateModels:@[p1,p2] resBlock:^(BOOL res) {
        [self show:res];
    }];

#### 执行结果：

    sqlite> select * from Person;
    +----+--------------+-----+--------+--------+--------+-----+
    | id | name         | age | height | hostID | pModel | pid |
    +----+--------------+-----+--------+--------+--------+-----+
    | 1  | Charlin Feng | 28  | 173.5  | 1      |        | 0   |
    | 2  | 杰克         | 25  | 180.0  | 2      |        | 0   |
    | 3  | 吉姆         | 22  | 172.0  | 3      |        | 0   |
    +----+--------------+-----+--------+--------+--------+-----+
    3 rows in set (0.01 sec)


<br/><br/><br/>
十、基本模型 + 单条数据保存
==========
<br/>
##### 本功能请参考项目中：Test8VC.m
#### 请注意数据保存(Save) 和数据插入(Insert)是有区别的
##### Insert是简单的数据插入，如果数据存在要么抛出错误，要不返回不处理
##### Save是指保存数据时，进行智能判断，如果数据记录不存在，执行Insert操作。如果数据已经存在，执行Update操作，总之，执行Save操作后，你指定的数据一定会作为最新数据记录在数据库中。

模型数据：修改了名称与年龄，请注意前后比对：

    Person *p1 = [[Person alloc] init];
    p1.hostID = 2;
    p1.name = @"杰克先生";
    p1.age = 40;
    p1.height = 180;
    Person *p2 = [[Person alloc] init];
    p2.hostID = 3;
    p2.name = @"吉姆先生";
    p2.age = 38;
    p2.height = 172;
    [Person saveModels:@[p1,p2] resBlock:^(BOOL res) {
        [self show:res];
    }];

#### 执行结果：

    sqlite> select * from Person;
    +----+--------------+-----+--------+--------+--------+-----+
    | id | name         | age | height | hostID | pModel | pid |
    +----+--------------+-----+--------+--------+--------+-----+
    | 1  | Charlin Feng | 28  | 173.5  | 1      |        | 0   |
    | 2  | 杰克先生     | 40  | 180.0  | 2      |        | 0   |
    | 3  | 吉姆先生     | 38  | 172.0  | 3      |        | 0   |
    +----+--------------+-----+--------+--------+--------+-----+
    3 rows in set (0.01 sec)
<br/>
注意：
> (1). 如果是单条数据保存，请使用 `+(void)save:(id)model resBlock:(void(^)(BOOL res))resBlock;`<br/>
> (2). 如果是批量数据保存，请使用 `+(void)saveModels:(NSArray *)models resBlock:(void(^)(BOOL res))resBlock`<br/>
> (3). 有一种情况比较特殊，就是你不清楚是单条还是批量（CoreModel内部有遇到此种情况并使用了此方法），请使用 `+(void)saveDirect:(id)obj resBlock:(void(^)(BOOL res))resBlock`<br/>
> (4). 再次提醒，此方法会导致数据一定写入数据库，和insert与update有区别，请知晓。



<br/><br/><br/>
十一、基本模型 + 条件删除
==========
<br/>
##### 本功能请参考项目中：Test9VC.m
##### 我们删除年龄大于等于40岁的记录：

    [Person deleteWhere:@"age >= 40" resBlock:^(BOOL res) {
        [self show:res];
    }];

#### 执行结果，杰克先生因为年龄刚好40岁，所以被删除：

    sqlite> select * from Person;
    +----+--------------+-----+--------+--------+--------+-----+
    | id | name         | age | height | hostID | pModel | pid |
    +----+--------------+-----+--------+--------+--------+-----+
    | 1  | Charlin Feng | 28  | 173.5  | 1      |        | 0   |
    | 3  | 吉姆先生     | 38  | 172.0  | 3      |        | 0   |
    +----+--------------+-----+--------+--------+--------+-----+
    2 rows in set (0.02 sec)


说明：您还可以根据主键一键删除，注意主键指的是hostID，而非本地数据库的主键id。




<br/><br/><br/>
十二、基本模型 + 条件查询
==========
<br/>
##### 本功能请参考项目中：Test10VC.m
##### 为了更好的检验数据查询是否成功，CoreModel增加了description方法,直接打印即可。

    [Person selectWhere:nil groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
        
        NSLog(@"%@",selectResults);
    }];
    
#### 执行结果，  

    2015-09-09 14:52:18.806 CoreModel[5335:3a03] (
        "[Person]<0x7c199670>: 
          name: Charlin Feng, 
          age: 28, 
          height: 173.5, 
          hostID: 1, 
          pModel: , 
          pid: 0, 
    ",
        "[Person]<0x7c19a330>: 
          name: \U5409\U59c6\U5148\U751f, 
          age: 38, 
          height: 172, 
          hostID: 3, 
          pModel: , 
          pid: 0, 
    "
    )

请注意：
> (1). 因为我们刚刚测试了删除，删除了一条记录，所以现在结果当然是两条。<br/>
> (2). 框架对CoreModel做了desctiontion自动处理，您能直接看到以上结果。<br/>
> (3). 和删除类似，您也可以根据hostID(再次提示，非本地数据库id)快速查找一条记录,使用的方法为:`+(void)find:(NSUInteger)hostID selectResultBlock:(void(^)(id selectResult))selectResultBlock;`<br/>



<br/><br/><br/>
十三、基本模型 + 清空表数据
==========
<br/>
##### 本功能请参考项目中：Test11VC.m

    [Person truncateTable:^(BOOL res) {
    }];

注意：清空了所有表记录，同时重置了本地数据库的主键id，慎用！


<br/><br/><br/>
十四、NSData的支持
==========
<br/>
##### 本功能请参考项目中：Test12VC.m
框架新增加对NSData的支持,我们需要给Person模型增加一个NSData的属性(当然框架会自动新增字段)：

    @interface Person : CoreModel
    
    @property (nonatomic,copy) NSString *name;
    
    @property (nonatomic,assign) NSInteger age;
    
    @property (nonatomic,assign) CGFloat height;
    
    @property (nonatomic,strong) NSData *photoData;
    
    @end

我们直接使用最普通的方式保存，

    Person *charlin = [[Person alloc] init];
    charlin.hostID = 1;
    charlin.name = @"冯成林";
    charlin.age = 28;
    charlin.photoData = UIImagePNGRepresentation([UIImage imageNamed:@"1"]);
    [Person save:charlin resBlock:^(BOOL res) {
        [self show:res];
    }];

，然后我们查询数据即可，请注意回调全部是子线程，更新UI请回到主线程：

    __weak typeof(self) weakSelf=self;
    [Person find:1 selectResultBlock:^(Person *selectResult) {
        
        [weakSelf show:selectResult != nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.imageV.image = [[UIImage alloc] initWithData:selectResult.photoData];
            
            weakSelf.label.text = [NSString stringWithFormat:@"%@%@",selectResult.name,@(selectResult.age)];
        });
        
    }];

<br/><br/><br/>
十五、属性为单模型级联：数据插入（级联模型请一定要全部是CoreModel的子类！）
==========
<br/>
##### 本功能请参考项目中：Test13VC.m
##### 首先解释标题意思：指的是模型有一个属性是自定义模型，为了演示效果，我们再定义一个City类，且Person有一个属性是城市。

##### 这个是目前的Person模型：

    @interface Person : CoreModel
    
    @property (nonatomic,copy) NSString *name;
    
    @property (nonatomic,assign) NSInteger age;
    
    @property (nonatomic,assign) CGFloat height;
    
    @property (nonatomic,strong) NSData *photoData;
    
    @property (nonatomic,strong) City *city;
    
    @end


##### 这个是目前的City模型,请注意你的City模型当然也必须是CoreModel的子类：

    @interface City : CoreModel
    
    @property (nonatomic,copy) NSString *cityName;
    
    @property (nonatomic,copy) NSString *spell;
    
    @end

下面我们构建数据，执行如下数据并执行级联添加：

    City *city = [[City alloc] init];
    city.hostID = 1;
    city.cityName = @"成都";
    city.spell = @"ChengDu";
    Person *p5 = [[Person alloc] init];
    p5.hostID=5;
    p5.name = @"张三";
    p5.city=city;
    [Person insert:p5 resBlock:^(BOOL res) {
        [self show:res];
    }];
    
#### 执行成功，我们查询结果检验：

    sqlite> select * from Person;
    +----+--------+-----+--------+-----------+--------+--------+-----+
    | id | name   | age | height | photoData | hostID | pModel | pid |
    +----+--------+-----+--------+-----------+--------+--------+-----+
    | 1  | 张三   | 0   | 0.0    |           | 5      |        | 0   |
    +----+--------+-----+--------+-----------+--------+--------+-----+
    1 rows in set (0.01 sec)
    
    
    sqlite> select * from City;
    +----+----------+---------+--------+-----------+-----+
    | id | cityName | spell   | hostID | pModel    | pid |
    +----+----------+---------+--------+-----------+-----+
    | 1  | 成都     | ChengDu | 1      | Person    | 5   |
    +----+----------+---------+--------+-----------+-----+
    1 rows in set (0.00 sec)

#### 注：子模型的级联还牵扯一个复杂问题就是：Person有一个模型属性正好也是Person类。不过此种情况已经测试，完美支持。


#### 注意，由于代码是复用的，级联的CURD是不会有任何问题的，这里不再提供进一步的测试。


<br/><br/><br/>
十六、数组支持：基本类型数组
==========
<br/>
##### 本功能请参考项目中：Test14VC.m
为了更好的演示本功能，我们再为Person增加一个属性tags，用来表示人的一些标签，请明确，他是字符串数组。

    @property (nonatomic,strong) NSArray *tags;

现在我们来构建模型：

    Person *p = [[Person alloc] init];
    p.hostID=6;
    p.name = @"冯成林";
    p.tags = @[@"工作狂",@"电影迷",@"成都范",@"梦想青年"];
    [Person save:p resBlock:^(BOOL res) {
        [self show:res];
    }];

，我们测试以上代码，发现被断言截获，断言说明如下：

    错误：请在Person类中为您的NSArray类型的tags属性增加说明信息，实现statementForNSArrayProperties静态方法！
    
,这个是前面最开始的断言中提到的一种非法使用，当然解决问题的方法很简单，断言也说明的很清楚，您需要告诉CoreModel你的tags数组里面装的是什么类型，实现，格式要求如下：实现statementForNSArrayProperties静态方法，返回一个字典，其实key是数组属性名，value是数组成员的类型字符串，比如此处我们需要在Person类实现方法：

    +(NSDictionary *)statementForNSArrayProperties{
        return @{@"tags":NSStringFromClass([NSString class])};
    }
,有可能您认为您的数组中装的其实是一系列数字，你也许会这样写:

    +(NSDictionary *)statementForNSArrayProperties{
        return @{@"tags":@"NSInteger"};
    }
，这样写，我们直接运行一下，发现同样会触发断言：

    错误：OC数组内不可能存放NSInteger

，就目前来说，服务器给您的的普通数据你直接用NSString来接收就可以了，当然你可能会想写成NSNumber可以不呢？其实我觉得没有这个必要，因为再者转为NSInteger、CGFloat、Double的流程其实是一致的，所以数组里面装的如果是普通数组类型，请直接用NSString来接收。

我们还是来看看数据库里面存放结果：

    sqlite> select * from Person;
    +----+-----------+-----+--------+-----------+--------+--------+-----+--------------------------------------------+
    | id | name      | age | height | photoData | hostID | pModel | pid | tags                                       |
    +----+-----------+-----+--------+-----------+--------+--------+-----+--------------------------------------------+
    | 1  | 张三      | 0   | 0.0    |           | 5      |        | 0   |                                            |
    | 2  | 冯成林    | 0   | 0.0    |           | 6      |        | 0   | 工作狂,电影迷,成都范,梦想青年 |
    +----+-----------+-----+--------+-----------+--------+--------+-----+--------------------------------------------+
    2 rows in set (0.02 sec)


最后，有朋友会问，
数组里面装装的如果是字典怎么办？这点上，在面向对象开发，字典一定是可以转为模型的。不建议继续玩字典。
数组里面装的如果是数组怎么办？转为NSData操作
关于数组里面装的是NSData和自定义模型，下面马上为您呈现。



<br/><br/><br/>
十七、数组支持：NSData类型数组
==========
<br/>
##### 本功能请参考项目中：Test15VC.m
首先，我们增加字段,请明确字段数组里面放的是NSData数据类型:

    @property (nonatomic,strong) NSArray *dreams;

,然后我们需要申明dreams数组内存放的是什么数据类型：

    +(NSDictionary *)statementForNSArrayProperties{
        return @{@"tags":NSStringFromClass([NSString class]),@"dreams":NSStringFromClass([NSData class])};
    }

，好了，下面我们开始构建数据：

    Person *p = [[Person alloc] init];
    p.hostID=7;
    p.name = @"大雄";
    p.dreams = @[
                 [self dataWithImageName:@"p1"],
                 [self dataWithImageName:@"p2"],
                 [self dataWithImageName:@"p3"],
                 ];
    [Person save:p resBlock:^(BOOL res) {
        [self show:res];
    }];

，保存结果请参考框架`数组支持：NSData类型数组`演示效果。



<br/><br/><br/>
十八、数组支持：自定义模型数组
==========
<br/>
##### 本功能请参考项目中：Test16VC.m
为了演示本功能，我们新增Pen模型，并在Person模型中新增pens属性：

##### Pen模型

    @interface Pen : CoreModel
    
    @property (nonatomic,copy) NSString *color;
    
    @property (nonatomic,assign) CGFloat price;
    
    @end

##### Person中新增pens属性：

    @property (nonatomic,strong) NSArray *pens;

，当然你不能忘记申明pens里面放的是什么数据类型：

    +(NSDictionary *)statementForNSArrayProperties{
        return @{@"tags":NSStringFromClass([NSString class]),@"dreams":NSStringFromClass([NSData class]),@"pens":NSStringFromClass([Pen class])};
    }

，下面我们构建模型数据，并执行保存操作：

    Pen *pen1=[[Pen alloc] init];
    pen1.hostID=1;
    pen1.color = @"red";
    pen1.price = 12.5;
    Pen *pen2=[[Pen alloc] init];
    pen2.hostID=1;
    pen2.color = @"blue";
    pen2.price = 9.8;
    Person *p = [[Person alloc] init];
    p.hostID = 8;
    p.name = @"静香";
    p.pens=@[pen1,pen2];
    [Person save:p resBlock:^(BOOL res) {
        [self show:res];
    }];

，执行成功，我们看看数据库里面的保存记录：

sqlite> select * from Person;
+----+--------+-----+--------+-----------+------+--------+--------+--------+-----+
| id | name   | age | height | photoData | tags | dreams | hostID | pModel | pid |
+----+--------+-----+--------+-----------+------+--------+--------+--------+-----+
| 1  | 静香   | 0   | 0.0    |           |      |        | 8      |        | 0   |
+----+--------+-----+--------+-----------+------+--------+--------+--------+-----+
1 rows in set (0.01 sec)

sqlite> select * from Pen;
+----+-------+-------+--------+--------+-----+
| id | color | price | hostID | pModel | pid |
+----+-------+-------+--------+--------+-----+
| 1  | red   | 12.5  | 1      | Person | 8   |
| 2  | blue  | 9.8   | 1      | Person | 8   |
+----+-------+-------+--------+--------+-----+
2 rows in set (0.01 sec)


<br/><br/><br/>
十九、综合实战：网络数据一键CURD
==========
<br/>
##### 本功能请参考项目中：Test17VC.m
#####为了演示本功能，我为大家准备了一个测试接口，我们所有准备已经做好，直接开工：
#### 注意：本例是CoreModel最正经的用法，也是我写本框架的最直接的目的所在：
#### 本例是自定义模型属性数组支持与子模型级联的综合演示：

    NSString *url = @"http://211.149.151.92/mytest/Test/test3";
    CoreSVPLoading(@"加载中", YES)
    [CoreHttp getUrl:url params:nil success:^(NSDictionary *dict) {
        
        Person *p = [Person objectWithKeyValues:dict[@"data"][@"dataData"][@"person"]];
        
        [Person save:p resBlock:^(BOOL res) {
            
            [self show:res];
        }];
        
    } errorBlock:nil];

，处理成功，我们来看看表记录：

    sqlite> select * from Person;
    +----+--------+-----+--------+-----------+------+--------+--------+--------+-----+
    | id | name   | age | height | photoData | tags | dreams | hostID | pModel | pid |
    +----+--------+-----+--------+-----------+------+--------+--------+--------+-----+
    | 1  | 张三   | 18  | 185.0  |           |      |        | 100    |        | 0   |
    +----+--------+-----+--------+-----------+------+--------+--------+--------+-----+
    1 rows in set (0.00 sec)
    
    sqlite> select * from City;
    +----+----------+---------+--------+--------+-----+
    | id | cityName | spell   | hostID | pModel | pid |
    +----+----------+---------+--------+--------+-----+
    | 1  | 成都   | ChengDu | 100    | Person | 100 |
    +----+----------+---------+--------+--------+-----+
    1 rows in set (0.00 sec)
    
    sqlite> select * from Pen;
    +----+-------+-------+--------+--------+-----+
    | id | color | price | hostID | pModel | pid |
    +----+-------+-------+--------+--------+-----+
    | 1  | red   | 18.55 | 100    | Person | 100 |
    | 2  | green | 22.22 | 101    | Person | 100 |
    +----+-------+-------+--------+--------+-----+
    2 rows in set (0.06 sec)






<br/><br/><br/>
二十、 第四季与第五季预告
==========

##### 第四季：CoreCache 动态缓存
##### 第五季：CoreList 列表终结者
<br/>
第三季CoreModel在我看来是一个底层工具，他的核心价值是为CoreCache和CoreList服务，就在CoreModel中你会发现大量的代码是在本季没有提到，请暂时忽略它吧。


<br/><br/><br/><br/>

#### [成都时点软件开发有限公司](http://ios-android.cn)冯成林原创，因你而精彩！

#### 支持时点软件发展（公司前期做全国APP外包），为时点提供业务资源与信息，我们感激不尽！！
<br/>
[![image](https://github.com/CharlinFeng/Resource/blob/master/ShiDian/shidian.png)](http://ios-android.cn)<br/><br/>

