output "private_key_path" {
  value = local_file.private_key.filename
}

output "vm_names" {
  value = local.vm_names
}

output "public_ips" {
  value = {
    for i, inst in aws_instance.vm : local.vm_names[i] => inst.public_ip
  }
}

output "ssh_login_commands" {
  value = {
    for i, inst in aws_instance.vm : local.vm_names[i] => "ssh -i ${local_file.private_key.filename} ec2-user@${inst.public_ip}"
  }
}
