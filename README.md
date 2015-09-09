![image](https://github.com/CharlinFeng/Resource/blob/master/CoreModel/logo.jpg)<br/><br/>


##更新特性太多，文档重制中！陆续为您呈现！
##创业初期精力有限，本人最后一个开源OC框架：因您而精彩！


<br/><br/><br/>
一、CoreModel使用前言
==========

<br/>
#### 1.为什么要重制？
首先感谢大量朋友对我的框架的喜欢，同时也提出了各种问题和要求，最重要的有以下：<br/>
> (1). 不支持NSData。<br/>
> (2). 不支持NSArray。<br/>
> (3). 全部主线程操作，对性能有一定的影响。<br/>

<br/>
#### 2.框架依赖
> (1). CoreFMDB 数据库操作。<br/>
> (2). CoreHttp 网络请求：第四季及第五季用到。<br/>
> (3). CoreStatus 网络状态检测：第四季及第五季用到。<br/>
> (4). MJExtension 整个框架仅仅用了他的遍历成员属性这唯一的一个功能，别无他用。<br/>


<br/>
#### 3.其他说明
> (1). 强烈建议关注：[信息公告牌](https://github.com/CharlinFeng/Show)以便获取最实时的框架更新动态。<br/>
> (2). 开源第四季动态缓存的条件为：`CoreModel的Star数据超过1000`。<br/>
> (3). 之前有朋友过于喜欢我的框架，导致在没有任何说明的情况下借用我的代码，所以本次框架去除了所有的中文注释。从使用的角度上来说对您没有任何影响。<br/>



<br/>
#### 4.最终申明
在开始之前，请您注意以下几点：<br/>
>(1). 导入了sqlite3.lib 动态库。<br/>
>(2). 拖拽CoreModel及FrameWorks文件夹到您的项目。<br/>
>(3). 安装了Navicat Preminum。<br/>


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
##### 本功能请查看项目中：Test2VC.m
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

说明：
>(2). 框架在控制台输出的第一条信息就是您的DB位置：dbPath:path.sql，请注意因为iOS沙盒机制有变化，这个Path会不停的变化，你使用Navicat Preminum查看数据库文件的时候，最好是每次都更新path（在数据库连接上右键，修改当前DB的path）。
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
五、全线程处理！block回调！性能卓越！
==========
<br/>
#### 我们还是打开Debug模式，请查看控制台各种关于线程的输入
##### 不仅仅是创建是这样，后面所有关于数据库的CURD操作，全部是在子线程中完成的，基本Operation，同时有并发限制，多线程在本框架得到完美展现，性能不再是问题！

    2015-09-09 10:58:44.291 CoreModel[3427:3903] dbPath:/Users/Charlin/Library/Developer/CoreSimulator/Devices/E1B1C2D8-DC98-4571-AF45-8A6D76F07497/data/Applications/9174CFF6-3EA1-4BDB-904C-C5373E0E00E0/Documents/CoreModel/CoreModel.sql
    2015-09-09 10:58:44.293 CoreModel[3427:3903] 表创建完毕<NSThread: 0x7a679c80>{name = (null), num = 2}
    2015-09-09 10:58:44.293 CoreModel[3427:3903] 字段检查所在线程：<NSThread: 0x7a679c80>{name = (null), num = 2}
    2015-09-09 10:58:44.294 CoreModel[3427:3903] 字段也检查完毕<NSThread: 0x7a679c80>{name = (null), num = 2}
    2015-09-09 10:58:44.294 CoreModel[3427:3903] 创表所在线程：<NSThread: 0x7a679c80>{name = (null), num = 2}

#### 注意：因为是子线程，所以您的block回调，全部是子线程，如果你在block里面更新UI，或者Push界面，需要自行回到主线程。你可能会问我的block为什么不在主线程中回调，因为有的时候block回调需要可能还有一定的数据处理，在主线程中执行同样会有一定的性能浪费。这一点在第四季和第五季中有强烈的展现。















