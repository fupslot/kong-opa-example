BUNDLE_NAME:=authz.tar.gz

.PHONY: bundle
bundle:
	rm -rf ./bundles/*
	tar -czf ./bundles/${BUNDLE_NAME} -C ./policy .
	tar -tf ./bundles/${BUNDLE_NAME}
bob-request:
	curl -XPOST -d @./test/bob.req.json -H"Content-Type: application/json" http://localhost:8181/v1/data/authz
alice-request:
	curl -XPOST -d @./test/alice.req.json -H"Content-Type: application/json" http://localhost:8181/v1/data/authz