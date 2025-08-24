# CS61A

## Lecture 2: Functions

### Expression
- Primitive expression: number, name, string, etc.
- Assignment expression: bind value to a name, we can also bind a function to a name
    ```python
    f = max
    f(a,b)
    ```
- Call expression: consist of operator(like name of a function) and operand(like argument/parameter of a function).使用call expression时从左到右依次evaluate operator和operands。

### Function
- funcition definition: def expression
    - function signature: consist of function name and formal parameter

- function calling
    1. add a local frame using the function signature(thus forming a new environment)

        > frame即局部作用域，变量只在内部起作用，全局变量所在的frame称为global frame；environment是许多frame的序列，如在执行某函数`f`时，局部变量所在的environment就是f frame-global frame。某个frame可以谈论其parent frame

    2. bind the formal parameters to the arguments

        > 每个expression都在特定的environment下被evaluate，即在evaluate一个name时，会将其evaluate到当前环境中该name出现的最近的frame中该name的值（即变量只在局部作用域取值）。

- return value
    - 不返回任何value的函数返回 `None`(属于NoneType)
    - 若函数的唯一效果是返回一个value，则称为pure function；若有额外效果，则称为Non-pure function