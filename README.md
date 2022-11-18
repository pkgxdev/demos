![tea](https://tea.xyz/banner.png)

# One-Liners

* `sh <(curl tea.xyz)` can be replaced with `tea` in all examples
* Be safe use `sh <(curl https://tea.xyz)`. We withhold the https to reduce visual noise in our examples.

```sh
# launch a web-server for `$PWD` in your browser (with _file_watching_)

$ sh <(curl tea.xyz) -X npx --yes browser-sync start --server
```


# Hello Universe

The `tea` “Hello World”.

```sh
$ tea https://github.com/teaxyz/demos/blob/main/hello-universe.sh
```
