resource "aws_s3_bucket" "data_bucket" {
  bucket = "wordle-solver-data-bucket"
}

resource "aws_s3_object" "wordlist" {
  bucket = aws_s3_bucket.data_bucket.id
  key    = "wordlist.txt"
  source = "data/wordlist.txt"
  etag   = "data/wordlist.txt"
}

resource "aws_s3_object" "letter_frequencies" {
  bucket = aws_s3_bucket.data_bucket.id
  key    = "letter-frequency.txt"
  source = "data/word_freq_with_pos.csv"
  etag   = "data/word_freq_with_pos.csv"
}