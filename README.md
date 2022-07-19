# Learn Zig

[Zig](https://ziglang.org) is a general purpose language.

It has some features that I like to understand more about:

- No hidden control flow: how to handle try-catch
- No hidden memory allocations
- No preprocessor
- No Macros (`rust`!)
- No operator overloading: how to organize code and do polymorphism?
- Has `undefined`, but no `null pointers`
  - `Optional` is a built-in feature of the language (`@intToPtr(?*i32, 0x0)`)
  - `orelse` keyword

## Notes

- [ziglearn.org](./ziglearn.org/)
