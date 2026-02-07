# dsoc
An experimental Docker sandbox for OpenCode

# Usage

```bash
> cd myproj
> docker sandbox create -t ghcr.io/elasticenergy/dsoc:v1.0 claude .
> docker sandbox exec -it claude-myproj opencode
```

# Disclaimer

- No Warranty:
  This image is provided "as is" without any warranties. Use at your own risk. The maintainer is not responsible for any issues or damages arising from its use.

- Experimental Setup:
  This image contains a custom configuration where specific libraries (e.g., musl, libstdc++) are manually copied from Alpine Linux into a Ubuntu-based environment. It may not behave as a standard OS environment.