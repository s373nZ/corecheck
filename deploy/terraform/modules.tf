module "api_gateway" {
  source = "./api-gateway"

  s3_bucket   = aws_s3_bucket.corecheck-lambdas-api.id
  db_host     = aws_instance.db.public_ip
  db_port     = 5432
  db_user     = var.db_user
  db_password = var.db_password
  db_database = var.db_database

  dns_name = var.dns_name

  corecheck_data_bucket_url = "https://${aws_s3_bucket.bitcoin-coverage-data.id}.s3.${aws_s3_bucket.bitcoin-coverage-data.region}.amazonaws.com"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }
}

module "compute" {
  source = "./compute"

  db_host     = aws_instance.db.public_ip
  db_port     = 5432
  db_user     = var.db_user
  db_password = var.db_password
  db_database = var.db_database

  github_token          = var.github_token
  corecheck_data_bucket = aws_s3_bucket.bitcoin-coverage-data.id
  corecheck_data_bucket_url = "https://${aws_s3_bucket.bitcoin-coverage-data.id}.s3.${aws_s3_bucket.bitcoin-coverage-data.region}.amazonaws.com"
  corecheck_data_bucket_region = aws_s3_bucket.bitcoin-coverage-data.region

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key

  sonar_token = var.sonar_token
  datadog_api_key = var.datadog_api_key

  lambda_bucket = aws_s3_bucket.corecheck-lambdas.id
  providers = {
    aws.us_east_1 = aws.us_east_1
    aws.compute_region = aws.compute_region
  }
}
