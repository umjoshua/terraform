resource "aws_iam_role" "s3-test-bucket-role" {
  name = "s3-test-bucket-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy" "s3-test-bucket-policy" {
  name = "s3-test-bucket-policy"
  role = aws_iam_role.s3-test-bucket-role.id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::levelup-bucket-1414",
          "arn:aws:s3:::levelup-bucket-1414/*"
        ]
      },
    ]
  })
}

resource "aws_iam_instance_profile" "s3-test-bucket-instance-profile" {
  name = "s3-test-bucket-instance-profile"
  role = aws_iam_role.s3-test-bucket-role.name
}