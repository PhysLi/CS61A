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