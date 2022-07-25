fn inc(num: *u8) void {
  num.* += 1;
}

test "const pointer ref" {
  const x: u8 = 1;
  var y: u8 = 2;
  inc(&y);
  inc(&x);
}