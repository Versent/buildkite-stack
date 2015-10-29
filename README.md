# buildkite-stack

This is a pretty basic buildkite agent stack which starts a fixed number of agents using either on demand or spot pricing.

It is comprised of:

* [AWS Cloudformation](https://aws.amazon.com/cloudformation/)
* [coffer](https://github.com/wolfeidau/coffer)
* [buildkite agent](https://github.com/buildkite/agent)

# usage

* Create a KMS key in the region your using with the alias `coffer`.

* Create an S3 bucket to hold the coffer files.

* Setup an ssh key and put it in your coffer file.

```yaml
files:
  "/var/lib/buildkite-agent/.ssh/id_rsa":
    mode: 0600
    content: |
        -----BEGIN RSA PRIVATE KEY-----
        ...
        -----END RSA PRIVATE KEY-----
```

* Encrypt and upload the coffer file

```
AWS_PROFILE=XX AWS_REGION=ap-southeast-2 coffer --coffer-file buildkite.coffer upload --bucket="XX-buildkite-coffers"
```

* Run the create stack passing in the required parameters.

```
AWS_DEFAULT_PROFILE=XX AWS_DEFAULT_REGION=ap-southeast-2 ./create-stack \
    Subnets="subnet-XX,subnet-XX" AMIID="ami-XX" CofferKeyARN="arn:aws:kms:ap-southeast-2:XXX:key/XXX" \
    AgentToken="XXX" ArtifactsS3BucketName="XX-buildkite-artifacts" \
    "CofferS3BucketName="XX-buildkite-coffers" VpcId=vpc-XX
```

# todo

* Add cloudwatch logs
* Add [docker-gc](https://github.com/spotify/docker-gc)
