# ghcr.io/auguwu/coder-images/java
This image extends the [base image](https://github.com/auguwu/coder-images/pkgs/container/coder-images%2Fbase) which include JDK 18, Maven, and Gradle

## Bundled Software
| Name   | Description                                         | Version                         |
| ------ | --------------------------------------------------- | ------------------------------- |
| JDK    | The Java development kit.                           | [jdk-20.0.1+9][temurin-release] |
| Gradle | Adaptable, fast automation for all                  | [v8.2][gradle-release]          |
| Maven  | Software project management and comprehension tool. | [v3.9.3][maven-release]         |

[temurin-release]: https://github.com/adoptium/temurin20-binaries/releases/tag/jdk-20.0.1%2B9
[gradle-release]:  https://github.com/gradle/gradle/releases/tag/v8.2.0
[maven-release]:   https://github.com/apache/maven/releases/tag/maven-3.9.3
