---
title: "自然言語処理100本ノック第1章を解く"
date: 2020-04-30T16:25:34+09:00
draft: false
toc: false
images:
tags: 
  - "NLP"
  - "Python"
---


* [自然言語処理100本ノック2020](https://nlp100.github.io/ja/)が公開されたので、解いてみた。
* 2015年のバージョンは昔少しだけ解いたことがあったが、全部やってたわけではないので、これからやっていきたいと思う。


### 実施した内容
* [コードはここに置いてある](https://github.com/takumi34/nlp_100)
#### 00
* コード
```py
print('stressed'[::-1])
```
* 出力
```bash
desserts
```
#### 01

* コード
```py
a = 'パタトクカシーー'
print(a[0] + a[2] + a[4] + a[6])
```
* 出力
```bash
パトカー
```
#### 02
* コード
```py
a = 'パトカー'
b = 'タクシー'
c = ''
for i in range(4):
    c += a[i] + b[i]
print(c)


```
* 出力
```bash
パタトクカシーー
```


#### 03
* コード
```py
a = 'Now I need a drink, alcoholic of course, after the heavy lectures involving quantum mechanics.'
a = a.replace(',','').replace('.','')
b = a.split()
l = []
for i in range(len(b)):
    l.append(len(b[i]))
print(l)
```
* 出力
```bash
[3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5, 8, 9, 7, 9]
```

#### 04
* コード
```py
a = 'Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign Peace Security Clause. Arthur King Can.'

a = a.replace(',', '').replace('.', '')
b = a.split()
l = []
for i in range(len(b)):
    if i + 1 in [1, 5, 6, 7, 8, 9, 15, 16, 19]:
        l.append([b[i][0], i + 1])
    else:
        l.append([b[i][0:2], i + 1])
print(dict(l))
```
* 出力
```bash
{'H': 1, 'He': 2, 'Li': 3, 'Be': 4, 'B': 5, 'C': 6, 'N': 7, 'O': 8, 'F': 9, 'Ne': 10, 'Na': 11, 'Mi': 12, 'Al': 13, 'Si': 14, 'P': 15, 'S': 16, 'Cl': 17, 'Ar': 18, 'K': 19, 'Ca': 20}
```

#### 05
* コード
```py
def ngram(text, n):
    list = []
    tsize = len(text)
    for i in range(tsize - n + 1):
        list.append(text[i:i + n])
    return list

a = "I am an NLPer"
print(ngram(a, 2))  #文字bi-gram
print(ngram(a.split(' '), 2))  #単語bi-gram
```
* 出力
```bash
['I ', ' a', 'am', 'm ', ' a', 'an', 'n ', ' N', 'NL', 'LP', 'Pe', 'er']
[['I', 'am'], ['am', 'an'], ['an', 'NLPer']]
```
#### 06
* コード
```py
def ngram(text, n):
    list = []
    tsize = len(text)
    for i in range(tsize - n + 1):
        list.append(text[i:i + n])
    return list


a = "paraparaparadise"
b = "paragraph"

abi = set(ngram(a, 2))
bbi = set(ngram(b, 2))

print(abi | bbi)  #和集合
print(abi & bbi)  #積集合
print(abi - bbi)  #差集合
print("ok" if "se" in (abi or bbi) else "no")
```
* 出力
```bash
{'ap', 'ag', 'ad', 'gr', 'ar', 'se', 'ph', 'ra', 'di', 'pa', 'is'}
{'pa', 'ap', 'ra', 'ar'}
{'di', 'is', 'ad', 'se'}
ok
``` 


#### 07
* コード
```py
def temp(x, y, z):
    return "%s時の%sは%s" % (x, y, z)

print(temp(12, "気温", 22.4))

```
* 出力
```bash
12時の気温は22.4
```

#### 08
* コード
```py
def cipher(s):
    res = []
    for i in s:
        if (i.islower()):
            res.append(chr(219 - ord(i)))
        else:
            res.append(i)
    return ''.join(res)


text = "chika chika"
a = cipher(text)
print(a)
b = cipher(a)
print(b)

```
* 出力
```bash
xsrpz xsrpz
chika chika
```


#### 09
* コード
```py
import random


def typogly(s):
    if (len(s) <= 4):
        return s
    else:
        res = [s[0]] + random.sample(list(s[1:-1]), len(s[1:-1])) + [s[-1]]
        return "".join(res)


a = "I couldn’t believe that I could actually understand what I was reading : the phenomenal power of the human mind ."

res = " ".join([typogly(i) for i in a.split()])
print(res)
```
* 出力
```bash
I cdlun’ot bivelee that I colud atlucaly uasrenndtd what I was reidang : the peahnemonl poewr of the haumn mind .
```


### 感想

* 久々にPythonを書くと、色々と気付きが多かった。あと、やはり動的型付け言語はつらいものがあるので、出来れば書きたくないなと笑。
* Python的な内包表記は極力書かないようにした。キレイに書けそうだなというときは使ったけれど、基本的には普通に書いた方が読みやすいと思っているので。
* もっと良い書き方あったらコメントで教えてください。