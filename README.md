# frayframe

A Pachyderm deployed video processing tool!
FrayFrame accepts a video file and outputs frame-by-frame images from that video.

## Prerequisites 
You'll first need to follow the [pachyderm setup procedure](https://docs.pachyderm.com/latest/getting_started/local_installation/) which includes installing:
- [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/) for containerising your application
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) for controlling minikube
- [a hypervisor](https://kubernetes.io/docs/tasks/tools/install-minikube/#install-a-hypervisor) for virtualisation
- [Docker](https://docs.docker.com/install/) for building and managing your containerised images
- [pachctl](https://docs.pachyderm.com/latest/getting_started/local_installation/#install-pachctl) for building and managing your Pachyderm cluster

Since I did a fresh install of all of these, I will give you the quick-and-dirty setup procedure for MacOS

### Quick-and-dirty setup
Install minikube
```
brew install minikube
```
Install hyperkit to access hypervisor drivers
```
brew install hyperkit
```
Test launch our kube
```
minikube start --driver=hyperkit
```
once this succeeds, stop this kube and set hyperkit as the default driver
```
minikube stop && minikube delete && minikube config set driver hyperkit
```
verify this worked
```
minikube start
```

 Install pachyderm CLI (this will change, see their latest instructions on their website)
```
brew tap pachyderm/tap && brew install pachyderm/tap/pachctl@1.10
```

Install Docker (Since Docker is a system-level service (running virtualisations on the CPU) you will need to launch the casked-app and enter your system password when prompted to use Docker. 
```
brew cask install docker
```
sometimes Docker needs a tickle to start working, so lets makes sure we can pull docker images
``` 
docker info
docker search ubuntu
docker pull ubuntu:latest
```

## Using frayframe

Now that we have everything setup

clone this repo to your favourite git dir
```
cd ~/git 
git clone https://github.com/kasekun/frayframe.git
cd frayframe
```
start minikube and pachyderm
```
minikube start && pachctl deploy local
```
now watch and wait for the pod to be ready (hit ctrl+c when satisfied)
```
watch -pc kubectl get pods
```
create a new pachyderm `videos` repo, and seed it with a video (this demo uses a 15 second public-test-video of a chrome-cast ad, but you can point to a local video with the `-f` flag instead)
```
pachctl create repo videos
pachctl start commit videos@master
pachctl put file videos@master:good_vid.mp4 -f http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4
pachctl finish commit videos@master
```
check that the file `good_vid.mp4` is indeed there
```
pachctl list file videos@master
```

you can now create the pipeline from the `fray.json` template to initiate processing of your video

```
pachctl create pipeline -f fray.json
```

The process is now automatic. Once the frayframe pipeline is "Running" (`watch -pc kubectl get pods`) you will be able to see the pachyderm job, and the frames being put into the automatically created pachyderm repo "frayframe". Let's inspect these:

```
pachctl list repo
pachctl list job
pachctl list file frayframe@master | less
```

and inspect one of these frames by piping it into `Preview` (macOS)

```
pachctl get file frayframe@master:good_vid-0069.png | open -f -a /Applications/Preview.app
```
or save to a folder 
```
pachctl get file frayframe@master:good_vid-0069.png > ~/Pictures/shortened_sequences.png
```

That's it! Now, each time you load a video into the pachyderm `videos` repos via 
```
pachctl put file videos@master -f <your video>
```
it will automatically process the frames!
