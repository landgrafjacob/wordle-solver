# wordle-solver

This repo contains the backend for a wordle solver website (hosted at [solvethewordle.com](solvethewordle.com)).

## Components

| File                             | Description                                                                                                                            |
|----------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| `providers.tf`                   | Set up AWS providers                                                                                                                   |
| `locals.tf`                      | Local variables used throughout the project                                                                                            |
| `api_gateway.tf`                 | API Gateway to expose Lambda functions                                                                                                 |
| `lambda_*.tf`                    | The Lambda functions set up behind the API Gateway                                                                                     |
| `s3_data_bucket.tf`              | S3 bucket to store data objects needed by Lambda functions                                                                             |
| `s3_website_bucket.tf`           | S3 bucket to store frontend code (contained in the [wordle-solver-app](https://github.com/landgrafjacob/wordle-solver-app) repository) |
| `cloudfront.tf`                  | Cloudfront distribution to route traffic to S3 site/API Gateway                                                                        |
| `route53.tf`                     | Route53 record to set up custom domain                                                                                                 |
| `data/populate_freqencies.py`    | Script to generate letter freq object used by POST /recommendation function                                                            |
| `data/wordlist.txt`              | List of all possible Wordle words, returned by GET /wordlist endpoint                                                                  |
| `python/`                        | Folder containing the code for the Lambda functions                                                                                    |
| `.github/workflows/pipeline.yml` | GitHub Action to deploy Terraform to AWS Account                                                                                       |

## Local Deployment

In order to test locally, you need:
* Terraform
* Python
* AWS credentials

To test deploying the resources locally, set your AWS credentials

```
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export AWS_SESSION_TOKEN=""
```

and run Terraform as usual

```
terraform init
terraform plan
terraform apply
```

Currently, there is only one environment, so every deployment will overwrite the resources in production.

## Challenges
In the future, the following would be nice to implement:
* Separate environments (i.e. dev and prod). Pushes to test branches could deploy to dev, and then merges to main will deploy to production.
* Unit/Integration tests
* Automatically push domain to wordle-solver-app repo secret and trigger build
