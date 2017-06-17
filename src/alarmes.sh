#!/bin/bash
PINGCMD=`which ping`
PINGOK="/tmp/ping.ok.$$"
PINGDUP="/tmp/ping.dup.$$"
PINGTMP="/tmp/ping.$$"
DEST=`cat /etc/alarmes.conf | grep mailadm= | cut -d = -f 2`
DAT=`date`
DBUSER=`cat /etc/alarmes.conf | grep user= | cut -d = -f 2`
DBPASS=`cat /etc/alarmes.conf | grep pass= | cut -d = -f 2`
DBNAME=`cat /etc/alarmes.conf | grep dbname= | cut -d = -f 2`

sms()
{

if [ "$2" != "00000000" ]; then

echo "-------SMS----------
Enviando mensagem para celular $2  `date | cut -d " " -f 1,2,3,4`
 ALERTA! ${NOM}($CL) parado a ${TMP}
 ${DESCRICAO} " >> /tmp/sms.txt

/usr/bin/sendsms $2 "ALERTA! ${NOM}($CL) parado a ${TMP}, ${DESCRICAO}" 2>&1 &
else
echo "-----
NOT SEND SMS
----" >> /tmp/sms.txt
fi

if [ "$3" != "NULL@NULL" ]; then
echo "----------e-mail-------------
 To: $3
 Subject: ALERTA! $NOM ($CL) esta parado!
	Olá $4.
	O nodo $NOM não está respondendo a ${TMP} e é um nó crítico na rede!

	Por favor verificar com urgência!

	Descrição adicional: ${DESCRICAO}" >> /tmp/email.txt

echo "Olá $4.

	O nodo $NOM não está respondendo a ${TMP} e é um nó crítico na rede!

	Por favor verificar com urgência!

	Descrição adicional: ${DESCRICAO}" | mail -s "ALERTA! $NOM ($CL) esta parado!" $3 2>&1 &


else
echo "-----
NOT SENT EMAIL
-----" /tmp/email.txt
fi

}


checa()
{
for CL in `mysql -h localhost -u $DBUSER -p$DBPASS -e "select ipaddr from nodos where ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d'` ;do
   QTD="5"
   MINPER="3"
   MINDUP="3"
   NOM=`mysql -h localhost -u $DBUSER -p$DBPASS -e "select hostname from nodos where ipaddr like '$CL' and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d'`
   DESCRICAO=`mysql -h localhost -u $DBUSER -p$DBPASS -e "select descricao from nodos where ipaddr like '$CL' and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d'`

$PINGCMD -i 2 -c $QTD $CL > $PINGTMP
cat $PINGTMP | grep icmp_seq | grep time | grep ms > $PINGOK
cat $PINGTMP | grep icmp_seq | grep time | grep ms | grep -i DUP > $PINGDUP
RESULT=`wc -l $PINGOK | cut -d ' ' -f1`
PERDA=`expr $QTD - $RESULT`
DUPL=`wc -l $PINGDUP | cut -d ' ' -f1`

echo "$CL"

if [ "$PERDA" == "$QTD" ]; then
#echo "O host $NOM ($CL) esta PARADO!
#Data: $DAT" | mail -s "$NOM Parado!" $DEST

echo "O host $NOM ($CL) esta PARADO! Data: $DAT" >> /tmp/$CL.log
  for CNT in 1 3 6 9 12 24 36 48
   do
   VAL=`cat /tmp/$CL.log |wc -l`
    if [ $VAL == $CNT ]
     then
      if [ $CNT == 1 ]
       then
        TMP="5 Min"
        CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 1 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi

      if [ $CNT == 3 ]
       then
        TMP="15 Min"
        CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 2 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi

      if [ $CNT == 6 ]
       then
        TMP="30 Min"
        CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 3 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi

      if [ $CNT == 9 ]
       then
        TMP="45 Min"
        CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 4 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi
     
      if [ $CNT == 12 ]
       then
       TMP="1 Hs"
        CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 5 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
      fi
 
      if [ $CNT == 24 ]
       then
		TMP="2 Hs"
		CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 6 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi

      if [ $CNT == 36 ]
       then
       TMP="3 Hs"
        CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 7 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi

      if [ $CNT == 48 ]
       then
		TMP="4 Hs"
		CELULARES=$(mysql -h localhost -u $DBUSER -p$DBPASS -e "select * from celulares where nivel <= 8 and ativo=1" $DBNAME |sed 's:COMMENT\:""::g' | sed '1d')
		if [ ! -z "$CELULARES" ]
		then
            while read line
                do sms $line;
            done <<< "$CELULARES"
        fi
       fi

    fi
   done
else
   rm -rf /tmp/$CL.log
   if [ "$PERDA" -gt "$MINPER" ]; then
   echo "O host $NOM ($CL) esta com perda de pacote.
	Enviados:$QTD
	Perdidos:$PERDA
	Data: $DAT" | mail -s "PERDA DE PACOTES" $DEST
   fi
fi

if [ "$DUPL" -gt "$MINDUP" ]; then
	echo "O host $NON ($CL) esta com excesso de pacotes duplicados.
	Enviados:$QTD
	Duplicados:$DUPL
	Data: $DAT" | mail -s "PACOTES DUPLICADOS" $DEST
fi
done
rm -rf $PINGTMP
rm -rf $PINGOK
rm -rf $PINGDUP
}

##-------------Inicio---------------##
checa
