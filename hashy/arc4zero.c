#include <stdlib.h>

uint32_t my_arc4random(void) {
	return 0;
}

__attribute__((used)) static struct {
    void *replacement, *replacee;
}
__interpose[] __attribute__ ((section ("__DATA, __interpose"))) = {
	{ my_arc4random, arc4random }
};
