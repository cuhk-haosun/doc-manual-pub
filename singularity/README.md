# Singularity Guide
This is a guide to using singularity to run containers.
By running singularity, you can build an container and use the packaged program in the container.
***

## Build Container
The purpose of building containers is to create an isolated operating environment. Users can package an application and all its dependencies into a single unit for easy deployment and sharing.Let's use the *base* container as an example.First,we can pull from docker hub :
```
/data/home/grp-sunhao/pub/app/singularity build --sandbox /data/home/grp-sunhao/yourname/yourpath docker://cuhkhaosun/base
```


### Method for Timeout
Sometimes the server network times out and the base can be copied from the file of the lab :
```
cp -r /data/home/grp-sunhao/pub/docker/base /data/home/grp-sunhao/yourname/yourpath
```
***

## Run Container
After building *base* in your own folder,you can run it by :
```
/data/home/grp-sunhao/pub/app/singularity shell /data/home/grp-sunhao/yourname/yourpath
```
Now you will see:
```
singularity>
```
It means you successsfully run the container and can use command.
