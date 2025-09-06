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

### Mutual recursion
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
- 树有一个root label和一些branches，每一个branch都是一个tree，所以可以递归构造tree。
- 逆序递归：不对递归函数的返回值做操作，而是直接返回（即最后一个递归返回值就是最终结果），利用参数将递归变量传递进去
    ```python
    def fact_times(n, k = 1):
        if n == 0:
            return k
        else:
            return fact_times(n - 1, k * n)
    fact_times(n, 1)
    ```

## Lecture 15: Mutability
### 对象(object)
- 有属性(attribute，用dot operator`.`来调用)；若attribute是函数，则称为方法(method)
- python中的每隔值都是对象，有attribute。
    ```python
    # String
    s.upper()
    s.lower()
    ```
- 某种对象的抽象称为类(class)，类是一类变量，可以作为参数或返回值

### 变易(mutability)
- 对象分为可变类型(mutable type，如list, dictionary，可变类型的对象不能作为dictionary的key)和不可变类型(immutable type，如tuple)。可变变量的attribute可以被改变，不可变变量反之。
    ```python
    # dictionary
    d.pop['key']
    # list
    l.pop()
    l.append()
    ```
    - 用一个对象对另一个对象赋值，效果是两个name都被bind到同一个对象（即指向同一个内存地址，可以由`is`operator来判断），并不会创建一个新对象（但对sequence进行切片会创建新的对象，更改后新对象的元素不会更改原对象的元素）。
        ```python
        >>> a = b
        >>> a is b
        True
        ```
    - 函数的变量的默认值是作为一个变量的函数的一部分，有固定的内存地址，所以若是可变类型，则默认值会改变
        ```python
        def f(s = []):
            s.append(1)
            return len(s)
        ```
    - 不可变类型：元组(tuple)
        ```python
        a = (1,)
        b = (1, 2)
        tuple([1, 2, 3])
        >>> (1, 2) + (3, 4)
        (1, 2, 3, 4)
        ```
- 希望在函数中实现可变的值和固定的局部状态，可以用高阶函数来实现（相当于给了高阶函数一个context，让它能够知道改变后的状态
    ```python
    def make_withdraw_list(balance):
        b = [balance]
        def withdraw(amount):
            if amount > b[0]:
                return 'insufficient'
            else:
                b[0] -= amount
                return b[0]
        return withdraw
    ```
    该函数可以记住减去`amount`之后的剩余`balance`。
## Lecture 16: Iterator
- Container, Sequence和iterable（可迭代对象）的区别：
    - container指所有能存放多个元素的数据结构，可以有序也可以无序
    - sequence是有序的container
    - interable是指所有能被`for`遍历的对象，包括container，sequence和iterator；
        - iterator可以由任何iterable通过`iter()`构造得到（可以看作基于原来的iterable构造了一个链表），通过`next()`方法来得到当前值，同时iterator中自带的“指针”移动到下个地址上
        - iterator是mutable的；若其基于所构造的iterable长度改变，则该iterator不能再使用；但若长度不变，只是值改变，则可以继续使用。
- Iterator的method一般是惰性计算的，即不调用`next()`不计算
    ```python
    map(func, iterable) #返回Iterator，指向func(iterable)
    filter(func, iterable) #返回Iterator，指向func(iterable)  == True的iterable元素组成的新iterable
    zip(first_iter, second_iter[, third_iter, ..]) #返回Iterator，指向两个iterable通过笛卡尔积生成的tuple组成的iterable，返回的Iterator长度等于传入的最短iterable的长度
    reversed(iterable) #返回Iterator，指向iterable反向的iterable
    list(iterable), tuple(iterable), sorted(iterable) #分别基于iterable构造list，tuple和sorted list
    ```
- 使用Iterator是为了当原始数据的数据类型改变（如从list变为tuple）时不影响后续程序（相当于通过构建链表实现了一层抽象隔离。

## Lecture 17: Generator
- Generator是Iterator的一种，由generator function构造；generator function和普通函数的区别在于使用了`yield`关键词，返回generator。对generator使用`next()`时调用generator function，到下一个`yield`暂停，下次使用`next()`时会继续运行（即实现了可暂停的函数）。
    ```python
    def evens(start, end):
        even = start + (start % 2)
        while even < end:
            yield even
            even += 2
    ```
- generator function可以从其它iterable生成generator，使用`yield from`语句：
    ```python
    def a_then_b(iterable_a, iterable_b):
        yield from iterable_a
        yield from iterable_b
    ```
- 使用generator function实现整数partition，返回一个generator，其每一项是一个字符串，字符串内容是整数的某种分割（好处是如果分割方式很多，但不想全部得到，可以节省时间。
    ```python
    def partitions(n, m):
        if n > 0 and m > 0:
            if n == m:
                yield str(m)
            for p in partitions(n - m, m):
                yield p + ' + ' + str(m)
            yield from partions(n, m - 1)
    ```
## Lecture 18: Objects
- 希望把庞大的程序分成一些模块，将抽象的数据类型和它们的相互作用行为绑定起来形成类（类也是对象，由类生成的称为实例）。
- user defined class
    ```python
    class Account:
        company = 'Visa'
        def __init__(self, account_holder):
            self.balance = 0
            self.holder = account_holder
        def deposit(self, amount):
            self.balance += amount
            return self.balance
    ```
    - 用类名来创建实例（构造方法），如`list(),tuple()`
    - 调用method时，`self`变量通过`.`operator传入。
    - attribute可以直接在外部用赋值语句改变，也可以直接在外部添加attribute(mutable type，无论是class attribute还是instance attribute)
    - 用`is, is not`operator来判断两个名字是否指向同一个对象


## Lecture 19: Attributes
- class attribute和instance attribute的区别：上述的`company`是class attribute，只在类模板中存储，不构造实例时也可以通过`Account.company`获取，对于由其创建的所有实例都相同；`self.balance`是instance attribute，只有创建实例时才生成。
    - 用`.`获取attribute时先评估`.`左侧的表达式，先在实例中寻找该attribute，找不到再去类模板中寻找。instance attribute和class attribute可以有共同的名字，改变class attribute不会改变同名的instance attribute
    - 作为class attribute的method就是function，需要显式地传入`self`参数；作为instance attribute的method称为bound method，`.`operator隐式地传入了`self`参数。