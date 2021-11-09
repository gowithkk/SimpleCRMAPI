resource "random_pet" "lambda_bucket_name" {
  prefix = var.s3_prefix_name
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket        = random_pet.lambda_bucket_name.id
  acl           = "private"
  force_destroy = true
}

data "archive_file" "zip_lambda" {
  count       = length(var.lambda_funtion_name)
  type        = "zip"
  source_file = "./${var.archive_source_file}/${var.lambda_funtion_name[count.index]}.py"
  output_path = "./${var.archive_source_file}/${var.lambda_funtion_name[count.index]}.zip"
}

resource "aws_s3_bucket_object" "lambda_object" {
  count  = length(var.lambda_funtion_name)
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "${var.lambda_funtion_name[count.index]}.zip"
  source = data.archive_file.zip_lambda[count.index].output_path
  etag   = filemd5(data.archive_file.zip_lambda[count.index].output_path)
}
