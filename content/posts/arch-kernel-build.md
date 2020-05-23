---
title: "Arch Linuxでカーネルビルドをした話"
date: 2020-05-23T15:55:55+09:00
draft: false  
toc: false
images:
tags: 
  - "Arch Linux"
  - "kernel"
---

* Arch Linuxでカーネルビルドしたので、その時のメモ。
* [archwiki](https://wiki.archlinux.org/index.php/Kernel/Traditional_compilation)を参考にビルドを行った。今回はtraditionalな方法を使ったので、手動でやることが多い。

## ビルド方法
* まずはkernel.orgから最新のカーネルのソースを取って来てから解凍。
```bash
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.14.tar.xz
tar xJf linux-5.6.14.tar.xz 
```

* gccのバージョンが10.1.0だと新しすぎるせいかエラーが出たので、gcc-8をインストールした。
```bash
yay -S gcc8
export CC=gcc-8
```

* 念の為、一度きれいにしておく。このコマンドで初期状態に戻せる。
```bash
make mrproper
```

* archのデフォルトのconfigを取ってくる。他のディストリだとconfigはboot以下にあることが多いらしいがarchだと以下にある。
```bash
zcat /proc/config.gz > .config
```

* ここからカーネルのコンパイル。初め、yes ' 'とスペースを渡していたので失敗していた笑。
* make oldconfigをすると、configを更新できる。yesを渡さないと色々設定を聞かれる。
```bash
yes ''| make oldconfig
make > ../linux5-6-14.log 2>&1 &
```
* モジュールをインストール。
```bash
make modules_install
```

* コンパイルしたカーネルをbootディレクトリにコピー。コンパイルしたカーネルはarch以下にbzImageとして生成されるので、それをboot以下にコピーする。vmlinuzという名前を慣習的に付けるらしい。
```bash
cp -v arch/x86_64/boot/bzImage /boot/vmlinuz-chika
```

* RAMディスクの作成はarchwikiの通り。これでinitramfsができる。

* System.mapのコピーもarchwikiの通り。

* あとはブートローダの設定。grubを使っているので以下で新しいgrub.cfgに書き換える。
```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

* これでrebootするとビルドしたカーネルで立ち上がった。

## 感想
* archwikiの通りにやるだけで簡単にカーネルビルドできるかと思ったら、そう簡単には行かなかった。gccのバージョンであったり、karnelのバージョンによってもうまく行かないものがあった（これはバグかも）。
* とりあえず、これでカーネルビルドする手順と仕組みが分かったので、また一つ前進したと思う。
* 今度はカーネルのソースをいじってから、ビルドしてみて、どうなるかをやってみたいと思う。
