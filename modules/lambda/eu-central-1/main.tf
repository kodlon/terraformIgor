module "labels" {
  source  = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  context = var.context
  name    = var.name
}


data "archive_file" "get_all_authors" {
  type        = "zip"
  source_file = "${path.module}/js-function/get-all-authors/get-all-authors.js"
  output_path = "modules/lambda/eu-central-1/js-function/get-all-authors/get-all-authors.zip"
}

resource "aws_lambda_function" "get_all_authors" {
  filename      = data.archive_file.get_all_authors.output_path
  function_name = "${module.labels.id}-get-all-authors"
  role          = var.role_get_all_authors_arn
  handler       = "get-all-authors.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.get_all_authors.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_authors_name
    }
  }
}
