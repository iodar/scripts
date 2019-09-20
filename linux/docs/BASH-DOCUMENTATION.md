# Bash Documentation

In dieser Datei befindet sich eine kurze Dokumentation für die Terminal-Sprache Bash.
Vor allem sind Informationen aufgeführt, die ich weniger benötige, die ich aber jedes mal suchen muss.

## Umleitung von Output nach /dev/null

In Linux (und damit auch in Bash) gibt es 3 File Deskriptoren die den Zugriff auf verschiedene Streams ermöglichen:

```Bash
stdin  ==> fd 0
stdout ==> fd 1
stderr ==> fd 2
```

Jeder File Descriptor stellt dabei eine Funktion zur Verfügung, der den Zugriff auf eine Datei oder einen Stream ermöglicht.
Manchmal müssen Streams umgeleitet werden, damit z.B. ein bestimmter Output nicht im Terminal landet. Dazu muss der Stream
umgeleitet werden.

Eine Umleitung von *stdout* ist unter Linux wie folgt möglich: `echo -n 'Hello World' > /dev/null`. Dies bewirkt,
dass der Output von `echo -n 'Hello World'` nach `/dev/null`, also ins Nichts umgeleitet wird.

Soll zusätzlich auch der Output von *stderr* nach `/dev/null` umgeleitet werden, ist das in Bash auch möglich. Dazu wird einfach der
*stderr* Stream auf den gleichen File Descriptor wie *stdout* umgeleitet. Das sieht dann so aus: `echo -n 'Hello World' > /dev/null 2>&1`.

### Links

* [Datei-Handle (File Descriptor) bei Wikipedia (de)](https://de.wikipedia.org/wiki/Handle#Datei-Handle)
* [File Descriptor bei Wikipedia (en)](https://en.wikipedia.org/wiki/File_descriptor)
* [Umleitung nach /dev/null auf unix.stackexchange (en)](https://unix.stackexchange.com/questions/119648/redirecting-to-dev-null)

## Verarbeiten von Kommandozeilenargumenten in Bash

* [Code-Beispiele für die Verarbeitung von Kommandozeilenargumenten in Bash](https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash)

## Prüfung von Variablen auf null

Um zu prüfen, ob eine Variable null ist, gibt es in Bash die Parameter Expansion. Diese erlaubt es den Wert der Variable gegen etwas
zu substituieren, wenn die Variable bestimmte Bedingungen erfüllt. Dazu gehört z.B. die Prüfung, ob eine Variable `null` ist.
Die Prüfung auf `null` kann in Bash so gelöst werden:

```Bash
if [[ -z ${VAR:+x} ]]; then
    echo 'Variable `VAR` ist null'
else
    echo 'Variable `VAR` ist nicht null'
fi
```

Die 

|                        | parameterSet and Not Null | parameterSet But Null | parameterUnset  |
| ---------------------- | ------------------------- | --------------------- | --------------- |
| **${parameter:-word}** | substitute parameter      | substitute word       | substitute word |
| **${parameter-word}**  | substitute parameter      | substitute null       | substitute word |
| **${parameter:=word}** | substitute parameter      | assign word           | assign word     |
| **${parameter=word}**  | substitute parameter      | substitute null       | assign word     |
| **${parameter:?word}** | substitute parameter      | error, exit           | error, exit     |
| **${parameter?word}**  | substitute parameter      | substitute null       | error, exit     |
| **${parameter:+word}** | substitute word           | substitute null       | substitute null |
| **${parameter+word}**  | substitute word           | substitute word       | substitute null |
