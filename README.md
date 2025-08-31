# CS61A

## Lecture 2: Functions

### Expression
- Primitive expression: number, name, string, etc.
- Assignment expression: bind value to a name, we can also bind a function to a name
    ```python
    f = max
    f(a,b)
    ```
    > 可见函数在python中是first class value，即可以像其它value一样被赋值、作为参数和返回值。
- Call expression: consist of operator(like name of a function) and operand(like argument/parameter of a function).使用call expression时从左到右依次evaluate operator和operands。

### Function
- funcition definition: def expression
    - function signature: consist of function name and formal parameter

- function calling
    1. add a local frame using the function signature(thus forming a new environment)

        > frame即局部作用域，变量只在内部起作用，全局变量所在的frame称为global frame；environment是许多frame的序列，如在执行某函数`f`时，局部变量所在的environment就是f frame-global frame。某个frame可以谈论其parent frame

    2. bind the formal parameters to the arguments

        > 每个expression都在特定的environment下被evaluate，即在evaluate一个name时，会将其evaluate到当前环境中该name出现的最近的frame中该name的值（即变量只在局部作用域取值）

- return value
    - 不返回任何value的函数返回 `None`(属于NoneType)
    - 若函数的唯一效果是返回一个value，则称为pure function；若有额外效果，则称为Non-pure function

## Lecture 3: Control

### Python in Bash

- 以交互模式运行Python并执行文件：
    ```bash
    python3 -i ex.py
    ```
- 在python函数中写包含doctest的注释文档：
    ```python
    def max(a, b)
        """
        >>> max(1, 2)
        >>> 2
        """
        if(a > b):
            return a
        else:
            return b
    ```
    并在bash中运行该测试来检测函数是否能实现正常功能：
    ```bash
    python3 -m doctest max.py
    ```

### Boolean contexts
- 条件语句中被判断的部分称为Boolean context
    - 假值包括：`False`,`0`,`''`,`None`；真值是其它value
    - assert statement: 通常用于对变量的取值做限制：
        ```python
        assert a > 0, 'a must be positive.' 
        ```
## Lecture 4: Higher-order function

- 高阶函数指形参或返回值是function name的函数，如
    ```python
    def make_area(prefactor):
        def area(r):
            return prefactor * r * r
        return area
    make_area(2)(3)

    def general_sum(n, term):
        total, k = 0, 1
        while(k <= n):
            total += term(k)
            k += 1
        return total
    ```
    > 高阶函数中会在函数体中定义函数，称为locally defined functions，只在其所在的函数对应的local frame中有效，所以local defined function和local frame一样也有parent的概念，其parent即为其def语句所在的local frame。

- 可变数量的参数列表`*args`
    ```python
    def printed(f):
        def print_and_return(*args):
            print('Result:', result)
            return result
        return print_and_return
    ```
    
## Lecture 5: environment

### 高阶函数的environment diagram

- 高阶函数中有嵌套def语句时environment diagram如下图所示

    ![alt text](note_img/env-diagram-nested-function.png)

### Lambda expression

- 用于使用赋值语句而非def语句将函数bind到某个name上
    ```python
    square = lambda x: x * x
    (lambda x: x * x)(3)
    ```
    > 一般的function（包括build in function和user defined function都有intrinsic name，而lambda函数只会被显示为lambda，即其不像def语句在创建时就具有名字

### Function Currying

将多变量函数分解嵌套为单变量函数的过程称为currying，如
```python
def make_adder(n)
    return lambda k: n + k
make_adder(2)(3)
add(2, 3)
```
一般化可以写为

```python
def curry2(f):
    def g(x):
        def h(y)
            return f(x, y)
        return h
    return g
```

## Lecture 7: Functional Abstraction

### Function abstraction

> 将某个计算过程抽象成函数，只需要知道函数的输入（参数）和输出（返回值），而完全无需知道其具体实现。

### Errors and tracebacks

错误类型：
1. syntax error: 表达式形式不正确，执行前就能被python解释器发现
2. runtime error: 执行程序时被解释器发现，解释器会给出traceback（给出error发生时解释器正在做什么）
3. logical error: 不会被解释器发现

## Lecture 8: Function examples

### Decorators
装饰器是使用高阶函数的一个python特性。

```python
def trace1(fn):
    def traced(x)：
        print('Calling', fn, 'on argument', x)
        return fn(x)
    return traced

@traced1
def square(x):
    return x * x
```
等价于 
```python
square = trace1(square)
```

## Lecture 9: Recursion

### 递归函数
递归函数定义为在函数体中调用自身的函数，主要结构为一个判断语句，包含
1. base case: 问题划归到最简的情形，不调用自身，直接返回值；
2. recursive case: 相当于数列的递推公式，$a(n)=f(n,a(n-1))$

```python
def fact(n):
    if(n == 0):
        return 0
    else:
        return n * fact(n)
```

## Mutual recursion
递归是通过将问题规模逐渐减小，当减到最小时问题解决；但若不同规模下问题的解有不同形式，就需要用到互递归。
- 例：给定一串数字，从右向左数第偶数个数字乘2（若乘2后大于10则将结果的个位和十位相加）、第奇数个数字不变，再把变换后的数字序列各位相加。
    ```python
    def split(n):
        return n // 10, n % 10

    def sum_digits(n):
        if(n < 10):
            return n
        else:
            rest, last = split(n)
            return sum_digits(rest) + last

    def luhn_sum(n):
        if(n < 10):
            return n
        else:
            rest, last = split(n)
            return luhn_sum_double(rest) + last

    def luhn_sum_double(n):
        rest, last = split(n)
        if(n < 10):
            return sum_digits(2 * n)
        else:
            rest, last = split(n)
            return luhn_sum(rest) + sum_digits(2 * n)
    ```
- 反向递归：有时可能需要将问题从1开始逐渐扩大到给定的 $n$，这时由于原始函数只能以终点为参数，无法递归，则可定义以起点为参数的辅助函数
    ```python
    def interleaved_sum(n, odd_func, even_func):
        """Compute the sum odd_func(1) + even_func(2) + odd_func(3) + ..., up
        to n.

        >>> identity = lambda x: x
        >>> square = lambda x: x * x
        >>> triple = lambda x: x * 3
        >>> interleaved_sum(5, identity, square) # 1   + 2*2 + 3   + 4*4 + 5
        29
        """
        def helper(k):
            if k == n:
                return odd_func(k)
            elif k == n - 1:
                return odd_func(k) + even_func(k + 1)
            else:
                return odd_func(k) + even_func(k + 1) + helper(k + 2)
        return helper(1)
    ```
- 若限制不能给函数命名还要实现递归，则可以把函数名称放到lambda表达式的参数中：
    ```python
    lambda n: 1 if n == 1 else n * (lambda x, fact: 1 if x == 1 else x * fact(x - 1, fact))(n - 1, lambda x, fact: 1 if x == 1 else x * fact(x - 1, fact))

    ```

## Lecture 10: Tree recursion
当在递归函数中不只一次调用函数本身时，调用会形成树状结构（每次调用内部又有多个调用），称为树状递归。
- 计数配分问题：将$n$个球分为多份，每份不多于$m$个，有多少种分法：
    ```python
    def counting_partition(n, m):
        if(n == 0):
            return 1
        elif(n < 0):
            return 0
        elif(m == 0):
            return 0
        else:
            return counting_partition(n - m, m) + counting_partition(n, m - 1)
    ```

## Lecture 11: Sequences
Sequence指一系列变量类型。
### List
- list `[]` 的加法代表拼接，乘法代表重复
- `in`和`not in`都是双操作数的container operator，判断某元素是否在序列中，返回Boolian类型。

### Range
- range类型也是序列的一种，特指连续整数序列，含头不含尾：`range(2, 5)`
- 可以通过调用 `list()`函数来将其它序列变量转换为list

### For语句
- `for`语句和container`in`相伴而生，它本质并不是循环，而是遍历序列元素，很多情况下不需要索引，且可以在`for`语句的header直接序列解包：
    ```python
    pairs = [[1, 2], [2, 2]]
    x, y = pairs
    for x, y in pairs:
        print(x + y)
    ```
- list comprehension: 可以在list中用for语句从其它list创建该list，如
    ```python
    odds = [1, 3, 5, 7, 9]
    [x + 1 for x in odds if 25 % x == 0]
    ```


## Lecture 12 Container
- 序列聚合：函数输入序列，输出单个值，称为序列聚合。
    - `sum`函数：`sum(iterable[, start])`（start决定了`+` operator如何重载，默认为0，即默认为数字加法）
        ```python
        >>> sum([2, 3, 4], 5)
        14
        >>> sum([[2, 3],[4]], [])
        [2, 3, 4]
        ```
    - `max`函数：`max(iterable[, key = func])`不仅可以求最大值，还可以求`key`函数的极值点
        ```python
        >>> max([2, 3, 4], lambda x: - (x - 3) ^ 2)
        3
        ```
    - `all`函数：对iterable参数中所有值作用`bool()`函数（返回该值对应的boolean context），起到`AND`的作用
        ```python
        >>> all([1, 2, 3])
        True
        >>> all([0, 1])
        False
        ```
    
- String:`''`或`""`，也是sequence类型
    ```python
    >>> 'here' in 'where'
    True
    >>> [1, 2] in [1, 2, 3]
    False
    ```
- Dictionary：键值对，`Dic = {key1: value1, key2: value2}`（键和值都可以是任意类型，但键不能是列表或字典，键不能重复），索引`Dic[key1]`；是键和值的序列
    ```python
    >>> list(Dic)
    [key1, key2]
    >>> Dic.values()
    dict_values([value1, value2])
    ```
    - Dictionary comprehension: 可以通过for语句构建字典
        ```python
        {key[i]: value[i] for i in range(n) if i // 2}
        

## Lecture 13: Data abstraction
- 数据抽象是为了将数据的表示和使用隔离开。可以看到下面的例子分别将有理数实现为列表和函数，但不改变其操作方式。
```python
### Abs Level 1: 创建数据
from fractions import gcd
def rational(n, d): # constructor（抽象数据类型的构造器）
    return [n // gcd(n, d), d // gcd(n, d)]
def numer(x): # selector
    return x[0]
def denom(x): # selector
    return x[1]

def rational(n, d): # constructor（抽象数据类型的构造器）
    def select(name):
        if name == 'n':
            return n
        elif name == 'd':
            return d
    return select
def numer(x): # selector
    return x('n')
def denom(x): # selector
    return x('d')

### Abs Level 2: 操作数据
def mul_rational(x, y):
    return rational(numer(x) * numer(y), denom(x) * denom(y))
def add_rational(x, y):
    pass
def equal_rational(x, y):
    pass
```

## Lecture 14: Tree