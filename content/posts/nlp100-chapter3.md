---
title: "自然言語処理100本ノック第3章を解く（前編）"
date: 2020-05-06T17:09:11+09:00
draft: false
toc: false
images:
tags: 
  - 'NLP'
  - 'Regex'
---

 * [自然言語処理100本ノック2020](https://nlp100.github.io/ja/)の第3章をやる。前編なので20から24まで。
 * 今回は正規表現の回。
 * 正規表現は便利なので簡単なのものはよく書くけれど、やっぱり難しい。プログラム合成で正規表現を合成してほしい。

### 実施した内容
* [コードはここに置いてある](https://github.com/takumi34/nlp_100)
#### 20
* コード
```py
import json

with open('jawiki-country.json', mode='r', encoding='utf-8') as f:
    for i in f:
        article = json.loads(i)
        if 'イギリス' == article['title']:
            print(article['text'])
```

* openした後にcloseするのをよく忘れる人はwithを使うようにって大学のときに聞いた気がする。


* これは以後の課題でも使うので、以下のようにモジュールにしておく。


ch3_func.py
```py
import json

def extract_uk_text():
    with open('jawiki-country.json', mode='r', encoding='utf-8') as f:
        for i in f:
            article = json.loads(i)
            if 'イギリス' == article['title']:
                return article['text']
```

#### 21
* コード
```py
from modules import ch3_func

import re

text = ch3_func.extract_uk_text()
pattern = '\[\[Category:.*?\]\]'
results = re.findall(pattern,text)

for i in results:
  print(i)
```

* 出力
```bash
[[Category:イギリス|*]]
[[Category:イギリス連邦加盟国]]
[[Category:英連邦王国|*]]
[[Category:G8加盟国]]
[[Category:欧州連合加盟国|元]]
[[Category:海洋国家]]
[[Category:現存する君主国]]
[[Category:島国]]
[[Category:1801年に成立した国家・領域]]
```

* 正規表現登場。
* findallは便利だ。

#### 22
* コード
```py
from modules import ch3_func

import re

text = ch3_func.extract_uk_text()
pattern = '\[\[Category:(.*?)(?:\|.*)?\]\]'
results = re.findall(pattern,text)

for i in results:
  print(i)
```
* 出力
```bash
イギリス
イギリス連邦加盟国
英連邦王国
G8加盟国
欧州連合加盟国
海洋国家
現存する君主国
島国
1801年に成立した国家・領域
```

* '|*'みたいなのが付いているのを正規表現の'?:'で外した。

#### 23
* コード
```sh
from modules import ch3_func

import re

text = ch3_func.extract_uk_text()
pattern = '(==+)(.*?)==+'
results = re.findall(pattern, text)

for i in results:
    level = i[0].count('=') - 1
    section_name = i[1]
    print('%d: %s' % (level, section_name))
```

#### 24
* コード
```sh
from modules import ch3_func

import re

text = ch3_func.extract_uk_text()
pattern = '\[\[ファイル:(.*?)(?:\|.*)?\]\]'
results = re.findall(pattern,text)

for i in results:
  print(i)
```
* 22とやってることは同じ

## 感想

* 正規表現は正直難しい。今のところはそこまで複雑じゃないが、複雑になればなるほど人間には解読不能になると思っている...
* まだ『詳説　正規表現』を読んだことがないので、これを機会に読みたいと思う。

* もっと良いやり方があったらコメントで教えてください。