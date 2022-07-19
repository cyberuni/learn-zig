# Ziglearn.org - Chapter 1 - Basics

> Assignment: `(const|var) identifier[: type] = value`.

Pretty straightforward.
`var` is mutable.

`: type` can be omitted if the data type of `value` can be inferred

❓ how far can the inference go?

```zig
const constant: i32 = 5;  // signed 32-bit constant
var variable: u32 = 5000; // unsigned 32-bit variable

// @as performs an explicit type coercion
const inferred_constant = @as(i32, 5);
var inferred_variable = @as(u32, 5000);
```

❓ `@as(...)` language supplied function

❗ `@as(i32, 5)` `i32` is both a type and a value.

```zig
const a: i32 = undefined;
var b: u32 = undefined;
```

❗ `zig` uses `undefined`.
❓ How about `null`?
💡 `rust` does not have null.

## Arrays

`[N]T`

This looks weird, but make it slightly closer to `idenfiter: type` syntax.

## If

`if (a) { } else { ]` can be an expression, like `rust`.

## While

