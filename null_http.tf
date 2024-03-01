resource "null_resource" "sshcon" {

    triggers = {
      value = timestamp()  ## this will be force-replacement everytime
    }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/prateeksrivastava/Desktop/Prateek/teraform/tf files/2/ps_virginia.pem")
    host        = aws_instance.os1.public_ip
    
  }
  provisioner "remote-exec" {
    #on_failure = continue  #meta_argument for exception handling, and by default,  (on_failure = fail)
    inline = [
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd --now"
    ]
  }
# meta arguments
  depends_on = [ aws_instance.os1 ]
}
