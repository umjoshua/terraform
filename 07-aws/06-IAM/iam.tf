resource "aws_iam_user" "admin-user-1" {
  name = "admin-user-1"
}

resource "aws_iam_user" "admin-user-2" {
  name = "admin-user-2"
}

resource "aws_iam_group" "admin" {
  name = "admin-group"
}

resource "aws_iam_group_membership" "group-membershipo" {
  name = "admin-test"
  users = [
    aws_iam_user.admin-user-1.name,
    aws_iam_user.admin-user-2.name
  ]

  group = aws_iam_group.admin.name
}

resource "aws_iam_group_policy_attachment" "policy-attachment" {
  group      = aws_iam_group.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
