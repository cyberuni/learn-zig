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

## Runtime Safety

Can be turned on or off.
Should turn on for dev and test,
may turn off during production.

## Unreachable

Explicitly saying certain branch are not reachable:

```zig
if (x == 2) 5 else unreachable;
```

Optimizer can take advantage of it.

## Pointers

> Normal pointers in Zig aren’t allowed to have 0 or null as a value.

🖊️ same as `rust`, also means there is `null` in `zig`.

> `&x`: Referencing
> `x.*`: Dereferencing

```zig
fn inc(num: *u8) {
  num.* += 1;
}
```

🖊️ `zig` will detect if the pointer is mutable:

```zig
const x: u8 = 1;
var y = &x;
y.* += 1; // error: cannot assign to constant
```

🖊️ Compiler detects `const` pointer correctly:

```zig
const x: u8 = 1;
var y: u8 = 2;

fn inc(num: *u8) {
  num.* += 1;
}

inc(&y) // ok
inc(&x) // error: expected type '*u8', found '*const u8'
```

## Pointer sized integers

```zig
try expect(@sizeOf(usize) == @sizeOf(*u8));
try expect(@sizeOf(isize) == @sizeOf(*u8));
```

## Many-Item Pointers

🖊️ pointer to array: `[*]T`

## Slices

> Slices can be thought of as a pair of `[*]T` (the pointer to the data) and a `usize` (the element count). Their syntax is given as `[]T`, with `T` being the child type.

```zig
fn total(values: []const u8) usize {
  var sum: usize = 0;
  for (values) |v| sum += v;
  return sum;
}
test "slices" {
  const array = [_]u8{ 1, 2, 3, 4, 5 };
  const slice = array[0..3];
  try expect(total(slice) == 6);
}
```

🖊️ Sounds similar to `&str` in `rust`, but for `array` in general.

## Enums

```zig
const Direction = enum { north, south, east, west };

// typed
const Value = enum(u2) { zero, one, two };

// specific values
const Value2 = enum(u32) {
    hundred = 100,
    thousand = 1000,
    million = 1000000,
    next,
};

// with methods
const Suit = enum {
    clubs,
    spades,
    diamonds,
    hearts,
    pub fn isClubs(self: Suit) bool {
        return self == Suit.clubs;
    }
};

// static values
const Mode = enum {
    var count: u32 = 0;
    on,
    off,
};

test "hmm" {
    Mode.count += 1;
    try expect(Mode.count == 1);
}
```

🖊️ looks very similar to the `enum` in `rust`

## Structs

> `struct` in-memory order and size are not guaranteed.
> Constructed with `T{}`

```zig
const Vec3 = struct {
    x: f32, y: f32, z: f32
};

test "struct usage" {
    const my_vector = Vec3{
        .x = 0,
        .y = 100,
        .z = 50,
    };
    _ = my_vector;
}
```

> All fields must be given a value,
> unless the fields have defaults

```zig
const Vec4 = struct {
  x: f32 = 0
  w: f32 = undefined
}
```

🖊️ um... `undefined` is a valid default.

> Struct can also contain functions and declarations
> Support one level auto dereferencing

```zig
fn swap(obj: *Stuff) void {
  const tmp = obj.x;
  obj.x = obj.y;
  obj.y = tmp;
}
```

## Unions

```zig
const Result = union {
    int: i64,
    float: f64,
    bool: bool,
};

test "simple union" {
    var result = Result{ .int = 1234 };
    result.float = 12.34; // error: access of inactive union field
}
```

> Tagged unions are unions which use an enum to detect which field is active.

```zig
const Tag = enum { a, b, c };

const Tagged = union(Tag) { a: u8, b: f32, c: bool };

test "switch on tagged union" {
  var value = Tagged{ .b = 1.5 };
  switch (value) {
    .a => |*byte| byte.* += 1,
    .b => |*float| float.* *= 2,
    .c => |*b| b.* = !b.*,
  }
  try expect(value.b == 3);
}
```

> The tag type can be inferred

```zig
const Tagged = union(enum) { a: u8, b: f32, c: bool };

// `none` is typed `void`
const Tagged2 = union(enum) { a: u8, b: f32, c: bool, none };
```

## Optionals

```zig
var a: ?u32 = null;
var b = a orelse 0;

var c = a orelse unreachable;
// shorthand
var c = a.?;
```

## Comptime

> Blocks of code may be forcibly executed at compile time using the `comptime` keyword.

```zig
var x = comptime fibonacci(10);
```

> `comptime_int`, `comptime_float`: literal types
>
> Types in Zig are values of the type `type`.

```zig
// executed at compile time
const b = if (a < 10) f32 else i32 = 5;
```

🖊️ this is likely part of how `zig` handle macro use cases.

> `PascalCase` function returns a type.

```zig
fn Matrix(
    comptime T: type,
    comptime width: comptime_int,
    comptime height: comptime_int,
) type {
    return [height][width]T;
}

test "returning a type" {
    try expect(Matrix(f32, 4, 4) == [4][4]f32);
}
```

❗ Type as value, compile time type-level programming

> Returning a struct type is how you make generic data structures in Zig.

```zig
fn GetBiggerInt(comptime T: type) type {
    return @Type(.{
        .Int = .{
            .bits = @typeInfo(T).Int.bits + 1,
            .signedness = @typeInfo(T).Int.signedness,
        },
    });
}

test "@Type" {
    try expect(GetBiggerInt(u8) == u9);
    try expect(GetBiggerInt(i31) == i32);
}
```

> Use `@Type` to create type form `@typeInfo`.

🖊️ the example above uses anonymous struct syntax: `.{}` as the type `T{}` is inferred.

> Use `const Self = @This();` to get the self type.

Infer type using `anytype` + `@TypeOf`:

```zig
fn plusOne(x: anytype) @TypeOf(x) {
    return x + 1;
}

test "inferred function parameter" {
    try expect(plusOne(@as(u32, 1)) == 2);
}
```

> `++`: concatenate arrays and slices
> `**`: repeat arrays and slices
> Only work in compile time

🖊️ Probably just for convenience. It's just as easy to do `@concat()` and `@repeat()`.

## Payload Captures

> Payload capture is used to "capture" the value from something.


```zig
var maybe_x: ?usize = ...;
if (maybe_x) |n| {
  // block
}

var ent_num: error{UnknownEntity}!u32 = ...;
if (ent_num) |entity| {
} else |err| {
}
```

🖊️ it tries to make `Options` part of the language. Which is fine for that usage. But the others like for loop, switch, seems like just trying to use that syntax form when available.
It feels a bit unnecessary.

## Opaque

Basically a nominal `dynamic` struct.

## Sentinel Termination

🖊️ Provide a way to terminate an array or slices with a different terminate value.

## Vectors

Vector types of SIMD. Can contain only booleans, integers, floats, and pointers.
