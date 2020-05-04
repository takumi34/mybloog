---
title: "メインマシンをArch Linuxに移行した話とその環境構築メモ"
date: 2020-05-04T10:50:39+09:00
draft: false
toc: false
images:
tags: 
  - "Arch Linux"
  - "Linux"
---

* メインマシンとしてUbuntuを愛用していたのだが、つい先日Ubuntu20.04がLTS版として出たので、バージョンを上げたところ、調子が悪くなった（networkmanagerが問題なのではないかと思うのだけど、原因不明。起動してしばらくするとネットに繋がらなくなるし、ターミナルからコマンドも実行できなくなる。再起動もできなくなるという感じ。）ので、これを機にArch Linuxへ乗り換えることにした。

## Arch Linuxとは
* Simplicityを謳っているOSで、インストール時は本当に何も入っていないというぐらい何も入っていない。
* ローリングアップデートの方式なので、常にOSを最新の状態にできる。

(今思えば、UbuntuはUSBを挿してインストールすればほぼ環境構築が終わったようなものだったのだなと思う。)


## 環境構築メモ
* 基本的には[Arch wikiのInstallation guide](https://wiki.archlinux.org/index.php/installation_guide)を読んでその通りにやった。

* 大まかに重要そうなところ、つまずいたところを以下に記す。

### パーティション
* パーティションは/dev/nvme0n1と/dev/nvme0n2でそれぞれEFIとrootにした。
* gdiskでパーティションを切った。

### フォーマット
* EFIはFAT32で、rootはext4でフォーマット。
```bash
mkfs.vfat -F32 /dev/nvme0n1
mkfs.ext4 /dev/nvme0n2
```

## マウント
* 特になし

## ベースシステムのインストール
* pacstarpでインストールできる。ここはarch wikiの通りにやった。まとめて他のも入れられるが、ここで入れすぎると何か起きたときに問題の切り分けができないので最小限に留めておくのがいいらしい。
* ここでLinuxカーネルやファームウェアなどをインストールする。

### ブートローダ
* GRUBを使った。
* UEFIのブートローダとしてはsystemd-bootとGRUBが有名どころだと思うけど、どっちの方がいいのかは正直分からない。
* GRUBの使い方もArchwikiを参照するとよい。


* この後は再起動してちゃんと動けば、インストール成功。
* [この記事も参考になった](https://qiita.com/panakuma/items/471643138db11335d542)

* ただこの時点ではデスクトップ環境が入ってないので、それをこれから入れていく。

### デスクトップ
* xfceを使った。
* UbuntuのときはGNOMEを使っていたが、以前から気になっていたxfceにした。
（本当はi3wmにしたいのだけど、操作が難しいので、一旦保留）

### ディスプレイマネージャ
* lightdmにした。
* [テーマはこれを参考にした](https://qiita.com/Hayao0819/items/7784178c7fd568291905)
* [自動ログインの設定はこれ](https://wiki.archlinux.jp/index.php/LightDM#.E8.87.AA.E5.8B.95.E3.83.AD.E3.82.B0.E3.82.A4.E3.83.B3.E3.82.92.E6.9C.89.E5.8A.B9.E3.81.AB.E3.81.99.E3.82.8B)

* 実はlightdmを入れたあとに再起動したら、"can't find session"のような文言が表示されてログインできないという事象が発生した。でも、これはただこの時点でxfceを入れ忘れていたから、デスクトップのセッションが見つからないというだけだった（これに気づかず時間を消費した...)

### その他の環境構築

#### スピーカ、マイクの設定
* pulseaudioを入れた。
* これも[Archwiki](https://wiki.archlinux.jp/index.php/PulseAudio)を見るといい。
```bash
yay -S pulseaudio pavucontrol
```

* スピーカとしてディスプレイのスピーカが認識されていなかったのだけど、これもarchwikiを参考に設定した。
* /etc/pulse/default.paに設定を書いていく。
* set-default-sinkとset-default-sourceにモニターのスピーカ設定を書く。
```bash
### Make some devices default
set-default-sink alsa_output.pci-0000_00_1f.3.hdmi-stereo
#set-default-source input
set-default-source alsa_output.pci-0000_00_1f.3.hdmi-stereo.monitor
```

* マイクも認識されていなかったので、[これまたArchwikiを参考に解決](https://wiki.archlinux.jp/index.php/PulseAudio/%E3%83%88%E3%83%A9%E3%83%96%E3%83%AB%E3%82%B7%E3%83%A5%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0#.E3.83.9E.E3.82.A4.E3.82.AF.E3.81.8C_PulseAudio_.E3.81.8B.E3.82.89.E8.AA.8D.E8.AD.98.E3.81.95.E3.82.8C.E3.81.AA.E3.81.84)


#### ディスプレイ設定
* 映像を流すとディスプレイに線が入ったりしたので、refresh rateの設定の問題か？と思い、Xの設定やdisplay.xmlなどをいじったりしていたが、結局はドライバーを入れたら解決した。
* intelなのでこれ
```bash
pacman -Ss xf86-video
```

#### 日本語環境

* fcitx-mozcを入れた。
* ログイン時に以下を流す。
```bash
fcitx-autostart
```
* 日本語のフォントも入れておく。


### kindle for PCのインストール
* 基本的にはArch User Repositoryを使えば、vscodeもchromeも大体簡単にインストールできるのだけど、kindleはそうは行かないので、wine経由で入れる。
* wine-5.7でwineの中のwindowsのバージョンをwindows8.1にして、kindleのkindle-for-pc-1-17-44170.exeを入れる。
* 以上のバージョンを合わせないとうまくインストールができない。特に、kindleのインストーラーのバージョンを色々試した結果、1-17-44170ならうまく入った。
* Ubuntuでも同じことをやったのだけど、バージョンを忘れたので、何度も試すことになったので、これもメモしておく。

### wifi設定
* これもArchwikiを読む。[NetworkManager](https://wiki.archlinux.jp/index.php/NetworkManager)
* nmcliでコマンドが打てる。
```bash
nmcli dev wifi connect <name> password <password>
```
* xfceだと以下をインストールしておく。[ここで紹介されている](https://wiki.archlinux.jp/index.php/NetworkManager#Xfce)
```bash
pacman -S network-manager-applet xfce4-notifyd gnome-keyring
``` 

## まとめ

* 環境構築メモとして、これを書き残しておく。
* 今回、Arch Linuxの環境構築をして、デスクトップOSの仕組みについて詳しくなった（気がする）。
* Ubuntuを使っていたときはインストール時から様々な環境がすでに込み込みなので、特に何も考えずすぐ使えるのだけど、Arch Linuxは初めはほんとに何も入ってない。なので、自分で好きなものをどんどん入れていってカスタマイズしていくので、裏側でどういうものが動いているかというのがよく分かる。
* Arch wikiは凄い。ほんとに色々載っているので非常に助かる。   


***「Arch Linux最高。」という言葉で締めくくりたい。万人におすすめできるOSである。***














