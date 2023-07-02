//SORTEG02 JOB ' ',CLASS=A,MSGLEVEL=(1,1),MSGCLASS=X,NOTIFY=&SYSUID
//DELET100 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=* 
//SYSIN    DD *
  DELETE Z95636.QSAM.AA NONVSAM
  IF LASTCC LE 08 THEN SET MAXCC = 00
//SORT0200 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD *
10002949MUSTAFA        YILMAZ         20230601
10002840MUSTAFA        YILMAZ         20230601
10002978MUSTAFA        YILMAZ         20230601
10003949YASAR          OKTEN          20150630
10003840YASAR          OKTEN          20150630
10003978YASAR          OKTEN          20150630
10004949CEM ENES       KARAKUS        20200210
10004840CEM ENES       KARAKUS        20200210
10004978CEM ENES       KARAKUS        20200210
10001949MEHMET         AYDIN          19740918
10001840MEHMET         AYDIN          19740918
//SORTOUT  DD DSN=Z95636.QSAM.AA,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=60)
//SYSIN    DD *
  SORT FIELDS=(1,7,CH,A)
  OUTREC FIELDS=(1,38,39,8,Y4T,TOJUL=Y4T,15C'0')
//DELET300 EXEC PGM=IEFBR14
//FILE01   DD DSN=Z95636.QSAM.BB,
//            DISP=(MOD,DELETE,DELETE),SPACE=(TRK,0)
//SORT0400 EXEC PGM=SORT
//SYSOUT   DD SYSOUT=*
//SORTIN   DD DSN=Z95636.QSAM.AA,DISP=SHR
//SORTOUT  DD DSN=Z95636.QSAM.BB,
//            DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(5,5),RLSE),
//            DCB=(RECFM=FB,LRECL=47)
//SYSIN    DD *
    SORT FIELDS=COPY
    OUTREC FIELDS=(1,5,ZD,TO=PD,LENGTH=3,
                  6,3,ZD,TO=BI,LENGTH=2,
                  9,30,
                  39,7,ZD,TO=PD,LENGTH=4,
                  46,15,ZD,TO=PD,LENGTH=8)
