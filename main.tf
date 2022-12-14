provider "aws" {
region = "us-east-1"
}
##IAM ROLE###
resource "aws_iam_role" "lambda_role" {
  name = "terraform_aws_lambda_role"
  
  assume_role_policy = <<EOF
  {
    Version = "2012-10-17"
    Statement = 
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
    
        }
      }
    }
}
## Iam policy##
  resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "aws policy for managing lambda role"
  policy = <<EOF
    {
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:createLogGroup",
          "logs:createLogStream",
          "logs:PutLogEvents",
          
        ]
        "Effect"   = "Allow"
        "Resource = "aws:arn:logs:*:*:*",
      }
    ]
  }
}
##Policy attachment on role ###
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role"
 {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}
  #generate an archive from content, file or directory of file#
  data "archive _file" "zip_the_python_code" {
  type = "zip"
  source_dir= "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
  }
  
  ##create lambda function##
  
resource "aws_lambda_function" "terraform_lambda_function" 
{
  filename      = "${path.module}/python/hello-python.zip"
  function_name = "Jhooq_lambda_Function"
  role          =  aws_iam_role.lambda_role.arn
  handler       = "hello-python.lambda_handler"
  runtime       = "python3.8"
  depends_on    = "[aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]"
}

