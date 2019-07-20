#!/bin/bash
# installiert psql in der Version 10

function install-psql-client-10 {
    apt update
    apt install -y postgresql-client-10
}

echo -e "Installiere PostgreSQL Client der Version 10"
read -p "Mit Installation fortfahren [y/Y]: " install

case $install in 
    y|Y)    echo -e "\nStarte Installation des Client ...\n"
            install-psql-client-10
            ;;
    *)
            echo -e "\nAbbruch der Installation da Eingabe != 'y | Y'"
            ;;
esac
