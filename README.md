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
- 可以使用`hasattr(<object>,'name')`来判断某个对象是否有某个attribute。

## Lecture 20: Inheritance
### inheritance
当某个类型是另一个类型的特殊化时，可以使用类继承：
```python
class <name>(<base class>):
    <suite>
```
子类具有基类的所有attribute，也可以overwrite基类的attribute。
> 所以attribute的创建和调用关系为：instance attribute可以overwrite class attribute，subclass attribute可以overwrite base class attribute。当调用attribute时，首先在instance中查找，找不到的话去class中查找，再找不到则去base class中查找。已被覆盖的attribute也可以被访问，只是需要直接用类名或基类名来访问。


### 多重继承(multiple inheritance)
多重继承指的是某个类有多个基类，只需要在定义class时指定多个基类即可。若继承的多个基类有相同名称的attribute，则优先继承先指定的（左侧的）类的attribute。


### composition
composition指某个class以其它class（或instance）作为attribute，表示包含关系；而inheritance表示一般类和特殊类关系。

## Lecture 21: Representation
### String representation
- python中所有object都有两种string representation
    1. `str()`是给人看的string rep
    2. `repr()`是给解释器看的，是一个python表达式（称为这个object的canonical string representation，即在python interactive mode中调用object时自动打印的string），满足`eval(repr(object)) == object`。
- F-string：string合成的方法，允许在string中插入表达式（会将表达式的`str()` string插入到整个string中），如`f'1 + 1 == {1 + 1}'`

### 多态函数(polymorphic functions)
多态函数指某个函数适用于多个数据类型（即同时作为多个object的method，如`str()`,`repr()`,`add()`，其同时定义在多个object上，于是可以根据传入的参数不同来决定函数行为不同），如
```python
class usr_defined:
    def __repr__(self):
        return "<class usr_defined>"
    def __str__(self):
        return "usr_defined"
```
> 特殊的method名称：python中有一些特殊的method名称，如`__init__()`,`__repr__()`,`__add__()`,`__radd__()`,`__bool__()`,`__float__()`都在名称前后有`__`，其含义只是表示这是一个特殊的method。

> 接口(interface)：面向对象编程的核心是对象之间的信息传递，信息传递通过互相调用attribute来实现，而多态函数使得不同对象能够对相同信息做出不同响应，是信息传递的重要方法，所以也称为接口。


## Lecture 22: Composition
### 链表(linked list)
链表定义为：每个链表可能是空值，或者包含当前值以及一个链表（递归定义，类似树）./
```python
class Link:
    empty = ()
    def __init__(self, first, rest = empty):
        assert rest is Link.empty or isinstance(rest, Link)
        self.first = first
        self.rest = rest
```
> 由于链表的`rest`attribute是`Link`instance类型，所以这样定义的链表属于class composition

## Lecture 23: Efficiency
- 由于python的所有数据类型本质上都是object，所以理论上都可以添加attribute：
    ```python
    def count(f):
        def counted(n):
            counted.call_count += 1
        return f(n)
        counted.call_count = 0
        return count
    ```
    可以返回某个函数 `f`调用了多少次。其中 `def count(f)`类似于定义了一个类。
- 记忆化(Memoization)：可以通过创建缓存的方式来加速程序
    ```python
    def memo(f):
        cache = {}
        def memoized(n):
            if n not in cache:
                cache[n] = f(n)
            return cache[n]
        return memoized
    ```
    需要 `f`为纯函数。
- 时间复杂度：由高到低一般分为指数、二次、线性、对数。用 $\Theta()$ 代表上界和下界均为该复杂度，用 $O()$ 表示上界是该复杂度。

- 空间复杂度：值和框架(frame)都会占用内存。只有当前依然存在的frame（称为active environment中的frame，如正在调用尚未返回的函数）占用内存，其它frame会被自动回收。

## Lecture 25: Data Examples
我们把 Python 的 名字绑定（name binding） 用类似 C 指针的思路来解释：在 Python 中，变量名并不是“变量槽+值”的组合，而是指向对象的一个标签（reference）。把一个名字赋值给某个对象，相当于让这个名字指向（引用）该对象的内存地址；不是把对象内容复制到名字下面。
关键点在于 对象的可变性（mutable / immutable）：可变对象（list、dict、set、自定义对象等）可以被“就地修改”，所有引用该对象的名字都会“看到”修改；不可变对象（int、str、tuple 等）不能被就地修改，改变它通常意味着把名字重新绑定到另一个对象。

python变量存储的图像是：内存地址中存储着很多objects，程序中有很多names。程序操作要不是改变内存地址中存储的object的值，要不是把name绑定到不同的内存地址中存储的object。对于可变对象，其内存地址分为多个槽，每个槽相当于一个name，即存储的并不是实际的值，而是指针，指向槽所代表的真实对象。

下面是一个例子。

准备：起始状态
```python
s = [2, 3]   # s --> list_obj_A
t = [5, 6]   # t --> list_obj_B
```

把引用画成：
```yaml
s ──▶ [2, 3]        (list_obj_A)
t ──▶ [5, 6]        (list_obj_B)
```
1. `append`：`s.append(t)` 之后 `t = 0`
    ```
    s.append(t)
    # s -> [2, 3, [5, 6]]
    # t 仍指向 list_obj_B

    t = 0
    # 现在 t -> 0 (int)
    # 但 s[2] 仍然引用原来的 list_obj_B
    ```
    `append` 是就地操作（in-place mutation），把 `t` 当前指向的对象（`list_obj_B`）的引用 放入 `s` 的末尾。并没有复制 `list_obj_B`。

    当你随后执行 `t = 0`，只是把名字 `t` 重新绑定到整数 `0`；并不会影响 `s`中原来保存的对 `list_obj_B` 的引用。即`s` 中的新元素和 `t` 最初 指向的是同一个对象，但 `t` 的重绑定不改变 `s` 中那个引用。
    ```yaml
    before append:
    s ──▶ list_A
    t ──▶ list_B

    after append:
    s ──▶ list_A (last element points to list_B)
    t ──▶ list_B

    after t = 0:
    s ──▶ list_A (last element still → list_B)
    t ──▶ 0
    ```
2. `extend`：`s.extend(t)` 然后 `t[1] = 0`
    ```python
    s.extend(t)
    # s -> [2, 3, 5, 6]
    # 注意：s[2] is t[0] (same object 5), s[3] is t[1] (same object 6)

    t[1] = 0
    # t -> [5, 0]
    # s -> [2, 3, 5, 6]  （s 不受 t[1] = 0 的影响）
    ```
    `extend` 把 `t` 中的元素一个个取出并把对这些元素的引用放到 `s` 中（就地改变 `s` 的内容）。对元素本身不做复制，只复制引用。

    对于不可变对象（如整数），`t[1] = 0` 并不是“修改整数 `6`”，而是把 `t` 的槽 `t[1]` 重新绑定到新的整数对象 `0`。这不会改变 `s[3]` 已经引用的那个整数对象 `6`。

    如果 `t` 的元素是可变对象（例如一个子列表），那么 `extend` 后 `s` 和 `t` 中对应的槽会引用同一个可变对象，对该可变对象的就地修改会被 `s` 和 `t` 共同看到。

3. `+`（concatenation）和切片 `[:]`（都产生新列表）
    ```python
    a = s + [t]
    # a 是全新列表（新对象 list_C）
    # a -> [2, 3, list_B]   （a[2] 引用 list_B，list_B 仍是 t 指向的对象）
    b = a[1:]
    # b 是 a 的切片，也是新列表（新对象 list_D）
    # b -> [3, list_B]

    a[1] = 9
    # 这只改变 a（新列表），不影响 s 或 b

    b[1][1] = 0
    # b[1] 是 list_B，所以对 list_B 的就地修改会影响所有引用它的名字：
    # list_B -> [5, 0]
    # 因此 a 中的 a[2]（即 list_B），b 中的 b[1]，以及 t 都会反映该变化
    ```
    `s + [t]` 创建了一个全新的列表 `a`（不同于 `s`）。虽然 `a` 的最后一个元素引用了 `t` 指向的原始 `list_B`（即没有深拷贝），但 `a` 本身是新对象。

    `a[1:]` 同样返回新列表 `b`（浅拷贝切片）。`b[1]` 与 `a[2]` 都引用的是同一个 `list_B`。因此对 `list_B` 的就地修改会被所有引用它的地方看到。

    `a[1] = 9 `是修改 `a` 这个新列表的槽，不会影响 `s`。

4. `list()`：浅拷贝（顶层创建新列表，对元素进行引用复制）
    ```python
    t = list(s)
    # t 是新的列表对象（list_E），含有 s 中元素的引用（2, 3）
    s[1] = 0
    # s -> [2, 0]
    # t -> [2, 3]  （t 不受影响）
    ```
    `list(s)` 与 `s[:]` 类似，都会创建新列表对象，并把 `s` 的每个元素的引用拷贝到新列表（这是“浅拷贝”）。

    对 `s` 的重新赋值 `s[1] = 0` 只是重新绑定 `s` 的那个槽，不会影响 `t`。

    若 `s` 含可变子对象（比如 `s = [[1], [2]]`），`list(s)` 后两个列表会引用相同的子列表对象，修改子列表会在两个列表中都可见。

5. 切片赋值（slice assignment） — 就地修改 `s`

    图中例子依次执行：
    ```python
    s = [2, 3]
    t = [5, 6]

    s[0:0] = t
    # 把 t 的元素插入到 s 的位置 0（相当于在前面扩展）
    # s -> [5, 6, 2, 3]

    s[3:] = t
    # 把 s 从索引 3 开始的切片替换为 t 的元素
    # before s indices: 0:5,1:6,2:2,3:3
    # replace [3] with [5,6]
    # s -> [5, 6, 2, 5, 6]

    t[1] = 0
    # t -> [5, 0]
    # s stays [5, 6, 2, 5, 6]  （s 中的那些 6 是整数对象 6，与 t[1] 重新绑定无关）
    ```

    `s[0:0] = t` 与 `s[3:] = t` 都是 就地改变 `s` 的内容，不会创建新的 `s` 对象（`id(s)` 不变）。

    插入/替换时，元素是按引用插入的：若插入的是可变对象，则所有对该对象的地方会被影响；若插入的是不可变对象，后续对另一处进行重新绑定不会改变已有槽指向的对象。

## Lecture 28: Scheme

### 调用表达式(call expression)
- Scheme语言的表达式分为
    1. 基本表达式：`2`,`2.2`,`True`,`+`,`quotient`,...
    2. 组合(combination)：`(quotient 10 2)`
- 调用表达式的结构为：括号里的operator+operands，如`(+ 2 3)`，可以任意换行和缩进
- Scheme中有一些内建的procedure（即python中的function）
```scheme
> (zero? 0)
#t
> (Integer? 2.2)
#f
```
### 特殊形式(special forms)
- 不是call expression的combination就是special form：
    ```scheme
    (if <predicate> <consequent> <alternative>)
    (and <e1> ... <en>)
    (or <e1> ... <en>)
    (define <symbol> <expression>)
    (define (<symbol> <formal parameters>) <body>) ;;;定义procedure（即函数）
    (let (<bindings>) (<value>)) ;;;用于计算一个值的临时计算过程，其中binding中的绑定只临时有效
    ```
    如
    ```scheme
    > (define pi 3.14)
    > (define (abs x)
        (if (< x 0)
            (- x)
            x))
    > (cond ((> x 10) (begin (print 'big') (print 'guy')))
            ((> x 5) (print 'medium'))
            (else (print 'small'))) ;;; cond即switch语句，begin的作用是将多个表达式合成为一个表达式。
    > (define c (let ((a 3)
                        (b (+ 2 2)))
                    (sqrt (+ (* a a) (* b b)))))
    ```
- 符号运算：编程语言中有symbol和value，可以将symbol bind to value，也可以通过`quotation`来直接引用symbol。`quotation`也是一种special form，其参数不会被求值，而直接以其本身的形式被转化为数据。
```scheme
> (define a 1)
> (define b 2)
> (list a b)
(1 2)
> (list 'a (quote c) a b)
(a c 1 2)
```
可以在没有定义`c`时即quote `c`。
### Lambda 表达式
```scheme
(lambda (<formal parameters>) <body>)
```

## Lecture 29: Scheme Lists
### 作为链表的list
- Scheme语言中有列表(list)的数据类型，其类似于python中的链表。
    - `cons`：是用于创建链表的两变量procedure
    - `car`：用于获取链表的当前值
    - `cdr`：用于获取链表的rest链表
    - `nil`：空链表对象
- 可以创建链表，但显示时显示成普通列表的形式，其本质还是链表，无法通过索引来获取某个位置的值。
```scheme
> (cons 2 (cons 1 nil))
(1 2)
> (list 1 2 3 4)
(1 2 3 4)
```


### list处理procedure
```scheme
(append s t< d>) ;;; 将多个链表的元素合并
(map f s) ;;; 将f应用于s的每个元素
(filter f s) ;;; 将f应用于s的每个元素，并将所有为真的元素形成新链表
(apply f s) ;;; 将链表s作为f的参数整体传递进去。
```
如
```scheme
> (apply quotient '(10 5))
2
```


## Lecture 30: Calculator
### 异常机制：exception
在解释器运行的各个环节中若出现错误则会raise一个exception。这些环节包括：
1. 词法分析(lexical analysis)：如2.3.4不是一个有效的浮点数；
2. 语法分析(syntactic analysis)
3. 求值(eval)：保证程序处理的表达式要么是primitive的要么是combination
4. 应用(apply)：各种函数的调用过程

python中有一个描述错误的类，叫作`BaseException`，其子类有
1. `TypeError`：函数传入参数的个数或类型错误
2. `NameError`：没有找到某个名称
3. `KeyError`：字典中没有找到某个key
4. `RecursionError`：递归次数过多
子类的构造函数只需传入其异常语句，如
```python
TypeError('Bad argument'!)
```

在python中，exception可以自动触发（有错误时）或通过`raise`语句来手动触发exception，即`raise <expression>`，其中`<expression>`必须是`BaseException`的一个子类或一个instance。

### Try语句
若想要在发生错误后继续运行程序，则需要使用`try`语句来处理exception：
```python
try:
    <try suite>
except <exception class> as <name>:
    <exception suite>
```
其中`<exception class>`为错误类型，`<name>`是错误的名字，如：
```python
try:
    x = 1/0
except ZeroDivisionError as e:
    print('handling a', type(e))
    x = 0
```

### 编程语言和解释器
- 解释器：输入编辑器中的代码，输出代码描述的行为。
    - 程序：树
    - 解释器的工作方式：树递归
    - 表达式：包含子表达式的列表
    - 解释器：高阶函数（解释器作为函数其输入是程序即函数）
- 编程语言：
    - 机器语言：由硬件来解释，CPU有一组固定的指令集
    - 高阶语言：有表达式和语句（提供抽象），需要解释(interprete)或编译(compile)
        - 解释：阅读语句并执行其行为
        - 编译：将其转换成另一种语言（如机器语言）以便执行
    - python首先被编译为 Python 3 Byte Code，再由后者的解释器来运行。
- 创建编程语言
    - 需要语法(syntax)：语言中什么样的表达式和语句是合法的；语义(semantics)：表达式和语句的评估规则和错误规则
    - 可以从规范(specification)出发：即编写文档指定规则；也可以直接从解释器或编译器出发，称为canonical implementation。Scheme就是从规范出发的


### 语言的解析(Parsing)
想要对编程语言进行解释，首先需要将文本解析为结构。如Scheme代码是由括号组织的树状结构。
- 交互式解释器：Read-Eval-Print loop
    1. 打印一个prompt
    2. Read：从用户端读取输入
    3. 对输入进行parsing将其变为表达式
    4. Evaluate: 对表达式进行求值
    5. Print: 表达式的值或报错信息。

## Lecture 31: Interpreters
### Frames
- Frame通过traceback其parent frame来构造整个environment。一个frame必然是某个environment的第一个frame。
- 一个frame有两个attribute：一些binding关系和一个parent frame。
### Environments
- 创建环境的方式（即查找名称的方式）有两种
    1. Static scope(Lexical scope)：frame的parent是函数定义所在的环境（python和scheme采用，所以之前的helper函数需要在函数内定义，而不可定义在global frame中）
    2. Dynamic scope：frame的parent是函数调用所在的环境
    如
    ```scheme
    (define f (lambda (x) (+ x y)))
    (define g (lambda (x y) (f (+ x x))))
    (g 3 7)
    ```
    若采用static scope，则调用的 `f`frame的parent是global frame，无法找到 `y`；若采用dynamic scope，则调用的 `f`frame的parent是 `g` frame，则可以找到 `y`。

## Lecture 32: Tail Calls
### 函数式编程(Functional programming)
函数式编程有以下要求：
1. 所有函数都是纯函数
2. 所有变量都是不可变的：不能对变量重新赋值，没有mutable data type，name-value binding是永久的。
这样做的好处是：表达式的值和对子表达式求值的顺序无关（这样就可以对子表达式并行求值或lazy求值）。但这些要求意味着不能有`for`和`while`语句（因为不能对变量重新赋值），就不能迭代只能递归，而递归一般很慢。尾递归(tail recursion)的存在可以证明函数式语言和非函数式的可以一样快。

### 尾递归
- 在python递归总创建新的active frame。于是对于以下阶乘的递归和迭代实现：
    ```python
    def fac(n, k):
        if n == 0:
            return k
        else:
            return fac(n - 1, k * n)

    def fac_iter(n, k):
        while n > 0:
            n, k = n - 1, k * n
        return k
    ```
    两者的时间复杂度均为 $\Theta(n)$，但前者的空间复杂度为 $\Theta(n)$，后者的为 $\Theta(1)$。
- 但在scheme中，上述两种递归的实现的空间复杂度也是一样的，因为递归所调用的函数在调用自身后没有额外的操作，所以每个递归调用的函数的返回值均相同，于是scheme丢掉了中间的frame。
- Tail calls：指当一个函数调用另一个函数时，当被调用的函数完成后，进行调用的函数是否还有其它操作。scheme对于任意个数的tail call都可以在常数空间开销中完成，因为其跳过了中间的active frame。其本质是在tail context中的call expression
    - lambda表达式的最后一个sub-expression
    - if表达式的子表达式等
- 将 `map`函数的递归实现改为尾递归：一般的递归实现如下
    ```scheme
    (define (map procedure s)
        (if (null? s)
            nil
            (cons (procedure (car s))
                  (map procedure (cdr s)))))
    ```
    由于`cons`函数的最后一个子表达式并非tail context，所以这不是尾递归。可以通过构造辅助函数的方式来将其转换为尾递归：
    ```scheme
    (define (map procedure s)
        (define (map_reverse s m)
            (if (null? s)
                m
                (map_reverse (cdr s)
                             (cons (procedure (car s))
                                    m))))
        (reverse (map_reverse s nil)))
    ```

## Lecture 33: Programs as Data
- Scheme expression分为primitive expression和combination，两者均可以看作是scheme list，例如
    ```scheme
    > (eval (list 'quotient 10 2))
    5
    ```
    所以对于 scheme来说，编写一个“编写程序的程序”很方便。如可以编写一个返回计算阶乘的表达式的函数：
    ```scheme
    (define (fact_exp n)
        (if (= n 0) 1 (list '* n (fact_exp (- n 1)))))
    (define (fact n)
        (eval (fact_exp n)))
    ```

### 准引用(quasiquotation)
- 引用用 `'`表示
- 准引用用`` ` ``表示，它和引用的区别在于，它允许将被引用的表达式中的部分子表达式取消引用（即对部分子表达式求值后再引用）
- 取消引用用`,`表示。
如
```scheme
(define b 4)
'(a ,(+ b 1))   ;结果为(a (unquote (+ b 1)))
`(a ,(+ b 1))   ;结果为(a 5)
```

## Lecture 34: Macros
- 在scheme中，宏(macro)允许在语言中定义新的special form。Macro的工作方式是进行代码转换，所以要通过macro定义新的special form，就需要提取新定义的special form的各部分，将其转换为一般的scheme代码后再进行求值。在scheme中，通过`define-macro`来定义宏，如
    ```scheme
    (define-macro (twice expr)
        (list 'begin expr expr))
    (twice (print 2)) ;会给出(begin (print 2) (print 2))，所以会打印两个2
    ```
此时是先执行macro的主体，再对参数求值；而如果使用 `define`而不是`define-macro`，则会先对`(print 2)`进行求值，变成`(begin 2 2)`，于是只会打印一次2.

## Lecture 35: SQL
- 数据库通常由表格(table)构成，每一列是一组数据（具有一个名称和一个类型）。
- SQL(Structured Query Language，结构化查询语言)是最广泛应用的数据库管理语言，用于从现有的表格中生成新表并操作其内容。
- SQL属于声明式编程语言(declarative language)：程序是对期望结果的描述，解释器负责找出如何生成这个结果（可能有多种方式来执行计算，解释器选择最快的方式）；而python等语言属于命令式语言(imperative language)，程序是对计算过程的描述，解释器对该过程进行执行和评估
- 通过SQL创建新表：`select`创建单行表（从头创建或从已有的表投影得到），`union`将单行表合成为多行表，`create table`语句为表格赋予名称。
    - `select`语句后面跟随一些用逗号分割的列描述(column description，是一个表达式，可以用 `as`指定列名称)；SQL通常作为交互性语言来使用，`select`语句的结果一般不会被存储，而是直接展示给用户，除非使用`create table`语句来赋予名称。
    - `union`语句只能联合有相同列数以及每列中数据类型相同的表，但不需要有相同的列名称，其自动用第一个`select`语句中的列名称来命名。
    ```SQL
    create table cities as
        select 38 as latitude, 122 as longitude, "Berkeley" as name union
        select 42            , 71              , "Cambridge"        union
        select 45            , 93              , "Minneapolis";
    ```
- 从已有表格创建新表（投影表）：`select`语句可以通过`from`从句来指定输入表格（从哪个表格来提取行来构建新表的列，`*`代表选择所有列），而`where`从句可以指定提取表格的列的一个满足特定条件的子集，`order by`从句可以指定这些被提取的行的排序
    ```SQL
    select "west coast" as region, name from cities where longitude >= 115 union
    select "other",              , name from cities where longitude < 115;
    ```
    - `select`语句中可以进行数学运算：
        ```SQL
        create table lift as
            select 101 as chair, 2 as single, 2 as couple;
        select chair, single + 2 * couple as total from lift;
        ```

## Lecture 36: Tables
### Joining tables
- 可以将两个表通过`,`连接，得到的新表具有两个表的所有列，具有的行是两个表所有行的任意组合。
    ```SQL
        select parent from parents, dogs where child = name and fur = "curly"
    ```
- 以上过程假设了连接的两个表不含有相同的列名称，若含有相同的列名称，则需要使用别名(aliases)和`.`operator来消除歧义。可以将一个表与其自身连接：
    ```SQL
    select a.child as first, b.child as second
        from parents as a, parents as b
        where a.parent = b.parent and a.child < b.child;
    ```

## Lecture 37: Aggregation
- 以上只介绍了用SQL对表的单行进行操作，SQL还可以用聚合函数对多行进行聚合(aggregation)。在 `select`语句中使用聚合函数可以从一系列行中求值：
    ```SQL
    select max(legs) from animals
    ```
- 事实上聚合函数只对某个组中的所有行进行聚合。所有行默认在同一个组中，也可以在`select`语句中对行进行分组：
    ```SQL
    select legs, max(weight) from animals group by weight/legs having count(*) > 1
    ```

## Lecture 38: Databases
- 可以在python中通过 `import sqlite3`来执行SQL语句：
    ```python
    import sqlite3
    db = sqlite3.Connection("n.db")
    db.execute("create table numes as select 2 union select 3")
    ```