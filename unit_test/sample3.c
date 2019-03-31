int system_start(int argc, int data, str msg)
{
  double a;
  a = 12.1234;
  a = 2E2;
  a = 1.23e+32;
  a = 2.44E-12;
  a = -12.1234;
  a = 0.01234;

  string g;
  g = "asdf \
  asdf";

  /* this goes high... 
   * yay! multilined comment!
   */
  if (a > 12) {
    str b = "abcd";
    print(b);
  }
  else {
    str c;
    int f;

    // abcd will be stored to symbol c
    c = "abcd";
    f = 1234567890123;

    while (a > b) {
      f = f + 1;
    }

    a = a / b;

    if (a >= b) {
      c = a - b;
    }
    
    if (b < c) {
      f = a * b;
    }

    if (c <= f) {
      b = a / b;    
    }
    else {
      while (a == b) {
        b = b - 1;
      }

      while (a != c) {
        c = c - 1;
      }

      return 1;
    }
  }

  return 0;
}