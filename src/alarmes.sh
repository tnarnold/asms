#!/bin/sh
ARQ="/root/script/servers.txt"
PINGOK="/tmp/ping.ok.$$"
PINGDUP="/tmp/ping.dup.$$"
PINGTMP="/tmp/ping.$$"
DEST="tiago@radaction.com.br"
DAT=`date`

sms()
{
echo "Enviando mensagem "
#/usr/bin/gsmsendsms -b 115200 -d /dev/ttyACM0 $FONE "URGENTE em ${DAT} o Sistema ${IDEN} esta indisponivel a ${TMP}, Verificar!"
##echo "Eviar Sms"
}

checa()
{
for CL in `cat $ARQ` ;do
   QTD="10"
   MINPER="4"
   MINDUP="4"
   NOM=`cat $ARQ| grep -w $CL|cut -d- -f2`   
   IDEN=`cat /root/script/nomes.txt |grep $CL|cut -d" " -f2,3,4,5`

/bin/ping -i 2 -c $QTD $CL > $PINGTMP
cat $PINGTMP | grep icmp_seq | grep time | grep ms > $PINGOK
cat $PINGTMP | grep icmp_seq | grep time | grep ms | grep -i DUP > $PINGDUP
RESULT=`wc -l $PINGOK | cut -d ' ' -f1`
PERDA=`expr $QTD - $RESULT`
DUPL=`wc -l $PINGDUP | cut -d ' ' -f1`

echo "$CL"

if [ "$PERDA" == "$QTD" ]; then
echo "O Sistema $NOM ($CL) esta PARADO!
Data: $DAT" | mail -s "$NOM Parado!" $DEST

echo "O Sistema $NOM ($CL) esta PARADO! Data: $DAT" >> /tmp/$CL.log
  for CNT in 1 3 6 9 12 24 36 48
   do
   VAL=`cat /tmp/$CL.log |wc -l`
    if [ $VAL == $CNT ]
     then 

      if [ $CNT == 1 ]
       then
        TMP="5 Min"
        FONE="" 
        sms 
        FONE=""
		sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi

      if [ $CNT == 3 ]
       then
        TMP="15 Min"
		FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi

      if [ $CNT == 6 ]
       then
        TMP="30 Min"
	FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi

      if [ $CNT == 9 ]
       then
        TMP="45 Min"
	FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi
     
      if [ $CNT == 12 ]
       then
       TMP="1 Hs"
	FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
      fi
 
      if [ $CNT == 24 ]
       then
		TMP="2 Hs"
		FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi

      if [ $CNT == 36 ]
       then
       TMP="3 Hs"
	FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi

      if [ $CNT == 48 ]
       then
		TMP="4 Hs"
	FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
        FONE=""
        sms
       fi

    fi
   done

else
   rm -rf /tmp/$CL.log
   if [ "$PERDA" -gt "$MINPER" ]; then
   echo "O Servidor $NOM ($CL) esta com perda de pacote.
Enviados:$QTD
Perdidos:$PERDA
Data: $DAT" | mail -s "PERDA DE PACOTES" $DEST
   fi
fi

if [ "$DUPL" -gt "$MINDUP" ]; then
echo "O Servidor $NON ($CL) esta com excesso de pacotes duplicados.
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
