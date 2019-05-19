#!/bin/bash
# Umgebungsname der im Namen des Outfiles benutzt wird
# zum Beispiel qsdev oder qstest
UMGEBUNGSNAME="test-stage"
# erzeugt Timestamp String um diesen in im Out File des Dump zu verwenden
CURRENT_DATETIME=$(date +'%Y%m%d%H%M%S')
# URI zur Datenbank (URL)
DATABASE_HOST_URI="localhost"
# Portnummer der Datenbank
DATABASE_PORT=5432
# Name der Datenbank auf dem Datenbankserver
DATABASE_NAME="postgres"
# Nutzername für die Datenbank
DATABASE_USER="postgres"
# Name des Outfile (hier kann auch ein Pfad angegeben werden)
DUMP_OUT_FILE="$CURRENT_DATETIME-$DATABASE_NAME-$UMGEBUNGSNAME.dump.tar"

# Dump(t) den Inhalt der Datenbank mit Schema in das aktuelle Verzeichnis
# Verbindungsdaten und Name/Pfade des Outfiles können über die Variablen gesteuert werden
# 
# Einstellungen
# --> Encoding: UTF-8 ('-E')
# --> Format des Dump: tar file
# --> Kompressionsrate: 0 (max ist 9) | Beispiel: ~15 Million Zeilen sind etwa 1 GiB Daten
#     --> Aktuell unklar wie man komprimierte dumps importiert
# --> '-W' erzeugt einen Prompt für die Eingabe eines Passworts
pg_dump -h $DATABASE_HOST_URI -p $DATABASE_PORT -d $DATABASE_NAME -U $DATABASE_USER -F t -W -E UTF-8 -f $DUMP_OUT_FILE