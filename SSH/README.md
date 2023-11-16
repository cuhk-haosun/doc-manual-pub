# Access via SSH
**Contributors** (Equally contribution)

- Xing Zhao
- Yi Yan
- Gexin Liu

## Overview

  There are mainly two methods for login to a linux system: password or SSH key (**RECOMMENDED**). 
  
  
  The SSH key method is recomended because it is safer and more convenient. 
  

  Since SSH is an ubiquitous tool in various PC systems, you could simply take use of it in Windows PowerShell (Windows 10 or 11), and Linux Console (almost all Linux versions). 

**Note:** For demonstrations, the operations in Windows PowerShell will be shown first, then will be the operations in Linux console.   
  
## SSH password login 

For first time login, users could use the following command to login to the system via SSH. The command is as follows:

```
ssh -p [port] [account]@[ip]
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/ssh%20powershell.gif?raw=true)

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/ssh%20linux.gif?raw=true)

**Note:** For user privacy, the password is not shown as any symbol but remains blank when typing.


New users are advised to change their passwords via the following order:

```
passwd
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/passwd%20powershell.gif?raw=true)

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/passwd%20linux.gif?raw=true)

End the access:

```
exit
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/exit%20powershell.gif?raw=true)

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/exit%20linux.gif?raw=true)

or

```
logout
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/logout%20powershell.gif?raw=true)

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/logout%20linux.gif?raw=true)

## SSH key login

After first login on to the linux sever, users could use ssh-keygen to make ssh keys for automating logins on the own computer.

### Choosing an Algorithm and Key Size

SSH supports several public key algorithms for authentication keys. These include:

```
ssh-keygen -t ed25519
ssh-keygen -t rsa -b 4096
ssh-keygen -t dsa
ssh-keygen -t ecdsa -b 521
```

### Specifying the File Name

The files recording the key pairs will be designated with default names. However, the file name can also be modified via the command line using the `-f <filename>` option.

```
ssh-keygen -f ~/[file_name] -t ed25519
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/ssh-keygen%20powershell.gif?raw=true)

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/ssh-keygen%20linux.gif?raw=true)

**Note:** The directory and filename were set as default in the demostration, and no passphrase was set.

### Copying the Public Key to the Server

To use public key authentication, the public key must be copied to a server and installed in an [authorized_keys](https://www.ssh.com/ssh/authorized_keys) file. This can be manually done or using the [ssh-copy-id](https://www.ssh.com/ssh/copy-id) tool in Linux console, but a little bit different in Windows PowerShell.

In Linux console, to copy the Public Key to the Server, users could simply use the command as follows:

```
ssh-copy-id -i ~/.ssh/[file_name].pub -p [port] [account]@[ip]
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/copy%20pub%20key%20linux.gif?raw=true)

In Windows PowerShell, users should instead use the commands as follows:

```
type $env:USERPROFILE\.ssh\[filename].pub | ssh -p [port] [account]@[ip] "cat >> .ssh/authorized_keys"
```

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/copy%20pub%20key%20powershell.gif?raw=true)

**Note:** Users are advised to type the entire commands in textbook in advance and copy&paste them to the Windows PowerShell by `Ctrl+C` and `Ctrl+V`.


Once the public key has been configured on the server, the server will allow any connecting user that has the private key to log in (following the instruction in the previous section) without typing passwords. During the login process, the client proves possession of the private key by digitally signing the key exchange.

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/ssh-key%20login%20powershell.gif?raw=true)

![img](https://github.com/cuhk-haosun/doc-manual/blob/image-for-ssh/SSH/image/ssh-key%20login%20linux.gif?raw=true)

### Extensions for ssh-keygen algorithms:

- `ed25519` - this is a new algorithm added in OpenSSH. Support for it in clients is not yet universal. Thus its use in general purpose applications may not yet be advisable.**(Recommended)**
  
- `rsa` - an old algorithm based on the difficulty of factoring large numbers. A key size of at least 2048 bits is recommended for RSA; 4096 bits is better. RSA is getting old and significant advances are being made in factoring. Choosing a different algorithm may be advisable. It is quite possible the RSA algorithm will become practically breakable in the foreseeable future. All SSH clients support this algorithm.
  
- `dsa` - an old US government Digital Signature Algorithm. It is based on the difficulty of computing discrete logarithms. A key size of 1024 would normally be used with it. DSA in its original form is no longer recommended.
  
- `ecdsa` - a new Digital Signature Algorithm standarized by the US government, using elliptic curves. This is probably a good algorithm for current applications. Only three key sizes are supported: 256, 384, and 521 (sic!) bits. We would recommend always using it with 521 bits, since the keys are still small and probably more secure than the smaller keys (even though they should be safe as well). Most SSH clients now support this algorithm.

The algorithm is selected using the `-t` option and key size using the `-b` option (selective).

#

# Referrence

https://www.ssh.com/academy/ssh/keygen

https://www.cnblogs.com/cyjaysun/p/4435913.html

https://learn.microsoft.com/zh-cn/windows-server/administration/openssh/openssh_keymanagement

https://blog.csdn.net/qq_45624685/article/details/122631083
