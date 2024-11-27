# Add package to repo action

This action adds a package to a pacman repository stored remotely in an object storage.

## Inputs

## `repository`

**Required** The name of the pacman repository.

## `package`

**Required** Absolute file path to the package that will be added to repository.

## `rclone-bucket`

**Required** Remote destination bucket where the repository data is stored.

## Example usage

```yaml
name: Add package to repository
uses: ./.github/actions/add-pkg-to-repo
env:
  RCLONE_CONFIG_SECRET: ${{ secrets.RCLONE_CONFIG }}
with:
  repository: "foo"
  package: ${{ github.workspace }}/my-pkg-1.0.0-1.aarch64.pkg.tar.xz
  rclone-bucket: "s3:my-bucket/archlinux/aarch64"
```
