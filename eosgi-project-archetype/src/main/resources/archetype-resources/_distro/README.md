Distro Module
=============

This module defines a distribution (or *distro*), which is a selection of runtime dependencies from which an application may be assembled.

The contents of the distro should include bundles that are not necessarily required at compile time by any application bundle, but may be required at runtime. Examples include implementation bundles for OSGi specifications such as SCR (the runtime for Declarative Services), Event Admin, Configuration Admin, the Felix Gogo shell, etc.

Note that including a bundle in the distro does not mean it will be included in all application assemblies. It just makes that bundle available for inclusion, and it defines the version(s) of those bundles that are available.