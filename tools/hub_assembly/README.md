# Hub Archive Creator
This Galaxy tool permits to prepare your files to be ready for Assembly Hub visualization.

To try the software, you need to have a .gff3 and a .fa as input and set an output filename:
```hubArchiveCreator.py -g test_data/augustusDbia3.gff3 -f test_data/dbia3.fa -o output.zip```

You will get a .zip file, that you need to put on a server accessible from the outside. Then use UCSC track hubs fonctionality to see your track.

## Requirements:
1. You need to install [Mako](http://www.makotemplates.org/download.html)
2. HubArchiveCreator use, for now, tools from UCSC Kent Utils. This repository use the linux.x86_64/ ones, but you NEED to replace them accordingly to your architecture.
Here is the link to get these tools: http://hgdownload.soe.ucsc.edu/admin/exe/

### Install in Galaxy
1. Take the hubAssembly.py in the hubaDatatype folder, and add it into lib/galaxy/datatypes in your Galaxy instance
2. Add this line in config/datatypes_conf.xml:
```<datatype extension="huba" type="galaxy.datatypes.hubAssembly:HubAssembly" display_in_upload="true" />```
3. Look into hubaDatatype/README.md for more informations
