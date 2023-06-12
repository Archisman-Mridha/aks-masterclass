resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_ssh_key" {
  filename = "outputs/private-ssh-key"
  content = tls_private_key.this.private_key_openssh
}