# How to make a new release (maintainer info)

## Release schedule

This distribution is generally one minor release behind the upstream releases.
In practical terms, when the minor release number changes, it awaits a few
more weeks to get the latest patch release.

## Prepare the build

Before starting the build, perform some checks and tweaks.

### Check Git

In the `xpack-dev-tools/cmake-xpack` Git repo:

- switch to the `xpack-develop` branch
- if needed, merge the `xpack` branch

No need to add a tag here, it'll be added when the release is created.

### Increase the version

Determine the version (like `3.19.8`) and update the `scripts/VERSION`
file; the format is `3.19.8-1`. The fourth number is the xPack release number
of this version. A fifth number will be added when publishing
the package on the `npm` server.

### Fix possible open issues

Check GitHub issues and pull requests:

- <https://github.com/xpack-dev-tools/cmake-xpack/issues/>

and fix them; assign them to a milestone (like `3.19.8-1`).

### Check `README.md`

Normally `README.md` should not need changes, but better check.
Information related to the new version should not be included here,
but in the version specific release page.

### Update versions in `README` files

- update version in `README-RELEASE.md`
- update version in `README-BUILD.md`
- update version in `README.md`

## Update `CHANGELOG.md`

- open the `CHANGELOG.md` file
- check if all previous fixed issues are in
- add a new entry like _v3.19.8-1 prepared_
- commit with a message like _prepare v3.19.8-1_

Note: if you missed to update the `CHANGELOG.md` before starting the build,
edit the file and rerun the build, it should take only a few minutes to
recreate the archives with the correct file.

### Update the version specific code

- open the `common-versions-source.sh` file
- add a new `if` with the new version before the existing code

### Update helper

With Sourcetree, go to the helper repo and update to the latest master commit.

### Merge upstream repo

To keep the development repository fork in sync with the upstream CMake
repository, in the `xpack-dev-tools/cmake` Git repo:

- checkout `master`
- merge from `upstream/master`
- checkout `xpack-develop`
- merge `master`
- fix conflicts (in `60-cmake.rules` and possibly other)
- checkout `xpack`
- merge `xpack-develop`

Possibly add a tag here.

## Build

### Development run the build scripts

Before the real build, run a test build on the development machine (`wks`)
or the production machine (`xbbm`):

```sh
sudo rm -rf ~/Work/cmake-*

caffeinate bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --osx
```

Similarly on the Intel Linux (`xbbi`):

```sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --linux64
bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --linux32

bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --win64
bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --win32
```

And on the Arm Linux (`xbba`):

```sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --arm64
bash ~/Downloads/cmake-xpack.git/scripts/helper/build.sh --develop --without-pdf --without-html --disable-tests --arm32
```

Work on the scripts until all platforms pass the build.

## Push the build scripts

In this Git repo:

- push the `xpack-develop` branch to GitHub
- possibly push the helper project too

From here it'll be cloned on the production machines.

## Run the CI build

The automation is provided by GitHub Actions and three self-hosted runners.

- on the macOS machine (`xbbm`) open ssh sessions to both Linux
machines (`xbbi` and `xbba`):

```sh
caffeinate ssh xbbi

caffeinate ssh xbba
```

Start the runner on all three machines:

```sh
~/actions-runner/run.sh
```

Check that both the project Git and the submodule are pushed to GitHub.

To trigger the GitHub Actions build, use the xPack action:

- `trigger-workflow-build`

This is equivalent to:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/trigger-workflow-build.sh
```

This script requires the `GITHUB_API_DISPATCH_TOKEN` to be present
in the environment.

This command uses the `xpack-develop` branch of this repo.

The builds take about 14 minutes to complete.

The workflow result and logs are available from the
[Actions](https://github.com/xpack-dev-tools/cmake-xpack/actions/) page.

The resulting binaries are available for testing from
[pre-releases/test](https://github.com/xpack-dev-tools/pre-releases/releases/tag/test/).

## Testing

### CI tests

The automation is provided by GitHub Actions.

To trigger the GitHub Actions tests, use the xPack actions:

- `trigger-workflow-test-prime`
- `trigger-workflow-test-docker-linux-intel`
- `trigger-workflow-test-docker-linux-arm`

These are equivalent to:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/tests/trigger-workflow-test-prime.sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/tests/trigger-workflow-test-docker-linux-intel.sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/tests/trigger-workflow-test-docker-linux-arm.sh
```

These scripts require the `GITHUB_API_DISPATCH_TOKEN` to be present
in the environment.

These actions use the `xpack-develop` branch of this repo and the
[pre-releases/test](https://github.com/xpack-dev-tools/pre-releases/releases/tag/test/)
binaries.

The tests results are available from the
[Actions](https://github.com/xpack-dev-tools/cmake-xpack/actions/) page.

Since GitHub Actions provides a single version of macOS, the
multi-version macOS tests run on Travis.

To trigger the Travis test, use the xPack action:

- `trigger-travis-macos`

This is equivalent to:

```sh
bash ~/Downloads/cmake-xpack.git/scripts/helper/tests/trigger-travis-macos.sh
```

This script requires the `TRAVIS_COM_TOKEN` to be present in the environment.

The test results are available from
[travis-ci.com](https://app.travis-ci.com/github/xpack-dev-tools/cmake-xpack/builds/).

### Manual tests

Install the binaries on all platforms.

```sh
xpm install --global @xpack-dev-tools/cmake@next
```

On GNU/Linux systems, including Raspberry Pi, use the following commands:

```sh
~/.local/xPacks/@xpack-dev-tools/cmake/3.19.8-1.1/.content/bin/cmake --version

cmake version 3.19.8

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

On macOS, use:

```sh
~/Library/xPacks/@xpack-dev-tools/cmake/3.19.8-1.1/.content/bin/cmake --version

cmake version 3.19.8

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

On Windows use:

```doscon
%USERPROFILE%\AppData\Roaming\xPacks\@xpack-dev-tools\cmake\3.19.8-1.1\.content\bin\cmake --version

cmake version 3.19.8

CMake suite maintained and supported by Kitware (kitware.com/cmake).
```

## Create a new GitHub pre-release draft

- in `CHANGELOG.md`, add release date
- commit and push the `xpack-develop` branch
- run the xPack action `trigger-workflow-publish-release`

The result is a
[draft pre-release](https://github.com/xpack-dev-tools/cmake-xpack/releases/)
tagged like **v3.19.8-1** (mind the dash in the middle!) and
named like **xPack CMake v3.19.8-1** (mind the dash),
with all binaries attached.

## Prepare a new blog post

Run the xPack action `generate-jekyll-post`; this will leave a file
on the Desktop.

In the `xpack/web-jekyll` GitHub repo:

- select the `develop` branch
- copy the new file to `_posts/releases/cmake`

If any, refer to closed
[issues](https://github.com/xpack-dev-tools/cmake-xpack/issues/).

## Update the preview Web

- commit the `develop` branch of `xpack/web-jekyll` GitHub repo;
  use a message like **xPack CMake v3.19.8-1 released**
- push to GitHub
- wait for the GitHub Pages build to complete
- the preview web is <https://xpack.github.io/web-preview/news/>

## Create the pre-release

- go to the GitHub [releases](https://github.com/xpack-dev-tools/cmake-xpack/releases/) page
- perform the final edits and check if everything is fine
- save the release

Note: at this moment the system should send a notification to all clients
watching this project.

## Update package.json binaries

- select the `xpack-develop` branch
- run the xPack action `update-package-binaries`
- open the `package.json` file
- check the `baseUrl:` it should match the file URLs (including the tag/version);
  no terminating `/` is required
- from the release, check the SHA & file names
- compare the SHA sums with those shown by `cat *.sha`
- check the executable names
- commit all changes, use a message like
  `package.json: update urls for 3.19.8-1.1 release` (without `v`)

## Publish on the npmjs.com server

- select the `xpack-develop` branch
- check the latest commits `npm run git-log`
- update `CHANGELOG.md`; commit with a message like
  _CHANGELOG: publish npm v3.19.8-1.1_
- `npm pack` and check the content of the archive, which should list
  only the `package.json`, the `README.md`, `LICENSE` and `CHANGELOG.md`;
  possibly adjust `.npmignore`
- `npm version 3.19.8-1.1`; the first 5 numbers are the same as the
  GitHub release; the sixth number is the npm specific version
- push the `xpack-develop` branch to GitHub
- push tags with `git push origin --tags`
- `npm publish --tag next` (use `--access public` when publishing for
  the first time)

After a few moments the version will be visible at:

- <https://www.npmjs.com/package/@xpack-dev-tools/cmake?activeTab=versions>

## Test if the npm binaries can be installed with xpm

Run the `scripts/tests/trigger-travis-xpm-install.sh` script, this
will install the package via `xpm install` on all supported platforms.

The test results are available from:

- <https://travis-ci.com/github/xpack-dev-tools/cmake-xpack>

## Update the repo

- merge `xpack-develop` into `xpack`
- push to GitHub

## Tag the npm package as `latest`

When the release is considered stable, promote it as `latest`:

- `npm dist-tag ls @xpack-dev-tools/cmake`
- `npm dist-tag add @xpack-dev-tools/cmake@3.19.8-1.1 latest`
- `npm dist-tag ls @xpack-dev-tools/cmake`

## Update the Web

- in the `master` branch, merge the `develop` branch
- wait for the GitHub Pages build to complete
- the result is in <https://xpack.github.io/news/>
- remember the post URL, since it must be updated in the release page

## Create the final GitHub release

- go to the GitHub [releases](https://github.com/xpack-dev-tools/cmake-xpack/releases/) page
- check the download counter, it should match the number of tests
- add a link to the Web page `[Continue reading »]()`; use an same blog URL
- **disable** the **pre-release** button
- click the **Update Release** button

## Share on Twitter

- in a separate browser windows, open [TweetDeck](https://tweetdeck.twitter.com/)
- using the `@xpack_project` account
- paste the release name like **xPack CMake v3.19.8-1 released**
- paste the link to the Web page
  [release](https://xpack.github.io/cmake/releases/)
- click the **Tweet** button

## Remove pre-release binaries

- go to <https://github.com/xpack-dev-tools/pre-releases/releases/tag/test/>
- remove the test binaries
