---
title: "HugoのMediaType.Suffixのエラーの原因と対処法"
date: 2021-04-11T04:44:50+09:00
draft: false
toc: false
images:
tags: 
  - "hugo"
---

## hugoの今回のエラー内容
* OSはArchlinuxで、hugoのバージョンはhugo v0.82.0+extended

いつも通りブログを書き終えた後、hugoコマンドを実行すると、以下のようなエラーが出た。
```bash
render of "term" failed: "----/_default/bas
eof.html:16:97": execute of template failed: template: _default/list.html:16:97: executing "_default/list.html"
 at <.MediaType.Suffix>: can't evaluate field Suffix in type media.Type
```

## 原因

2021年3月21日にhugo 0.82がリリースされた。[リリースノート](https://gohugo.io/news/0.82.0-relnotes/)によると、どうやらhugoの仕様が変更され、これまでのMediaType.SuffixがMediaType.FirstSuffix.Suffixに変更されたらしい。

> We have made .MediaType comparable ba1d0051 @bep #8317#8324. This also means that the old MediaType.Suffix and MediaType.FullSuffix is moved to MediaType.FirstSuffix.Suffix and MediaType.FirstSuffix.FullSuffix, which also better describes what they represent.


[引用元](https://gohugo.io/news/0.82.0-relnotes/#notes)

## 対処法

ということで、baseof.html中に記載されていたMediaType.SuffixをMediaType.FirstSuffix.Suffixに書き換えることで、hugoコマンドが通るようになった。

