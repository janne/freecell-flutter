class Generator {
  int state;

  Generator(this.state);

  int next() {
    state = (214013 * state + 2531011) & 0x7fffffff;
    return state >> 16;
  }
}
