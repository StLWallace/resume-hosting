resource "aws_s3_object" "glue_job_scripts" {
  for_each            = fileset("../content/resumes", "*.pdf")
  bucket              = aws_s3_bucket.public_content.id
  key                 = "resumes/${each.value}"
  source              = "../content/resumes/${each.value}"
  content_disposition = "inline"
  content_type        = "application/pdf"

  etag = filemd5("../content/resumes/${each.value}")
}
