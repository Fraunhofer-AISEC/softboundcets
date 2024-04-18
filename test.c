#include "stdio.h"
#include "stdlib.h"

int main(void) {

  int *a = malloc(sizeof(int) * 5);

  // for a spatial memory violation
  /* printf("%x\n", a[-1]); */

  free(a);

  for (int i = 0; i < 5; ++i)
	printf("%x\n", a[i]);

  return 0;
}
