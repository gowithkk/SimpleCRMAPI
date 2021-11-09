resource "aws_dynamodb_table" "dynamodb_table" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "samples" {
  table_name = aws_dynamodb_table.dynamodb_table.name
  hash_key   = aws_dynamodb_table.dynamodb_table.hash_key

  item = <<ITEM
     {
          "id": {"S": "001"},
          "firstName": {"S": "KAI"},
          "lastName": {"S": "LIU"},
          "Address": {"S": "123 Fantasy Road"}
     }
ITEM
}
