## kong-opa-example

This responsitory contains a simple example how to integrate [Kong](https://konghq.com/) and [Open Policy Engine](https://www.openpolicyagent.org/) using `kong-opa-pass` plugin.

## Description

    TODO: describe why there is a need to use OPA and how it helps solve problems in the modern microservice architecture

In the era where cloud applications and microservice architecture are dominating the software engineering world, it is important to stay up-to-date with the modern trends.

[Kong](https://konghq.com/) is Cloud-Native API Gateway. [CNCF silver member](https://landscape.cncf.io/?selected=kong&zoom=150). [OPA](https://www.openpolicyagent.org/) is General-Purpose Policy Engine. [CNCF Graduated Project](https://landscape.cncf.io/?selected=open-policy-agent-opa&zoom=150)

## Example

    TODO: add graphic schema how the integration works and step by step instruction/docker + docker compose


OPA lets you make context-aware authorization and policy decisions by injecting external data and then writing policy using that data. For instance, the data could be a list of roles and permissions that policy could use to authorize the request coming from the web application.
There are many different approaches how to delivering policies and data to the OPA, all of them could be found in [OPA docs](https://www.openpolicyagent.org/docs/latest/external-data/). In this example, I use [OPA's Bundle API](https://www.openpolicyagent.org/docs/latest/external-data/#option-3-bundle-api) for injecting the policy and external data into the OPA server. There are different approaches how to delivering the context to the OPA.

### Policy

The policy in this example does the following:
1. It verifies that the incoming request is authorized by checking the presents of `Basic` token in the `authorization` header
2. It extracts the username out of the token
3. It validates that the user has a relevant permission for the requested resource

For this policy to work properly it must have an access to a list of user permissions that, in the `real-world` would come from a database or a configuration file. In this example we distribute that data in a `data.json` file inside a bundle along with a policy file. For other options refer to [OPA docs](https://www.openpolicyagent.org/docs/latest/external-data/)

## Prerequisites



### Create Bundle File

Before starting OPA server we need to create a bundle file. Just run the command:

```bash
make bundle
```

It should create `authz.tar.gz` file and place it in `./bundles` folder where it will loaded from by the `bundler` service.

### Start

Run following command 

## How It Works

We start by running a `bundler` service. This service uses `nginx` under the hood and has just one purpose is to serve the `authz.tar.gz` file. This file OPA pulls immediately after it is started and loads a policy and data file up into memory.

We can verify that by just making a request to they REST API.

Let's try download a `bundle` file. Run this command:

```bash
curl -RO  http://localhost:8080/bundles/authz.tar.gz
```

If all done right you should see `authz.tar.gz` file been downloaded into your directory. Run this comand to check that it's containing our policy and data file.

```bash
tar -tf ./authz.tar.gz
```
```bash
./
./authz.rego
./users/
./users/data.json
```

Now, lets check that OPA successfully applied that data. Run this command to retrive users:

```bash
curl http://localhost:8181/v1/data/users
```

The output should be something like that

```json
{"decision_id":"057aa3e3-266c-48b1-81fb-0c22c4be42fd","result":{"alice":{"permissions":["documents:*"]},"bob":{"permissions":["documents:read"]}}}
```

Next command checks that the policy is in place and ready for action:

```bash
curl -XPOST http://localhost:8181/v1/data/authz
```

The Output should be something like that

```json
{"decision_id":"31a94c14-02b6-4924-b1c5-e72b94f24b3f","result":{"allow":false,"anonymus":true}}
```

Use commands `make alice-request` and `make bob-request` to pass the entire payload object to the policy to see the permissive output.

