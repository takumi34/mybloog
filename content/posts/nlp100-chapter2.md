---
title: "自然言語処理100本ノック第2章を解く"
date: 2020-05-01T11:09:14+09:00
draft: false
toc: false
images:
tags: 
  - 'NLP'
  - 'UNIX'
---

* [自然言語処理100本ノック2020](https://nlp100.github.io/ja/)を第1章に引き続き、第2章をやる。今回はUNIXコマンドでテキストの処理をするという章。
* 普段からgrepとかsedとかはよく使っているが、改めて今回やってみるとパラメータの指定など、気付きが多かった。
### 実施した内容
* [コードはここに置いてある](https://github.com/takumi34/nlp_100)
#### 10
* コード
```sh
wc -l < popular-names.txt
```
* 出力
```sh
2780
```

#### 11
* コード
```sh
tr  '\t' ' ' < popular-names.txt > popular-names2.txt 
```

#### 12
* コード
```sh
cut -d ' ' -f 1 popular-names2.txt > col1.txt
cut -d ' ' -f 2 popular-names2.txt > col2.txt
```

#### 13
* コード
```sh
paste  col1.txt col2.txt > marge.txt
```

#### 14
* コード
```sh
head -n 4 popular-names.txt
```

#### 15
* コード
```sh
tail -n 4 popular-names.txt
```

#### 16
* コード
```sh
split -n 3 -d popular-names.txt split-
```

* popular-names.txtを行単位で三分割して、split-00.txtとsplit-01.txtとsplit-02.txtを作成する。

#### 17
* コード
```sh
cut -f 1 popular-names.txt | sort | uniq
```

* uniqをかける前にsortする。C++でやりなれた操作。（uniqueする前にsortを忘れがちなので、そのマクロを組んでいるぐらい笑。）

#### 18
* コード
```sh
sort -rk 3  popular-names.txt
```

#### 19
* コード
```sh
cut -f 1 popular-names.txt | sort | uniq -c | sort -nrk 1 | awk '{print $2}'
```

* uniq -cでそれぞれの数が出せるので、それをsort。
* sortしただけだと、数値、テキストが出力されるので、awkで2列目だけを出力。

### 感想
* 『UNIXという考え方』という本を昔読んだけれど、UNIXコマンドにはそのUNIX哲学が強く現れていると思う。パイプを使って、それぞれのコマンドをつなぎ合わせることによって、非常に強力な処理が可能となる。大昔に作られたものが現代でもこれほど便利に使えるというのはやはり凄いことだ。今回改めてそう感じた。

* もっと良いやり方があったらコメントで教えてください。