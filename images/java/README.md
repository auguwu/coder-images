# ghcr.io/auguwu/coder-images/java
This image extends the [base image](https://github.com/auguwu/coder-images/pkgs/container/coder-images%2Fbase) which include JDK 18, Maven, and Gradle

## Bundled Software
| Name   | Description                                         | Version                      |
| ------ | --------------------------------------------------- | -----------------------------|
| JDK    | The Java development kit.                           | [19.0.1+10][temurin-release] |
| Gradle | Adaptable, fast automation for all                  | [v7.6][gradle-release]       |
| Maven  | Software project management and comprehension tool. | [v3.8.7][maven-release]      |

[temurin-release]: https://github.com/adoptium/temurin19-binaries/releases/tag/jdk-19.0.1%2B10
[gradle-release]:  https://github.com/gradle/gradle/releases/tag/v7.6.0
[maven-release]:   https://github.com/apache/maven/releases/tag/maven-3.8.6
