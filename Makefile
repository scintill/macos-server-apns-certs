request-body: PushCertCertificateChain PushCertSignature
	( \
		printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n" ;\
		printf "<plist version=\"1.0\">\n<dict>\n" ;\
		printf "	<key>PushCertCertificateChain</key>\n	<data>\n" ;\
		base64 -w68 PushCertCertificateChain | sed s/^/'	'/ ;\
		printf "	</data>\n	<key>PushCertRequestPlist</key>\n	<data>\n" ;\
		base64 -w68 PushCertRequestPlist | sed s/^/'	'/ ;\
		printf "	</data>\n	<key>PushCertSignature</key>\n	<data>\n" ;\
		base64 -w68 PushCertSignature | sed s/^/'	'/ ;\
		printf "	</data>\n	<key>PushCertSignedRequest</key>\n	<true/>\n" ;\
		printf "</dict>\n</plist>\n" ;\
	) > $@

PushCertCertificateChain: chosenVendorCert
	cp chosenVendorCert/chain $@

PushCertSignature: PushCertRequestPlist chosenVendorCert
	openssl sha1 -sign chosenVendorCert/key -keyform der -out $@ $<

chosenVendorCert:
	ln -s $$(ls -1d vendorcerts/* | shuf -n 1) $@

PushCertRequestPlist: csrs/com.apple.servermgrd.apns.calendar csrs/com.apple.servermgrd.apns.contact csrs/com.apple.servermgrd.apns.mail csrs/com.apple.servermgrd.apns.mgmt csrs/com.apple.server.apns.alerts config/username config/hostname
	( \
		printf "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n" ;\
		printf "<plist version=\"1.0\">\n<dict>\n" ;\
		printf "	<key>Header</key>\n	<dict>\n" ;\
		printf "		<key>ClientApplicationCredential</key>\n" ;\
		printf "		<string>1</string>\n" ;\
		printf "		<key>ClientApplicationName</key>\n" ;\
		printf "		<string>XServer</string>\n" ;\
		printf "		<key>ClientIPAddress</key>\n" ;\
		printf "		<string>1</string>\n" ;\
		printf "		<key>ClientOSName</key>\n" ;\
		printf "		<string>MAC OSX</string>\n" ;\
		printf "		<key>ClientOSVersion</key>\n" ;\
		printf "		<string>2.1</string>\n" ;\
		printf "		<key>LanguagePreference</key>\n" ;\
		printf "		<string>1</string>\n" ;\
		printf "		<key>TransactionId</key>\n" ;\
		printf "		<string>1</string>\n" ;\
		printf "		<key>Version</key>\n" ;\
		printf "		<string>1</string>\n" ;\
		printf "	</dict>\n" ;\
		printf "	<key>Request</key>\n" ;\
		printf "	<dict>\n" ;\
		printf "		<key>CertRequestList</key>\n" ;\
		printf "		<array>\n" ;\
		\
		\
		printf "			<dict>\n" ;\
		printf "				<key>CSR</key>\n" ;\
		printf "				<string>" ;\
		cat csrs/com.apple.servermgrd.apns.calendar ;\
		printf "</string>\n" ;\
		printf "				<key>CertRequestNo</key>\n" ;\
		printf "				<integer>0</integer>\n" ;\
		printf "				<key>Description</key>\n" ;\
		printf "				<string>$(shell cat config/hostname) - apns:com.apple.calendar</string>\n" ;\
		printf "				<key>ServiceType</key>\n" ;\
		printf "				<string>Service_Calendar</string>\n" ;\
		printf "			</dict>\n" ;\
		\
		printf "			<dict>\n" ;\
		printf "				<key>CSR</key>\n" ;\
		printf "				<string>" ;\
		cat csrs/com.apple.servermgrd.apns.contact ;\
		printf "</string>\n" ;\
		printf "				<key>CertRequestNo</key>\n" ;\
		printf "				<integer>1</integer>\n" ;\
		printf "				<key>Description</key>\n" ;\
		printf "				<string>$(shell cat config/hostname) - apns:com.apple.contact</string>\n" ;\
		printf "				<key>ServiceType</key>\n" ;\
		printf "				<string>Service_Contact</string>\n" ;\
		printf "			</dict>\n" ;\
		\
		printf "			<dict>\n" ;\
		printf "				<key>CSR</key>\n" ;\
		printf "				<string>" ;\
		cat csrs/com.apple.servermgrd.apns.mail ;\
		printf "</string>\n" ;\
		printf "				<key>CertRequestNo</key>\n" ;\
		printf "				<integer>2</integer>\n" ;\
		printf "				<key>Description</key>\n" ;\
		printf "				<string>$(shell cat config/hostname) - apns:com.apple.mail</string>\n" ;\
		printf "				<key>ServiceType</key>\n" ;\
		printf "				<string>Service_Mail</string>\n" ;\
		printf "			</dict>\n" ;\
		\
		printf "			<dict>\n" ;\
		printf "				<key>CSR</key>\n" ;\
		printf "				<string>" ;\
		cat csrs/com.apple.servermgrd.apns.mgmt ;\
		printf "</string>\n" ;\
		printf "				<key>CertRequestNo</key>\n" ;\
		printf "				<integer>3</integer>\n" ;\
		printf "				<key>Description</key>\n" ;\
		printf "				<string>$(shell cat config/hostname) - apns:com.apple.mgmt</string>\n" ;\
		printf "				<key>ServiceType</key>\n" ;\
		printf "				<string>Service_Mgmt</string>\n" ;\
		printf "			</dict>\n" ;\
		\
		printf "			<dict>\n" ;\
		printf "				<key>CSR</key>\n" ;\
		printf "				<string>" ;\
		cat csrs/com.apple.server.apns.alerts ;\
		printf "</string>\n" ;\
		printf "				<key>CertRequestNo</key>\n" ;\
		printf "				<integer>4</integer>\n" ;\
		printf "				<key>Description</key>\n" ;\
		printf "				<string>$(shell cat config/hostname) - apns:com.apple.alerts</string>\n" ;\
		printf "				<key>ServiceType</key>\n" ;\
		printf "				<string>Service_Alerts</string>\n" ;\
		printf "			</dict>\n" ;\
		\
		\
		printf "		</array>\n" ;\
		printf "		<key>ProfileType</key>\n" ;\
		printf "		<string>Production</string>\n" ;\
		printf "		<key>RequesterType</key>\n" ;\
		printf "		<string>XServer</string>\n" ;\
		printf "		<key>User</key>\n" ;\
		printf "		<dict>\n" ;\
		printf "			<key>AccountName</key>\n" ;\
		printf "			<string>$(shell cat config/username)</string>\n" ;\
		printf "			<key>PasswordHash</key>\n" ;\
		printf "			<string>$(shell cat config/passwdhash)</string>\n" ;\
		printf "		</dict>\n" ;\
		printf "	</dict>\n" ;\
		printf "</dict>\n</plist>\n" ;\
	) > $@

csrs/%: keys/%
	mkdir csrs || true
	openssl req -batch -new -key $< -sha1 -subj /CN=$(shell basename $@)/C=US -out $@

.PRECIOUS: keys/%
keys/%:
	mkdir keys || true
	openssl genrsa -out $@ 2048

.PHONY: clean
clean:
	rm -f PushCertCertificateChain PushCertRequestPlist PushCertSignature csrs/* keys/* chosenVendorCert request-body

.PHONY: test
test: request-body
	@cat expected/$< | md5sum
	@cat $< | md5sum
