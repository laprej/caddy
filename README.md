# TrueNAS Instructions

## Add Apps

1. Look for desired app in Apps / Discover Apps and if found, add it
1. Once added, convert to custom app and add the following to its config:

```docker-compose
networks:
  default:
    name: caddy_net
    external: true
```

If the App does not exist in the TrueNAS catalog, add the docker-compose.yaml file.
