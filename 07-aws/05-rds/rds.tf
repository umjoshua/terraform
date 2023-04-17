# Subnet Group
resource "aws_db_subnet_group" "rds-mariadb-subnet" {
    name = "mariadb-subnet-grp"
    subnet_ids = [aws_subnet.levelup-vpc-private-subnet-1.id,aws_subnet.levelup-vpc-private-subnet-2.id]
}

# Parameter group

resource "aws_db_parameter_group" "rds-db-parameter" {
    name = "rds-db-parameter"
    family = "mariadb10.6"

    parameter {
      name = "max_allowed_packet"
      value = "16777216"
    }
}

resource "aws_db_instance" "mariadb" {
  allocated_storage    = 20
  db_name              = "mariadb"
  engine               = "mariadb"
  engine_version       = "10.6.12"
  instance_class       = "db.t3.micro"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = aws_db_parameter_group.rds-db-parameter.name
  db_subnet_group_name = aws_db_subnet_group.rds-mariadb-subnet.name
  vpc_security_group_ids = [aws_security_group.allow-mariadb.id]
  availability_zone =  aws_subnet.levelup-vpc-private-subnet-1.availability_zone
  storage_type = "gp2"
  skip_final_snapshot  = true
}

output "rds" {
    value = aws_db_instance.mariadb.endpoint
}