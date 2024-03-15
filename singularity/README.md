# Build Image
```
/data/home/grp-sunhao/pub/app/singularity build --sandbox /data/home/grp-sunhao/yourname/yourpath docker://cuhkhaosun/base
```

**Note:** pull from docker maybe slow or timeout


## Method for Timeout
```
cp -r /data/home/grp-sunhao/zx/container/base /data/home/grp-sunhao/yourname/yourpath
```
# Run Container
```
/data/home/grp-sunhao/pub/app/singularity shell /data/home/grp-sunhao/yourname/yourpath
image
```
Now you will see:
```
singularity>
```
It means you successsfully run the container and can use command.
