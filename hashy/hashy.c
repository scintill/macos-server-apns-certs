#include <fcntl.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <dlfcn.h>

struct signature_in {
	uint64_t _a;
	uint32_t _b;
	uint16_t _c;
	uint8_t _d;
	char sha1_hash[20];
} __attribute__ ((packed));

#define SUPPRESS_DLOPEN_ERRORS

int main(int argc, char *argv[]) {

#ifdef SUPPRESS_DLOPEN_ERRORS
	int savedStderr = dup(2);
	close(2);
#endif
	void *dlh = dlopen("@executable_path/servermgr_certs", 0);
#ifdef SUPPRESS_DLOPEN_ERRORS
	dup2(savedStderr, 2);
	close(savedStderr);
#endif

	if (!dlh) {
		dprintf(2, "dlopen error = %s\n", dlerror());
	}
	dprintf(2, "dlh = %p\n", dlh);
	uint32_t (*signerFunc)(struct signature_in*, uint64_t, void*, uint64_t*, void*, uint64_t*) = dlsym(dlh, "OBJC_CLASS_$_CertsRequestHandler") + atoll(getenv("SYMBOL_DELTA"));
	dprintf(2, "signerFunc = %p\n", signerFunc);

	struct signature_in signature_in = {
		._a = 0xe2b050609302130, ._b = 0x51a0203, ._c = 0x400, ._d = 0x14,
	};

	ssize_t numRead = 0;
	do {
		ssize_t n = read(0, &signature_in.sha1_hash[numRead], sizeof(signature_in.sha1_hash) - numRead);
		if (n < 0) {
			dprintf(2, "read error\n");
			return 1;
		}
		numRead += n;
		sleep(1); // go easy on the CPU in case we loop a lot for some reason
	} while (numRead < 20);

	char certSignatureBytes[256];
	char certchain[4000];
	uint64_t certSignatureBytesSize = sizeof(certSignatureBytes), certchainSize = sizeof(certchain);

	uint32_t result = signerFunc(&signature_in, sizeof(signature_in), certSignatureBytes, &certSignatureBytesSize, certchain, &certchainSize);
	dprintf(2, "result = %x\n", result);
	if (result) {
		return 1;
	}

	if (argv[1][0] == '0') {
		write(1, certchain, certchainSize);
	} else {
		write(1, certSignatureBytes, certSignatureBytesSize);
	}

	return 0;
}
