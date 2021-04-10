---
title: "pandocを使用してreveal.jsのスライドを生成する方法"
date: 2021-04-11T03:01:43+09:00
draft: false
toc: false
images:
tags: 
  - "pandoc"
  - "revealjs"
---

簡易なスライドを作成するとき、pandocを使用してreveal.js形式のスライドを生成しているのだが、毎回その方法を忘れるので、メモとしてこれを残す。

## pandocとは
* [pandoc](https://pandoc.org/)とは、ドキュメントを様々なフォーマットに変換することのできるツールである。例えば、markdownで記入した文章をLaTexやPDFに変換するということが出来る。

## reveal.jsとは
* [reveal.js](https://revealjs.com/)とは、HTMLプレゼンテーションフレームワークで、例えば[こんな感じ](https://takumi34.github.io/sample_revealjs/sample.html)のスライドを簡単に作ることができる便利なツールである。HTMLなので、CSSを調整すれば、色々とデザインの工夫も出来る。

## スライドの作成方法
* pandocを使うことでmarkdownをreveal.js形式に変換することが出来るので、その機能を活用する。

以下で具体的な手順を述べる。

1. まずpandocをインストールする(Arch Linux)
```bash
yay -S pandoc
```

2. reveal.jsをcloneする
```bash
git clone https://github.com/hakimel/reveal.js.git
```

基本的には環境構築は以上で、あとはmarkdownを用意して、それをpandocで変換するだけである。

### ディレクトリ構成（例）
```bash
sample-reveal
├── Makefile
├── README.md
├── images
│   └── sample.svg
├── input.md
├── reveal.js 
├── style.css
```

* ディレクトリ構成の説明
  * images配下にはスライドで使用する画像を配置してある
  * Makefileにはpandocの変換コマンドやgithub pagesへのアップロードなど、よく使うコマンドをまとめている
  * input.mdは変換対象となるmarkdownファイル
  * style.cssは変換する際に適用されるcss（わざわざcssファイルを用意しなくてもデフォルトのものがあるので、そのテーマを使うことも出来る）

* 変換に必須なのはimput.mdとreveal.js


### pandocの使い方
* pandocでreveal.jsに変換する際のコマンド（例）
```bash
pandoc -t revealjs -s -c style.css -V transition=fade --self-contained input.md -o index.html  --slide-level=2
```

私はよくこのコマンドをよく使うので、これをMakefileにまとめている。
* pandocの詳しい使い方は[公式ガイド](https://pandoc.org/MANUAL.html)を参照。用途に合わせて、先程のコマンドを工夫すればよい。


以上のコマンドを実行すると、index.htmlが出力されるので、それをgithub pagesなどにアップロードすれば、簡単にホストすることが可能だ。

* 例えば以下のmarkdownを変換すると

```md
% These are sample slides
% chika


# sample

hi hello

## sample2

hi
hey
### sample3
```

[こんな感じ](https://takumi34.github.io/sample_revealjs/sample.html)
のスライドが生成できる。


reveal.js特有のmarkdownの記法については[公式ガイド](https://revealjs.com/markdown/)を参照。シンタックスハイライトを入れたり、画像を挿入したり、HTMLをそのまま書き込んだりすることもできる。

## まとめ

* pandocは便利！みんな使おう。

#### 参考文献
* https://dev.to/berry_clione/set-up-to-convert-a-markdown-file-to-revealjs-slides-by-pandoc-58n5
* https://mickey-happygolucky.hatenablog.com/entry/2019/04/01/153812

