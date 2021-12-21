# The example allows a user "alice" to create new document in a document repository API
package authz

default allow = false
default anonymus = false

import input.request

action(method) = "read"   { method == "GET" }
action(method) = "create" { method == "POST" }
action(method) = "update" { method == "PUT" }
action(method) = "delete" { method == "DELETE" }

allow {
	not anonymus
    has_permission_to_action
}

has_permission_to_action {
	act := action(request.http.method)
    permission = concat(":", [resource, act])
    glob.match(data.users[creds.username].permissions[_],[], permission)
}

anonymus {
	not basic_token
}

resource := obj {
	obj := split(trim_prefix(request.http.path, "/"), "/")[0]
}

creds := {"username": name} {
	decoded := base64.decode(basic_token)
	[name, _] := split(decoded, ":")
}

basic_token := t {
	v := request.http.headers.authorization
	startswith(v, "Basic ")
	t := substring(v, count("Basic "), -1)
}
