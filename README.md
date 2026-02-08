# dsoc
An experimental Docker sandbox for OpenCode

# Usage

start your sandbox:

```powershell
> cd myproj
> docker sandbox run -t ghcr.io/elasticenergy/dsoc:latest claude .
```

after your sandbox starts:

```
$ opencode
```

# Disclaimer

- No Warranty:
  This image is provided "as is" without any warranties. Use at your own risk. The maintainer is not responsible for any issues or damages arising from its use.

- Experimental Setup:
  This image contains a custom configuration where specific libraries (e.g., musl, libstdc++) are manually copied from Alpine Linux into a Ubuntu-based environment. It may not behave as a standard OS environment.