This repository is for getting APNs (Apple Push Notification service) certificates for, e.g., push email notifications on iOS. The certificate generation function has become unavailable on modern systems (typically requiring keeping an old VM around), so this project seeks to make it easier.

# Requirements

* macOS (tested on Catalina) and the macOS Server app 5.10 from Mac App Store

# Creating the certificate requests

1. Install macOS Server 5.10
1. Configure
	* `echo -n yourHostName > config/hostname` (the hostname you give here is displayed in the certificates portal webpage)
	* `echo -n yourAppleID@example.com > config/username` (you should probably use one you've purchased macOS Server with, but I haven't tried whether they require that)
	* `openssl dgst -sha256 -binary | xxd -p -c 32 > config/passwdhash # type your password, then Ctrl-D Ctrl-D`
1. Run `make request-body`. You should sanity-check the contents compared to test/expected/request-body.

# Sending your certificate request

```
curl -i --data-binary @request-body -H 'Content-Type: text/x-xml-plist' --user-agent 'Servermgrd%20Plugin/6.0 CFNetwork/811.11 Darwin/16.7.0 (x86_64)' https://identity.apple.com/pushcert/caservice/new -H 'Accept: */*' -H 'Accept-Language: en-us' | tee response
```

Your certificates should be in the file `response`. The private keys are in the `keys` directory.

Manage your certificates at https://identity.apple.com/pushcert/ .
