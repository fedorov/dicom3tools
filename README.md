This repository is a mirror of the Pixelmed software developed by David Clunie [@dclunie](https://github.com/dclunie).

The original source code is available at
https://www.dclunie.com/dicom3tools/workinprogress/index.html

This repository content is populated automatically by a GitHub action that runs every
day and checks for the presence of a new version of the pixelmed package.

This fork was created by Andrey Fedorov to keep track of changes done while
experimenting with the components of the toolkit.

## Linux Packages

This repository includes a GitHub Action that builds Linux packages for dicom3tools. The workflow:
- Uses **Ubuntu 20.04** for better backward compatibility across Linux distributions
- Installs required build dependencies (g++, xutils-dev, libx11-dev, libxext-dev)
- Builds the project using the standard build process (Configure, imake, make World)
- Tests binary execution to ensure they work correctly
- Checks binary dependencies (GLIBC and GLIBCXX versions)
- Packages the binaries into a tar.gz archive
- Uploads the package as a workflow artifact (retained for 90 days)
- Attaches the package to GitHub releases when a new release is published

The binaries are built on Ubuntu 20.04 (GLIBC 2.31, gcc 9.4) to ensure compatibility with a wide range of Linux distributions including:
- Ubuntu 20.04 and later
- Debian 11 (Bullseye) and later
- RHEL/CentOS 8 and later
- Fedora 32 and later

The workflow can also be triggered manually via the "Actions" tab.

### Using Pre-built Binaries

To download pre-built Linux binaries:
1. Go to the [Releases](../../releases) page
2. Download the `dicom3tools-linux-x86_64.tar.gz` file
3. Extract the archive: `tar -xzf dicom3tools-linux-x86_64.tar.gz`
4. The binaries will be in the current directory

## Default Configuration

**Note**: The default UID root is set to `0.0.0.0` in the build configuration. This is a placeholder value that should be replaced with organization-specific UIDs in production deployments. The `0.0.0.0` UID is used as a default when no specific UID root is configured. For production use, it is recommended to configure proper DICOM UIDs according to your organization's registered UID root from the ISO/IEC registration authority.
