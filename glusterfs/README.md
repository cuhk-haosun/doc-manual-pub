# Mount the glusterfs as non-root user
```
/usr/sbin/glusterfs --log-level=INFO --log-file=/home/zx/.local/gluster.log --volfile-id=zx  --volfile-server=sunlabfs1 zx
```

# Requirement for non-user mount
ref: https://www.gluster.org/mounting-a-glusterfs-volume-as-an-unprivileged-user/

On server
```
gluster volume set $VOLUME allow-insecure on
```

On the client as root:
```
echo user_allow_other >> /etc/fuse.conf
```

## Troubleshoot
If encountered error `/usr/bin/fusermount-glusterfs: mount failed: Operation not permitted` when mounting, run:
```
sudo chmod +s /usr/bin/fusermount-glusterfs
```
to allow non-root user access
