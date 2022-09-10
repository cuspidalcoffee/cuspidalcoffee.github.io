# Tech Side-Projects

<!-- Here I list the major side-projects I have completed or that are ongoing. -->
Here I list the major side-projects I have completed.
These include programming projects and IT infrastructure work.
It does *not* include contributions to open source projects that are not mine.
It also does not include smaller projects I don't consider significant enough to include.

For a somewhat more complete list of things I have been involved with to any degree, see the links navigation entry.

## Bin Bucket
My Binary Bucket is a project born of my administrative frustration.
It's very wasteful to simply install my most comfortable text editor, shell, etc on every server.
Especially since many of them may not be available in the repositories, I may not control the server (e.g in case of working with corporate partners), and so on.

As a response, I decided to build an extremely simple and minimal system for building fully static binaries that may be easily deployed and updated.
The binary bucket (so named because it is a bucket (s3-compatible terminology) that holds binaries) is the result of this effort.

You can browse the bucket itself [here](https://minio.toast.cafe/bin/index.html), and view the builder sources and history [here](https://fossil.one/toast/binbuilder).

## BRPaste
[BRPaste](https://github.com/CosmicToast/brpaste.git) (Burning Rubber Paste) was an effort to create a pastebin that would have a faster backend (relative to various python or lua-based offerings at the time), have memorable identifiers (based on [research into human short term memory](https://doi.org/10.1037/h0043158)) and have fewer features (thus requiring little to no runtime dependencies or configuration).

To achieve this, the 32bit murmurhash of the content was used as the id (since it's possible to encode it into 6 characters of base64).
To achieve the desired speed, an absolute minimum amount of processing was applied, and the storage was kept in memory (using either a built-in memory backend, or redis).

Now that the project is feature-complete, the main changes being considered are improvements to the html, the limited configuration system (multiple in-progress projects have to do with this), as well as adding a slower (but easier, perhaps even default) storage system using an on-disk b-tree.

## CNI
CNI is an INI-alike configuration format.

It comes with a specification (by way of an exhaustive test suite and reference implementation), but has an even simpler grammar than INI.
It also handles the data differently: as a pure key-value store (with sections simply being prefixes/formalities).
The Go implementation is also planned to come with linting and analysis utilities.

You can find the repository for the reference implementation and test suite [here](https://github.com/libuconf/cni.git).
