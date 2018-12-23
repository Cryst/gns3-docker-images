# cEOS for GNS3

The cEOS image from Arista needs some few changes before it can be
used in GNS3. The `build` script automates these modifications.

Usage, replace \<version\> by the cEOS version:
- Download the cEOS-lab image from Arista.
- Import the image into docker.  
  `docker import cEOS-lab.tar.xz ceosimage:<version>`
- Create the modified ceosimage:GNS3  
  `./build <version>`
