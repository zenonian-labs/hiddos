resource "aws_instance" "hiddos-dns" {
  ami = "ami-02a2af70a66af6dfb"
  # ami                    = "ami-0230bd60aa48260c6"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.hiddos_tf_ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.hiddos_ec2_security_group.id]

  tags = {
    Name = "hiddos-dns"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y bind bind-utils",
      "sudo systemctl enable named",
      "sudo systemctl start named",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = tls_private_key.hiddos_tf_ec2_key.private_key_pem
    }
  }
}

output "dns_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.hiddos-dns.public_ip
}
