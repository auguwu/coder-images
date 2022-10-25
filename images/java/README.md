# ghcr.io/auguwu/coder-images/java
This image extends the [base image](https://github.com/auguwu/coder-images/pkgs/container/coder-images%2Fbase) which include JDK 18, Maven, and Gradle

## Bundled Software
| Name   | Description                                         | Version                        |
| ------ | --------------------------------------------------- | ------------------------------ |
| JDK    | The Java development kit.                           | [18.0.2.1][temurin-18-release] |
| Gradle | Adaptable, fast automation for all                  | [v7.5.1][gradle-release]       |
| Maven  | Software project management and comprehension tool. | [v3.8.6][maven-release]        |

[temurin-18-release]: https://github.com/adoptium/temurin18-binaries/releases/tag/jdk-18.0.2.1%2B1
[gradle-release]:     https://github.com/gradle/gradle/releases/tag/v7.5.1
[maven-release]:      https://github.com/apache/maven/releases/tag/maven-3.8.6
