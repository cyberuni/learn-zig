# Ziglearn.org - Chapter 1 - Basics

<https://ziglearn.org/chapter-1/>

## Assignment

> `(const|var) identifier[: type] = value`.
> `const`: constant
> `var`: variable
> `: type`: can be omitted if the data type of `value` can be inferred

❓ how far can the inference go?

```zig
const constant: i32 = 5;  // signed 32-bit constant
var variable: u32 = 5000; // unsigned 32-bit variable

// @as performs an explicit type coercion
const inferred_constant = @as(i32, 5);
var inferred_variable = @as(u32, 5000);
```

❓ `@as(...)`: language supplied function?

❗ `@as(i32, 5)`: `i32` is both a type and a value.

```zig
const a: i32 = undefined;
var b: u32 = undefined;
```

❗ `undefined`: coerces to any type. ❓ initialize value to 0?
❓ How about `null`?
💡 `rust` does not have null.

## Arrays

> `[N]T`

This looks weird, but make it slightly closer to `identifier: type` syntax.

Initialize array:

> `[5]u8{ 'h', 'e', 'l', 'l', 'o' }`
> `[_]u8{...}` shortcut to infer array size.

## If

`if (a) { } else { };` can be an expression, like `rust`.

## While

Form:

```zig
while (condition)[: (continue expression)] {
  block
}
```

e.g.:

```zig
while (i < 100) {
  i += 2;
}

while (i <= 5): (i += 1) {
  if (i == 2) continue;
  if (i == 3) break;
  sum += i;
}
```

It combines `while` and `for` in other languages.

## For

The `for` in `zig` is the `for-in` and `for-of` in JavaScript.
Iterate over iterable:

```zig
for (iterable) |value, index| {
  block
}
```

## Functions

Function arguments are immutable.

Zig use `snake_case` for variables and `camelCase` for functions.

> Values can be ignored by using `_` in place of a variable.
> `_ = index`

✏️ It probably not using `_variable` convention as that is often used for private variable in C/C++.

## Defer

```zig
var x: f32 = 5;
{
  defer x += 2;
  defer x /= 2; // executed first
}
try expect(x == 4.5)
```

🖊️ Don't know what is the usage of this yet.

## Errors

> An error set is like an enum

```zig
const FileOpenError = error{
    AccessDenied,
    OutOfMemory,
    FileNotFound,
};
```

🖊️ the error set (enum) is both a value and a type: `const X = error{...};` vs `const y: X!u16 = 0;`

> An error set type and a normal type can be combined with the `!` operator to form an error union type. Values of these types may be an error value, or a value of the normal type.

🖊️ The language support this error union type. `const maybe_error: AllocationError!u16 = ...;`

> `const no_error = maybe_error catch 0;`

🖊️ Like the `unwrap_or()` in `rust`

Payload capturing:

```zig
failingFunction() catch |err| {
  // do something with `err`
}
```

🖊️ This is not lambdas. Looks similar to `function () use (...) {...}` in PHP.

> `try x` is a shortcut for `x catch |err| return err`

🖊️ it creates the error unions

```zig
fn failFn() error{Oops}!i32 {
  try failingFunction();   // return `err`
  return 12;               // return `i32`
}
```

> `errdefer` works like `defer`, but executing if the function returns an error

```zig
fn failFnCounter() error{Opps}!void {
  errdefer problems += 1;
  try failingFuntion();
}
```

🖊️ This feels like writer monads. And it tries to provide a way to mimic the `err:` label in C:

```c
function foo() {
  if (somethingIsWrong) goto err;
  err:
    // handle error clean up
  done:
    return;
}
```

> error set can be inferred: `function createFile() !void { ... }`
>
> Error sets can be merged: `const C = A || B;`
>
> `anyerror` is the superset of all errors. Usage should be avoided.

## Switch

`switch` can be an expression, like `rust`:

```zig
switch (subject) {
  // range
  -1...1 => {
    // block
  },
  // oneof
  10, 100 => {
    // block
  },
  else => {
    // block
  }
}
```
