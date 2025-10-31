This repository is a mirror of the Pixelmed software developed by David Clunie [@dclunie](https://github.com/dclunie).

The original source code is available at
https://www.dclunie.com/dicom3tools/workinprogress/index.html

This repository content is populated automatically by a GitHub action that runs every
day and checks for the presence of a new version of the pixelmed package.

This fork was created by Andrey Fedorov to keep track of changes done while
experimenting with the components of the toolkit.

## Linux Packages

This repository includes a GitHub Action that builds Linux packages for dicom3tools. The workflow:
- Installs required build dependencies (g++, xutils-dev, libx11-dev, libxext-dev)
- Builds the project using the standard build process (Configure, imake, make World)
- Packages the binaries into a tar.gz archive
- Uploads the package as a workflow artifact (retained for 90 days)
- Attaches the package to GitHub releases when a new release is published

The workflow can also be triggered manually via the "Actions" tab.

To download pre-built Linux binaries:
1. Go to the [Releases](../../releases) page
2. Download the `dicom3tools-linux-x86_64.tar.gz` file
3. Extract the archive: `tar -xzf dicom3tools-linux-x86_64.tar.gz`
4. The binaries will be in the current directory
