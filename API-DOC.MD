# API文档
## 函数列举

- ### [zy.copy](#copy)
- ### [zy.split](#split)
- ### [zy.isResult](#isResult)
- ### [zy.setValues](#setValues)
- ### [zy.freeze](#freeze)
- ### [zy.remove](#remove)
- ### [zy.getListItems](#getListItems)
- ### [zy.search](#search)
- ### [zy.offset](#offset)
- ### [zy.filter](#filter)
- ### [zy.findLast](#findLast)
- ### [zy.setElements](#setElements)
- ### [zy.escape](#escape)
- ### [zy.getDir](#getDir)
- ### [zy.getSegments](#getSegments)
- ### [zy.gotoAddress](#gotoAddress)

## 函数介绍

<div id="copy"/>

原型：`mixed zy.copy(table src)`

介绍
- 以递归的方式深度拷贝字典

参数
- src - 源字典

返回
- 目标字典
- 传参错误时返回`nil`

----

<div id="split"/>

原型：`table zy.split(string src,string s)`

介绍
- 因GG没有自带`string.split`函数,所以在这里写了一个

参数
- src - 待分隔字符串
- s - 分隔符

返回
- 分隔完的字符串数组
- 传参错误时返回空字典

----

<div id="isResult"/>

原型：`bool zy.isResult(table item)`

介绍
- 判断是否是GG的搜索结果的结构

----

<div id="setValues"/>

原型：`nil zy.setValues(table results,number value,bool update=false)`

介绍
- 批量修改值

参数
- results - GG搜索结果的数组
- value - 要设置的值
- update - 是否更新内存
	+ false - 只修改数组
	+ true - 修改数组并修改内存值

----

<div id="freeze"/>

原型：`nil zy.freeze(table items,number value=nil,string name=nil)`

介绍
- 冻结指定内存值

参数
- items - GG搜索结果数组
- value - 要修改的值
- name - 名字

----

<div id="remove"/>

原型：`nil zy.remove(table items)`

介绍
- 移除保存列表指定元素
- 如果指定元素是被冻结的内存值,可以起到解冻效果

参数
- items - GG搜索结果数组

----

<div id="getListItems"/>

原型：`mixed zy.getListItems(string name=nil)`

介绍
- 在保存列表中获取指定名字的元素
- 没有传参就返回全部

参数
- name - 名字

返回
- 匹配到的元素
- 匹配不到元素时返回`nil`

----

<div id="search"/>

原型：`mixed zy.search(number count,table ...)`

介绍
- 对搜索功能进行封装

参数
- count - 最终取搜索结果的数量(传0表示取全部结果)
- [...] - 搜索表达式,结构见下文。多少参数就过滤多少次

返回
- 搜索到的结果
- 传参错误或搜索不到时返回`nil`

不定参的结构：
```
struct={"0;1;2::9",gg.TYPE_DWORD}

struct[1]--联合搜索表达式
struct[2]--数据类型
```

E.g.
- `result=zy.search(0,{"0.0;1.0;2.0::9",gg.TYPE_FALOT},{"0.0"})`搜索`0.0;1.0;2.0::9`,改善`0.0`

----

<div id="offset"/>

原型：`number zy.offset(table item,number offset)`

介绍
- 获取指定结果的偏移指定位置的值
- 此函数没有传参判断,因此参数传递错误就直接报错

参数
- item - GG搜索结果
- offset - 偏移量,负数则向前偏移

----

<div id="filter"/>

原型：`mixed zy.filter(table items,mixed value,string key="value",bool reverse=false)`

介绍
- 过滤出指定值的元素

参数
- items - 数组
- value - 匹配的值
- key - 要匹配的元素
- revrese - 反向过滤

返回
- 过滤出的元素数组
- 匹配不到时返回`nil`

E.g.
- `items=zy.filter(items,10)`

----

<div id="findLast"/>

原型：`mixed zy.findLast(string str,string flag)`

介绍
- 获取`flag`在`str`最后出现的位置

返回
- 当`str`里没有`flag`时,返回`nil`

<div id="setElements"/>

原型：`nil zy.setElements(table items,mixed value,string key="value",bool inc=false)`

介绍
- 批量编辑字典中的元素

参数
- items - 数组
- value - 修改的值
- key - 要修改的元素
- inc - 是否自增(仅限元素为number类型时)

----

<div id="escape"/>

原型：`string zy.escape(string raw)`

介绍
- 将`raw`中的正则表达式转义为普通字符串

参数
- raw - 原始字符串

返回
- 转义后的字符串

----

<div id="getDir"/>

原型：`string zy.getDir(string file=nil)`

介绍
- 获取文件的绝对路径
- 如果没有传参数,默认`gg.getFile()`

----

<div id="getSegments"/>

原型：`table zy.getSegments(string exp)`

介绍
- 获取指定名字的可写段

参数
- exp - 表达式

返回
- 匹配的段数组

----

<div id="gotoAddress"/>

原型：`number zy.gotoAddress(string segment,number ...)`

介绍
- 读取指针链，以获取地址

参数
- segment - 段名
- [...] - 每个指针节点的偏移值

返回
- 最终地址
- 如果读取失败,则返回`0`

