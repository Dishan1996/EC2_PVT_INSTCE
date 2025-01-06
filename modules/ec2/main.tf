# Generate an RSA private key
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS Key Pair using the generated public key
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "${path.module}/ec2-key-pair.pem"
}

# Create the EC2 instance with the key pair
resource "aws_instance" "default" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = var.name
  }
}
