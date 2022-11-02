# mr-vercetti/docker-steamcmd
[SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD) in Docker
container, for use in other images as a builder.

## Usage
Example of how you can use it in your Dockerfile.

```
FROM mrvercetti/steamcmd as builder
COPY --from=builder /output /app
```
