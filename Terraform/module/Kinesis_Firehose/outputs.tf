output "kinesis_stream_name" {
  value = aws_kinesis_firehose_delivery_stream.Kinesis_firehose.name
}

output "kinesis_arn" {
  value = aws_kinesis_firehose_delivery_stream.Kinesis_firehose.arn
}