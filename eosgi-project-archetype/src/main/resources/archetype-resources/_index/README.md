Index Module
============

This module builds an OSGi repository index as defined by section 132.5 of the OSGi Compendium R6 specification.

The index module should have runtime-scope dependencies to the [distro module](../_distro/README.md) and to any application modules. It should *not* depend on any integration test module. The generated index file will list all runtime- and compile-scope dependencies of this module.