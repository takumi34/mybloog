---
title: "Line Dev Day 2019に行ってきた話"
date: 2019-11-22T04:40:32+09:00
draft: false
toc: false
images:
tags:
  - "tech-conference"
  - "Line"
---

## Line Dev Day とは{{< figure src="/images/line-dev-day.jpg" title="LINE DEV DAY会場" class="center" width="320" height="640" >}}

- 正式名称は LINE DEVELOPER DAY、LINE 社のカンファレンスで 2015 年から開催されている。今年は 11/21-11/22 にお台場で開催された。私は今回両日ともに参加した。私は以前LINEにエンジニアインターンに参加していたということもあってLine Dev Dayに参加したいと思っていた。

## まず驚いたこと

- 受付では顔認証による参加者確認が行われていた。私は LINE アプリによる確認を行うレーンに並んで板が、やはり顔認証確認の方が受付のスピードが早かったように感じた。精度も良いのではないだろうか。

## カンファレンスの内容について

- 発表は、キーノート、セッション、ブース、ポスター発表、各種ハンズオンという構成になっている。
- 両日とも午前中はキーノート、午後にセッションなどがある。セッションには各業界の有名人を招待しているようだった。例えば、甘利さんや徳丸さんが招待されていた。
- 今回、二日間で私は一回２時間のハンズオンを２つ受けたのでセッションはあまり聞けなかった。
- 以下で私が聞いて面白かったと思うセッションやハンズオンについて紹介したいと思う。

## ハンズオン

### Learning Session について

- 一日目には「仕事をよりクリエイティブにするための『Learning Session』の実践」というハンズオンを受けた。
- Learning Session とは LINE 社内で行っているモブプロの手法を使った勉強会のことを言うらしい。私は普段からペアプロやモブプロを行っており、自分としても好きな XP の手法なので参加した。Learning Session については下記のブログに纏められているので気になった方は読むといいだろう。([仕事をよりクリエイティブにするための「Learning Session」ノススメ
  ](https://engineering.linecorp.com/ja/blog/recommend-learning-session/))
- ハンズオンがスタートしてからモブプロの軽い説明があり、それから各チームに別れた。チームは各々がやってみたいこと（例えば、circle ci や flutter や k8s など）を出し合い、自分の入りたいチームに入るというものだった。私は flutter を始めようと思っていたので flutter のチームに参加した。
- それから１時間半ほどモブプロを行って、結果的には環境構築が終わって hello world が成功したところで終わってしまった。ダウンロードなどにどうしても時間が掛かってしまうので、その間は Dart や flutter のチュートリアルを眺めたり、他のフレームワーク（React や Xamarin など）の違いなどを調べていた。
- ハンズオンの講師の方に「モブプログラミング・ベストプラクティス」を読んで実際にモブプロをしているという話をすると、モブプロ創始者の一人である Chris Lucian さんの論文を読むと良いと教えて頂いたので今度読もうと思う。

### Armeria について

- 二日目には「Armeria と WebFlux でマイクロサービスを強化」のハンズオンを受けた。
- Armeria とは LINE の OSS で非同期 RPC/API のためのライブラリーだ(https://github.com/line/armeria)
- LINE DEV DEY でも Armeria に関するセッションが複数行われており、Slack でも採用されているようだ。
- ハンズオンの内容としては、実際に Spring Boot のプロジェクトに Armeria を組み込んで使ってみるという内容だった。([その際のデモコードのリポジトリ](https://github.com/joonhaeng/line-devday-2019-hands-on-src))
- Armeriaのstarterが用意されているので比較的簡単に SpringのDIに組み込めるという印象だ。
- Springのecosystemと共存する形でArmeriaを使ってgRPCやThriftをよしなに非同期にできるというのがメリットのようだ。Armeriaはh2cもデフォルトでサポートしているらしい。

```groovy
// build.gradle
dependencies {
    implementation 'com.linecorp.armeria:armeria-spring-boot-webflux-starter'
}

dependencyManagement {
	imports {
		mavenBom 'com.linecorp.armeria:armeria-bom:0.96.0'
	}
}
```
