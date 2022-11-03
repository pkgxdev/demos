# Favicon Cheat Sheet

Nowadays you cannot make do without a favicon for your site. What are they
for? How do you make them? What do you do with them? We’re here to answer
your questions.

## Requirements

We want either a very large bitmap image (typically [PNG]) or (better) a
vector image (typically [SVG]).

## The `favicon.ico`

Internet Explorer (RIP) pioneered the idea of the favicon. And to this day
you will see numerous hits to your web server for `GET /favicon.ico`

Even though there are definitely better ways to document and deliver your
favicons in this day and age, we still recommend you create a `favicon.ico`
and stick it at the root of your webserver:

```sh
for size in 16 32 48; do
  convert $1 -resize ${size}x${size} favicon-$size.png
  optipng -o7 favicon-$size.png
done
```

The above uses imagemagick.org’s `convert` to resize your input file to a
16x16, 32x32 and 48x48 representation and then `optipng` to reduce the file
size as much as possible.
Originally the only supported option was 16 square pixels
(this was waaaay before retina screens), and the image had to be in ICO
format (basically uncompressed pixel data, but considering we're talking 256
pixels it was considered OK). However 16 square pixels is barely any
information so people started using the fact that ICO images can contain
multiple representations of an image to their advantage:

```sh
convert favicon-{16,32,48}.png favicon.ico
```

Above we use imagemagick.org to convert our three sizes of favicon into a
single `favicon.ico` output.

In your HTML you would add the following, though it is not required and in
many cases people recommend *against* it:

```html
<link rel="icon" href="/favicon.ico" sizes="16x16,32x32,48x48">
```

## Modern Sizes

```sh
convert $1 -resize 192x192 apple-touch-icon.png
optipng -o7 apple-touch-icon.png
```

```html
<link rel="icon" sizes="196x196" href="/apple-touch-icon.png">
```

## Contributing to this README

This is a demonstration example for tea.xyz, however pull requests are
welcome. If your contribution is non-trivial please open a discussion *first*.

## Executing /w tea.xyz

This README can be executed with tea.xyz.

```sh
sh <(curl tea.xyz) \
  https://github.com/teaxyz/demos/blob/main/favicon-cheat-sheet.md \
  input.png
```

## Dependencies

| Project                | Version |
|------------------------|---------|
| optipng.sourceforge.io | 1       |
| imagemagick.org        | 7       |


## Thanks

https://github.com/audreyfeldroy/favicon-cheat-sheet


[PNG]: https://en.wikipedia.org/wiki/Portable_Network_Graphics
[SVG]: https://developer.mozilla.org/en-US/docs/Web/SVG
