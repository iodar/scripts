#!/bin/bash
# Stellt Datenbank mit Daten und Schema wieder her
# Vor dem Wiederherstellen werden alle Daten aus der Datenbank gelöscht
# pg_restore kann NICHT mit 'plaintext' dumps arbeiten
# Datenbankhost
DATABASE_HOST_URI=localhost
# Portnummer der Datenbank
DATABASE_PORT=65432
# Nutzer der Datenbank
DATABASE_USER=postgres
# Name der Datenbank
DATABASE_NAME=postgres
# Dump File der importiert werden soll
DUMP_IN_FILE=20190517171451-postgres-test-stage.dump.tar

# Stellt Datenbankdaten aus dem IN FILE wieder her
#
# --> Format wird von pg_restore automatisch erkannt
# --> Encoding sollte UTF-8 sein
# --> '-c' löscht alle Einträge aus der Datenbank bevor der Import gestartet wird
#     --> Ohne '-c' bricht der Import pro Tabelle ab, wenn mindestens ein Datenbank gefunden wird
#         der im Dump und in der Datenbank vorliegt
pg_restore -h $DATABASE_HOST_URI -p $DATABASE_PORT -U $DATABASE_USER -c -d $DATABASE_NAME $DUMP_IN_FILE