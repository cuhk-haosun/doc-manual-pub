# Nextcloud

Nextcloud is open source file sync and share software providing a safe, secure, and compliant file synchronization and sharing solution on servers that you control. You can share one or more files and folders on your computer, and synchronize them with your Nextcloud server. Place files in your local shared directories, and those files are immediately synchronized to the server and to other devices using the Nextcloud Desktop Sync Client, Android app, or iOS app.

<a href="https://docs.nextcloud.com/server/latest/user_manual/en/index.html" target="_blank">Nextcloud user manual</a>

# The Nextcloud Web interface

You can connect to your Nextcloud server using any Web browser or Desktop Synchronization Client.

## Web browser

Just point it to your Nextcloud server URL (e.g. https://slcloud.yutg.net) and enter your username and password.

## Desktop client

<a href="https://nextcloud.com/install/#install-clients">Install the Desktop Synchronization Client</a>

Point to the URL and enter your username and password, just as you would when logging in with web browser.

# Accessing Nextcloud files using WebDAV

Nextcloud fully supports the WebDAV protocol, and you can connect and synchronize with Nextcloud Files over WebDAV. 

**Locating Your WebDAV URL in Nextcloud**

- Log in to your Nextcloud web interface.
- Click on your user icon (top-right corner) and go to Files Settings.
- Scroll down to the WebDAV section, where you’ll find your WebDAV URL.

![WebDAV_URL](./pic/WebDAV_URL.png)

## Accessing files using macOS

See <a href="https://docs.nextcloud.com/server/latest/user_manual/en/files/access_webdav.html#accessing-files-using-macos">Accessing files using macOS</a>

## Accessing files using Microsoft Windows

See <a href="https://docs.nextcloud.com/server/latest/user_manual/en/files/access_webdav.html#accessing-files-using-microsoft-windows">Accessing files using Microsoft Windows</a>

## Accessing files using Linux

### Creating WebDAV mounts

Take rclone as the example, if you want to create WedDAV mounts using other filesystem driver, like <a href="https://docs.nextcloud.com/server/latest/user_manual/en/files/access_webdav.html#creating-webdav-mounts-on-the-linux-command-line">davfs2</a>, you can check the official documentation. 

**Configure rclone for WebDAV**

```
rclone config
```

**When prompted, follow these steps:**

- Select n for a new remote.
- Name it something like nextcloud.
- Choose the **WebDAV** from the list of storage types.
- Provide the WebDAV URL obtained from Nextcloud.
- For vendor, select **Nextcloud**.
- Input your Nextcloud username and password.
- You can leave the bearer_token blank if you’re not using it.

![rclone_config](./pic/rclone_config.png)

**Test your connection**

To list the files in your Nextcloud WebDAV storage, run:
```
rclone ls nextcloud:
```

**Mount the WebDAV share**

You can mount the WebDAV share to a local directory using the rclone mount command:
```
rclone mount nextcloud: ~/my_nextcloud_mount
```

This will mount the WebDAV share to ~/my_nextcloud_mount without requiring root privileges.
To unmount the share, use fusermount:
```
fusermount -u ~/my_nextcloud_mount
```

**Sync Local Directory to Nextcloud**

If you want to sync a local directory (/local/path) to a directory in Nextcloud (/remote/path), use the following command:
```
rclone sync /local/path nextcloud:/remote/path
```

**Sync from Nextcloud to local directory**

```
rclone sync nextcloud:/remote/path /local/path
```




**Contributors**

- Zhao, Xing
- WANG, Shang
