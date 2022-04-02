## 1. 简介

## 2. 环境配置

## 3. 程序设计实例

####  Hello world!

```rust
/*
    File hello.rs
    This is the comment block  
*/
// The comment can also use "//"

fn main() { 
    let s = "hello world!"; 
    println!("{}", s); 
}

// To run the program, key in "rustc hello.rs"
```



#### 输出宏的使用

```rust
/*
    Filr name: print.rs
    This is the test for println!
*/

fn main() {
    let x1 = 5;
    println!("{}", 1);
    // Display something

    println!("{:o}", 10);
    println!("{:x}", 10);
    println!("{:X}", 10);
    println!("{:b}", 10);
    // Print numbers

    println!("{:e}", 200f32);
    println!("{:E}", 200f32);
    // Scientific notation 

    println!("{:p}", &0);
    // Pointer
    // Display the number at [0]

    println!("{:?}", "test");
    // Debuger
    // Print "test"

    println!("{:#?}", ("test1", "test2"));

    println!("x1 = {:?}", x1);

}
```





#### 变量声明

```rust
/*
    File name: variable.rs
    This is the program testing for variables
*/

fn main() {
    let number: i32 = 100;
    // Create a read-only variable [number]
    // "i32" is the type 32-bit integer
    // number = 1000; ERROR!
    

    let number1: i32;
    number1 = 10;
    // This is the initialization for number1
    // Not the assignment
    // So is OK!

    // The variables without initialization can not be used!
    // e.g [error: use of possibly uninitialized variable: `number1`] 

    println!("{:?}", "Test for mut");
    let mut newnumber = 10;  
    println!("Before change, the newnumber is initializaed as: {}", newnumber);
    // Create a changeable variable
    // The type can be omitted(省略)
    newnumber = 20;
    println!("Now the newnumber is: {}", newnumber);


    let (mut x, mut y) = (1, 2);
    // You can declare several variables by one sentence
}
```



#### 函数

```rust
/*
    File name: func.rs
    This is the test for functions use
*/
fn add(num1: i32, num2: i32) -> i32 {
    num1 + num2
}

fn justprint() {
    println!("Hi~");
}

fn main() {
    let sum;
    let (mut num1, mut num2) = (2, 6);
    sum = add(num1, num2);

    println!("{:?}", "Test for func [add]");
    println!("{} + {} = {}", num1, num2, sum);
    justprint();
}
```





####  static 关键字

```rust
/*
    File name: static_variable.rs
    Tset for static variables
*/

static global_zero: i32 = 0;
// The static variable should be initialized as soon as declaration.

fn f1(num: i32)->i32 {
    return num * global_zero;
}

static mut global_var: i32 = 100;
// Anytime when read or write a changeable static variable,
// Use unsafe {}.

fn f2() {
    unsafe {
        global_var = global_var + 1;
    }
}

fn main() {
    let mut number = 123;
    println!("f1: {}", f1(number));
    f2();
    unsafe {
        println!("f2: Now the global_var is: {}", global_var);
    }
}

```

