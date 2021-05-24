# IGOR CHUCHMAN IT-13

module "frontend" {
  source  = "./modules/s3/eu-central-1"
  context = module.base_labels.context
  name    = "frontend"
  #   marketplace_cloudfront_min_ttl = var.marketplace_cloudfront_min_ttl
  #   marketplace_cloudfront_default_ttl = var.marketplace_cloudfront_default_ttl
  #   marketplace_cloudfront_max_ttl = var.marketplace_cloudfront_max_ttl
}

module "dynamo_db_courses" {
  source  = "./modules/dynamodb/eu-central-1"
  context = module.base_labels.context
  name    = "courses"
}

module "dynamo_db_authors" {
  source  = "./modules/dynamodb/eu-central-1"
  context = module.base_labels.context
  name    = "authors"
}

module "lambda" {
  source                      = "./modules/lambda/eu-central-1"
  context                     = module.base_labels.context
  name                        = "lambda"
  role_get_all_authors_arn    = module.iam.role_get_all_authors_arn
  role_get_all_courses_arn    = module.iam.role_get_all_courses_arn
  role_get_course_arn         = module.iam.role_get_course_arn
  role_save_update_course_arn = module.iam.role_save_update_course_arn
  role_delete_course_arn      = module.iam.role_delete_course_arn

  dynamo_db_authors_name = module.dynamo_db_authors.dynamp_db_name
  dynamo_db_courses_name = module.dynamo_db_courses.dynamp_db_name

  #api_gateway_execution_arn = module.api-gateway.execution_arn
  api_gateway_execution_arn = aws_api_gateway_rest_api.this.execution_arn
}


module "iam" {
  source                = "./modules/iam"
  context               = module.base_labels.context
  name                  = "iam"
  dynamo_db_authors_arn = module.dynamo_db_authors.dynamp_db_arn
  dynamo_db_courses_arn = module.dynamo_db_courses.dynamp_db_arn
}


module "budget" {
  source                     = "./modules/budget"
  context                    = module.base_labels.context
  name                       = "budget"
  subscriber_email_addresses = var.subscriber_email_addresses
  slack_webhook_url          = var.slack_webhook_url
  author_name                = var.author_name
}

module "notified_Lambda" {
  source            = "./modules/notified_Lambda/eu-central-1"
  context           = module.base_labels.context
  name              = "notified_Lambda"
  alarm_emails      = var.alarm_emails
  slack_webhook_url = var.slack_webhook_url
  author_name       = var.author_name
}







# resource "aws_dynamodb_table" "example" {
#   name             = module.base_labels.id
#   hash_key         = "id"

#   billing_mode     = "PAY_PER_REQUEST"
#   # stream_enabled   = true
#   # stream_view_type = "NEW_AND_OLD_IMAGES"

#   attribute {
#     name = "id"
#     type = "S"
#   }

#   /* replica {
#     region_name = "us-east-2"
#   }

#   replica {
#     region_name = "us-west-2"
#   } */
# }
