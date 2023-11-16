# Install and configure Syncthing on Debian 12

**Contributors** (Equally contribution)

- Xing Zhao

- Yi Yan

## Installing via Debian/Ubuntu Packages

To allow the system to check the packages authenticity, you need to provide the release key.

```
# Add the release PGP keys:
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
```

The `stable` channel is updated with stable release builds, usually every first Tuesday of the month.

```
# Add the "stable" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list
```

The `candidate` channel is updated with release candidate builds, usually every second Tuesday of the month. These predate the corresponding stable builds by about three weeks.

```
# Add the "candidate" channel to your APT sources:
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing candidate" | sudo tee /etc/apt/sources.list.d/syncthing.list
```

And finally.

```
# Update and install syncthing:
sudo apt-get update
sudo apt-get install syncthing
```

##

## Configuring

The admin GUI starts automatically and remains available on `http://localhost:8384/`(Normally, the GUI would pop-up with Syncthing luanching). Cookies are essential to the correct functioning of the GUI; please ensure your browser accepts them. It should look something like this:

![/images/gs1png](https://docs.syncthing.net/_images/gs1.png)

On the left is the list of “folders”, or directories to synchronize. You can see the `Default Folder` was created for you, and it’s currently marked “Unshared” since it’s not yet shared with any other device. On the right is the list of devices. Currently there is only one device: the computer you are running this on.

For Syncthing to be able to synchronize files with another device, it must be told about that device. This is accomplished by exchanging “device IDs”. A device ID is a unique, cryptographically-secure identifier that is generated as part of the key generation the first time you start Syncthing. It is printed in the log above, and you can see it in the web GUI by selecting “Actions” (top right) and “Show ID”.

Two devices will *only* connect and talk to each other if they are both configured with each other’s device ID. Since the configuration must be mutual for a connection to happen, device IDs don’t need to be kept secret. They are essentially part of the public key.

To get your two devices to talk to each other click “Add Remote Device” at the bottom right on both devices, and enter the device ID of the other side. You should also select the folder(s) that you want to share. The device name is optional and purely cosmetic. You can change it later if desired.

 ![/images/gs2png](https://docs.syncthing.net/_images/gs2.png) ![/images/gs3png](https://docs.syncthing.net/_images/gs3.png)

Once you click “Save” the new device will appear on the right side of the GUI (although disconnected) and then connect to the new device after a minute or so. Remember to repeat this step for the other device.

![2023-09-11-18-31-54-image.png](https://github.com/HoshinoKyouna/Github/blob/main/2023-09-11-18-31-54-image.png?raw=true)

Addtionally, users are advised to type `tcp://ip:port`in "Addresses" of "Advanced" in order to establish a direct connection between two devices, through which a higher transfer rate could be obtained.

![2023-09-11-18-38-14-image.png](https://github.com/HoshinoKyouna/Github/blob/main/2023-09-11-18-38-14-image.png?raw=true)

At this point the two devices share an empty directory. Adding files to the shared directory on either device will synchronize those files to the other side.

# Referrence

https://docs.syncthing.net/intro/getting-started.html#configuring

https://apt.syncthing.net
