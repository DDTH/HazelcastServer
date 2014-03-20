HazelcastServer
===============

Hazelcast Server with Start/Stop scripts.

Project home: [https://github.com/DDTH/HazelcastServer](https://github.com/DDTH/HazelcastServer).


## License ##

See [LICENSE.txt](LICENSE.txt) for details. Copyright (c) 2013-2014 Thanh Ba Nguyen.

Third party libraries are distributed under their own license(s).


## Release-notes ##

Latest release: `3.2-RC2`.

See [RELEASE-NOTES.md](RELEASE-NOTES.md).


## Installation ##

Note: Java 6 or higher is required!

### Install from binary ###

- Download binary package from [project release site](https://github.com/DDTH/HazelcastServer/releases).
- Unzip the binary package and copy it to your favourite location, e.g. `C:\HazelcastServer`.


### Install from source ###

- Download application's source, either cloning github project or download the source package from [project release site](https://github.com/DDTH/HazelcastServer/releases).
- Build with maven: `mvn clean package`.
- The built binary package is available at `hazelcastserver-distribution/target/hazelcastserver-distribution-<version>-bin/HazelcastServer-<version>`. You may copy it to your favourite location, e.g. `/usr/local/HazelcastServer`.

The binary package contains several files and directories:

- `README.md`: this file.
- [`RELEASE-NOTES.md`](RELEASE-NOTES.md): release notes.
- [`LICENSE.txt`](LICENSE.txt): license information.
- `bin`: directory contains start/stop scripts.
- `lib`: directory contains the bootstrapper and its dependencies.
- `logs`: directory contains log files.


## Start/Stop Hazelcast Server ##

### Windows ###

Start server with default JVM memory limit (64mb)
> `C:\HazelcastServer\>bin\server_start.bat`

Start server with 1G memory limit
> `C:\HazelcastServer\>bin\server_start.bat 1024`

Press `Ctrl-C` to stop the running server.


### Linux ###

Start server with default JVM memory limit (64mb)
> `/usr/local/HazelcastServer/bin/server.sh start`

Start server with remote debugging and 2G memory limit
> `/usr/local/HazelcastServer/bin/server.sh jpda 2048`

Upon successful startup, Hazelcast server listens for requests on port `8700` (port number is configurable).

## Configurations ##

### Java & Startup Script Configurations ###

> Windows: file `bin\server_start.bat`. Linux: file `/bin/server.sh`.

Production/Development environment:
> Look for line starts with `ENV_NAME=`, change the setting to either `production` or `development`.

Log4J: file `lib\log4j.properties`

Hazelcast Server: file `bin/hazelcast.xml`
