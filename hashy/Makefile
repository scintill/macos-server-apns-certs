CROSSBUILD := sudo docker run -t --rm -v $$(pwd):/workdir -e CROSS_TRIPLE=x86_64-apple-darwin multiarch/crossbuild

hashy: hashy.macho random_zero.so maloader/Dockerfile symbolDelta
	sudo docker build -t maloader maloader
	printf '#!/bin/sh\ncd $$(basename $$0)\nexec sudo docker run -i --rm -v $$(pwd):/workdir maloader env LD_PRELOAD=./random_zero.so SYMBOL_DELTA=$(shell cat symbolDelta) ld-mac hashy.macho $$*\n' > $@
	chmod u+x hashy

hashy.macho: hashy.c
	$(CROSSBUILD) cc -g -o $@ $<

random_zero.so: random_zero.c
	cc -shared -o $@ $<

symbolDelta: signerFunc CertsRequestHandler
	echo ibase=16\; $(shell cat signerFunc | tr '[:lower:]' '[:upper:]') - $(shell cat CertsRequestHandler | tr '[:lower:]' '[:upper:]') | bc > $@

signerFunc: signedPushRequestDictionaryWithUnsignedPushRequestDictionary
	$(CROSSBUILD) otool -tvV servermgr_certs | grep -m1 -A300 '^0*$(shell cat signedPushRequestDictionaryWithUnsignedPushRequestDictionary)\s' | grep -m1 -B300 '\sretq' | grep -m5 call | tail -n1 | cut -f3 | sed s/0x// > $@

signedPushRequestDictionaryWithUnsignedPushRequestDictionary: servermgr_certs
	$(CROSSBUILD) otool -o $< | grep -A2 -m1 $@ | tail -n1 | tr -s ' ' | cut -d' ' -f3 | sed s/0x// > $@

CertsRequestHandler: servermgr_certs
	$(CROSSBUILD) dyldinfo -export $< | grep '_OBJC_CLASS_\$$_CertsRequestHandler' | cut -d' ' -f1 | sed s/0x// > $@

.PHONY: clean
clean:
	rm -f hashy hashy.macho random_zero.so symbolDelta signerFunc signedPushRequestDictionaryWithUnsignedPushRequestDictionary CertsRequestHandler
