# How to publish the xPack CMake

## Build

Before starting the build, perform some checks.

### Check possible open issues

Check GitHub [issues](https://github.com/xpack-dev-tools/cmake-xpack/issues)
and fix them; do not close them yet.

### Check the `CHANGELOG.md` file

Open the `CHANGELOG.md` file and and check if all
new entries are in.

Generally, apart from packing, there should be no local changes compared
to the original CMake distribution.

Note: if you missed to update the `CHANGELOG.md` before starting the build,
edit the file and rerun the build, it should take only a few minutes to
recreate the archives with the correct file.

### Check the version

The `VERSION` file should refer to the actual release.

### Push the build script

In this Git repo:

- if necessary, merge the `xpack-develop` branch into `xpack`.
- push it to GitHub.
- possibly push the helper project too.

### Clean the destination folder

Clear the folder where the binaries from all build machines will be collected.

```console
$ rm -f ~/Downloads/xpack-binaries/cmake/*
```

### Run the build scripts

When everything is ready, follow the instructions in the
[build](https://github.com/xpack-dev-tools/cmake-xpack/blob/xpack/README-BUILD.md)
page.

## Test

TBD

## Create a new GitHub pre-release

- go to the [GitHub Releases](https://github.com/xpack-dev-tools/cmake-xpack/releases) page
- click the **Draft a new release** button
- name the tag like **v3.18.3-1** (mind the dash in the middle!)
- select the `xpack` branch
- name the release like **xPack CMake v3.18.3-1** (mind the dash)
- as description
  - add a downloads badge like `![Github Releases (by Release)](https://img.shields.io/github/downloads/xpack-dev-tools/cmake-xpack/v3.18.3-1/total.svg)`
  - draft a short paragraph explaining what are the main changes
- **attach binaries** and SHA (drag and drop from the
`~/Downloads/xpack-binaries/cmake/` folder)
- **enable** the **pre-release** button
- click the **Publish Release** button

Note: at this moment the system should send a notification to all clients watching this project.

## Run the Travis tests

Run the tests on **stable** and **latest** platforms. This may take about 30
minutes.

The test results are available at
[Travis](https://travis-ci.org/github/xpack-dev-tools/cmake-xpack/builds/).

For more details, see `tests/scripts/README.md`.

## Prepare a new blog post

In the `xpack.github.io` web Git:

- add a new file to `_posts/cmake/releases`
- name the file like `2019-07-17-cmake-v3-17-3-1-released.md`
- name the post like: **xPack CMake v3.18.3-1 released**.
- as `download_url` use the tagged URL like `https://github.com/xpack-dev-tools/cmake-xpack/releases/tag/v3.18.3-1/`
- update the `date:` field with the current date

If any, close
[build issues](https://github.com/xpack-dev-tools/cmake-xpack/issues)
on the way. Refer to them as:

- **[Issue:\[#1\]\(...\)]**.

## Update the SHA sums

Copy/paste the build report at the end of the post as:

```console

## Checksums
The SHA-256 hashes for the files are:

06d2251a893f932b38f41c418cdc14e51893f68553ba5a183f02001bd92d9454  
xpack-cmake-v3.18.3-1-darwin-x64.tar.gz

a1c7e77001cb549bd6b6dc00bb0193283179667e56f652182204229b55f58bc8  
xpack-cmake-v3.18.3-1-linux-arm64.tar.gz

c812f12b7159b7f149c211fb521c0e405de64bb087f138cda8ea5ac04be87e15  
xpack-cmake-v3.18.3-1-linux-arm.tar.gz

ebb4b08e8b94bd04b5493549b0ba2c02f1be5cc5f42c754e09a0c279ae8cc854  
xpack-cmake-v3.18.3-1-linux-x32.tar.gz

687ac941c995eab069955fd673b6cd78a6b95048cac4a92728b09be444d0118e  
xpack-cmake-v3.18.3-1-linux-x64.tar.gz

a0bde52aa8846a2a5b982031ad0bdebea55b9b3953133b363f54862473d71686  
xpack-cmake-v3.18.3-1-win32-x32.zip

b25987e4153e42384ff6273ba228c3eaa7a61a2a6cc8f7a3fbf800099c3f6a49  
xpack-cmake-v3.18.3-1-win32-x64.zip
```

If you missed this, `cat` the content of the `.sha` files:

```console
$ cd deploy
$ cat *.sha
```

## Update the Web

- commit the `xpack.github.io` project; use a message
  like **xPack CMake v3.18.3-1 released**
- wait for the GitHub Pages build to complete
- remember the post URL, since it must be updated in the release page

## Publish on the npmjs server

- open [GitHub Releases](https://github.com/xpack-dev-tools/cmake-xpack/releases)
  and select the latest release
- check the download counter, it should match the number of tests
- update the `baseUrl:` with the file URLs (including the tag/version);
no terminating `/` is required
- from the web release, copy the SHA & file names
- commit all changes, use a message like
  `package.json: update urls for v3.18.3-1 release` (without `v`)
- check the latest commits `npm run git-log`
- update `CHANGELOG.md`; commit with a message like
  _CHANGELOG: prepare npm v3.18.3-1.1_
- `npm version v3.18.3-1.1`; the first 4 numbers are the same as the
  GitHub release; the fifth number is the npm specific version
- `npm pack` and check the content of the archive, which should list
only the `package.json`, the `README.md`, `LICENSE` and `CHANGELOG.md`
- push all changes to GitHub
- `npm publish --tag next` (use `--access public` when publishing for the first time)

## Test npm binaries

Install the binaries on all platforms.

```console
$ xpm install --global @xpack-dev-tools/cmake@next
```

As a shortcut, there is Travis test that checks the package on 
Intel Ubuntu, macOS and Windows.

## Tag the npm package as `latest`

When the release is considered stable, promote it as `latest`:

- `npm dist-tag ls @xpack-dev-tools/cmake`
- `npm dist-tag add @xpack-dev-tools/cmake@v3.18.3-1.1 latest`
- `npm dist-tag ls @xpack-dev-tools/cmake`

## Create the final GitHub release

- go to the [GitHub Releases](https://github.com/xpack-dev-tools/cmake-xpack/releases) page
- check the download counter, it should match the number of tests
- add a link to the Web page `[Continue reading »]()`; use an same blog URL
- **disable** the **pre-release** button
- click the **Update Release** button

## Share on Twitter

- in a separate browser windows, open [TweetDeck](https://tweetdeck.twitter.com/)
- using the `@xpack_project` account
- paste the release name like **xPack CMake v3.18.3-1 released**
- paste the link to the blog release URL
- click the **Tweet** button
