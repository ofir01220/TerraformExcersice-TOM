

<!--   HI TOM!   -->

steps to iplement and deploy successfully: 2 ec2 1 private 1 public and enabled ssh from local
machine directly into the private one using openvpn.

1. In commandLine eg. WSL - run terraform init     THAN      terraform apply.
2. SSH into your private instance(you can look up the id in aws UI OR create an output variable).
3. run command : "sudo /var/log/openvpn-as-install.log | grep password" . to find the password for the login.
4. in your browser prompt the ip of the public ec2 than :943/ - example 111.111.111.111:943/
5. login to your account with the password, username will be: "openvpn" and change password (!IMPORTANT).
6. Download the connection profile (usually an .ovpn file) for windows (YOUR OPERATION SYSTEM TOM).
7. install an OpenVPN client on your local computer. 
8. Open the OpenVPN Connect client and import the .ovpn profile you downloaded.
9. Open the OpenVPN Connect client (or other client software) and import the .ovpn profile you downloaded.
10. Open terminal and SSH into private ec2 using the key in the Terraform module.


Thanks for the assigment Tom!
