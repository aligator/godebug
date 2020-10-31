# Go Debugging for Intellij GoLand

This image is released on [Dockerhub](https://hub.docker.com/repository/docker/aligator/godebug).

## Example
Clone the repo
```shell script
git clone https://github.com/aligator/godebug.git
```

go into the example folder
```shell script
cd godebug/example
```

Run the example using docker-compose
```
docker-compose up
```

After you see this output, you need to create a new remote debug configuration
in Goland (described in details in [here](https://medium.com/@hananrok/debugging-hot-reloading-go-app-within-docker-container-b44d2929e8bd)).  
__Note:__  
An example is provided in this repo: `.run/debug_example_in_docker.run.xml` which should be available if you open this repo with goland.

Then run the debug (by click green beetle or Ctrl-D).

After that you should be able to set break points and then open the served webpage using a browser:  
`http://localhost:8080`

Whenever you change anything in the example folder it will rebuild the app and rerun it.  
