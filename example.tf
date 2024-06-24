locals {
  tags = {a: "b", c: "d"}
}

resource "aws_security_group" "a" {
  name = "b"

  tags = { a:"b"}
}