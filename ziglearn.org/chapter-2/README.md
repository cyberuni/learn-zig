# Ziglearn.org - Chapter 2 - Standard Patterns

<https://ziglearn.org/chapter-2/>

## Allocators

```zig
const allocator = std.heap.page_allocator;

const memory = try allocator.alloc(u8, 100);
defer allocator.free(memory);
```

🖊️ `defer` is used to keep the `free()` call close to `alloc()` call. Making it less error-prone.
