hashy: hashy.macho random_zero.so maloader/Dockerfile
	sudo docker build -t maloader maloader
	printf '#!/bin/sh\ncd $$(basename $$0)\nexec sudo docker run -i --rm -v $$(pwd):/workdir maloader env LD_PRELOAD=./random_zero.so ld-mac hashy.macho $$*\n' > $@
	chmod u+x hashy

hashy.macho: hashy.c
	sudo docker run -it --rm -v $$(pwd):/workdir -e CROSS_TRIPLE=x86_64-apple-darwin multiarch/crossbuild cc -g -o $@ $<

random_zero.so: random_zero.c
	cc -shared -o $@ $<
