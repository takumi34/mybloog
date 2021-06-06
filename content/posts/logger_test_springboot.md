---
title: "Spring Bootにおけるログのテスト方法について"
date: 2021-06-07T01:49:55+09:00
draft: false
toc: false
images:
tags: 
  - "Spring"
  - "Java"
  - "JUnit"
---
Spring Bootでログの出力内容をテストしたいときがしばしばある。しかし、その実装はなかなかに癖があると思っていたため、この解説記事を執筆することにした。

<br>

本記事ではログの出力内容をテストする方法について、以下の２つの方法を解説する。（他にも良い方法があればコメント欄で教えてほしい）

1. Mockitoを使って、Appenderをmockする方法(今回はLogbackを使用)
2. OutputCaptureを使う方法

<br>

コード全体を見たい方は[こちら](#サンプルコード)

<br>

## 前提条件

以下を使用している。

* Spring Boot(version 2.5.0)
* JUnit5
* Logback

<br>

# 1. Mockitoを使って、Appenderをmockする方法

* この方法のメリットとしては、LoggingEventをキャプチャしているため、ログの内容をそのままテストできる点が挙げられる。

* デメリットとしては実装が少しややこしい。

<br>

まずは以下の実装を見てほしい。

```java
  @Mock
  private Appender<ILoggingEvent> mockAppender;

  @Captor
  private ArgumentCaptor<LoggingEvent> captorLoggingEvent;
```

* MockitoのArgumentCaptorを使用してLoggingEventをキャプチャしている。

* ArgumentCaptorとは、その名の通り引数をキャプチャできるもので、引数を直接取れない場合に便利だ。

<br>

```java
@BeforeEach
public void setup() {
  final Logger logger = (Logger) LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME);
  logger.addAppender(mockAppender);
}

@AfterEach
public void cleanup() {
  final Logger logger = (Logger) LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME);
  logger.detachAppender(mockAppender);
}
```

* テストメソッドが実行される前にrootロガーにappenderをaddしている。そして、実行後にdetachするようにしている。(もちろんrootロガーを使用していない場合は適切なロガーを指定する必要がある)

<br>

```java
@Test
void testSampleLoggerUsingMockito() {
  sampleLogger.outputLog();

  verify(mockAppender, times(1)).doAppend(captorLoggingEvent.capture());
  final LoggingEvent loggingEvent = captorLoggingEvent.getValue();


  //test the log level and message
  assertEquals(Level.INFO, loggingEvent.getLevel());
  assertEquals("Logger_test",
          loggingEvent.getFormattedMessage());
}
```

* ここではログレベルとメッセージのみ取得しているが、他にも色々取得することができるので気になる人は[ここ](https://javadoc.io/doc/ch.qos.logback/logback-classic/latest/ch/qos/logback/classic/spi/LoggingEvent.html)を参照。

<br>


# 2. OutputCaptureを使う方法

[OutputCapture](https://javadoc.io/doc/org.springframework.boot/spring-boot-test/latest/org/springframework/boot/test/system/OutputCaptureExtension.html)とはSpring Bootから提供されている機能で、（ログを含めた）出力をすべてキャプチャすることができる。

* この方法のメリットとしては、比較的簡単に実装でき、出力すべてをキャプチャすることができる点が挙げられる。（System.errとSystem.outはそれぞれ取ることも可能）

* デメリットとしては、１つ目の方法とは違って出力すべてを取得するものなので、細かい内容をそれぞれ取ることはできない。もしやるなら自力でパース処理をするしかない。
<br>

以下の実装を見てほしい。

```java
@ExtendWith(OutputCaptureExtension.class)
@Test
void testSampleLoggerUsingOutputCapture(CapturedOutput output) {
    sampleLogger.outputLog();

    //test the capturedOutput
    assertTrue(output.toString().contains("Logger_test"));
}
```

* 本記事を読む人なら当然JUnit5を使っていると思うので、@ExtendWith(OutputCaptureExtension.class)をする。

(未だにJUnit4を使っている人は[OutputCaptureRule](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/system/OutputCaptureRule.html)というのもある...)

* あとは、テストメソッドの引数にCapturedOutputをinjectするだけで、出力内容を取得することが出来る（簡単）。

# まとめ

Spring Bootにおけるログのテスト方法としては大きく分けて２つある。

1. Mockitoを使って、Appenderをmockする方法
  * メリット：実装がやや面倒
  * デメリット：ログの中身を細かく取得できる

2. OutputCaptureを使う方法
  * メリット：実装が楽
  * デメリット：出力内容を全て取得するので、細かくチェックしたい時は自力でパースする必要がある

***以上、ケースバイケースなのでその時に合ったものを使うのが大事！***



<br>

### サンプルコード
今回作成したプロジェクトの中身を紹介する。([Githubにも上がっている](https://github.com/takumi34/spring-boot-log-test)) 

大きく分けて２つのクラスがある。

* ログ出力クラス


SampleLogger.class
```java
package com.example.logtest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class SampleLogger {
    private final static Logger log = LoggerFactory.getLogger(Logger.class);

    public void outputLog() {
        log.info("Logger_test");
    }

}
```

* ログ出力のテストクラス


SampleLoggerTest.class
```java
package com.example.logtest;


import ch.qos.logback.classic.Level;
import ch.qos.logback.classic.Logger;
import ch.qos.logback.classic.spi.ILoggingEvent;
import ch.qos.logback.classic.spi.LoggingEvent;
import ch.qos.logback.core.Appender;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;


@SpringBootTest
public class SampleLoggerTest {

    @Autowired
    private SampleLogger sampleLogger;

    @Mock
    private Appender<ILoggingEvent> mockAppender;

    @Captor
    private ArgumentCaptor<LoggingEvent> captorLoggingEvent;

    @BeforeEach
    public void setup() {
        final Logger logger = (Logger) LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME);
        logger.addAppender(mockAppender);
    }

    @AfterEach
    public void cleanup() {
        final Logger logger = (Logger) LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME);
        logger.detachAppender(mockAppender);
    }

    //use Mockito
    @Test
    void testSampleLoggerUsingMockito() {
        sampleLogger.outputLog();

        verify(mockAppender, times(1)).doAppend(captorLoggingEvent.capture());
        final LoggingEvent loggingEvent = captorLoggingEvent.getValue();


        //test the log level and message
        assertEquals(Level.INFO, loggingEvent.getLevel());
        assertEquals("Logger_test",
                loggingEvent.getFormattedMessage());
    }

    //use OutputCapture
    @ExtendWith(OutputCaptureExtension.class)
    @Test
    void testSampleLoggerUsingOutputCapture(CapturedOutput output) {
        sampleLogger.outputLog();

        //test the capturedOutput
        assertTrue(output.toString().contains("Logger_test"));
    }

}
```


### References
* Appenderをmockする方法について
  * https://dev.to/claudiohigashi/mocking-logger-in-java-with-mockito-51k8
  * https://gist.github.com/bloodredsun/a041de13e57bf3c6c040

* ArgumentCaptorについて
  * https://www.javadoc.io/doc/org.mockito/mockito-core/2.6.9/org/mockito/ArgumentCaptor.html
  * https://www.baeldung.com/mockito-argumentcaptor

* OutputCaptureについて
  * https://javadoc.io/doc/org.springframework.boot/spring-boot-test/latest/org/springframework/boot/test/system/OutputCaptureExtension.html

* 本記事では取り上げなかったが、Mockitoを使わずにListAppenderをextendして、カスタムのAppenderクラスを作ってテストしている例としては以下が参考になる。
  * https://www.baeldung.com/junit-asserting-logs
