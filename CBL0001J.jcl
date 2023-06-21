//CBL0001J JOB 1,NOTIFY=&SYSUID
//* Bu satır, bir COBOL işini (job) başlatır ve iş numarası 1 olarak
//* belirlenir. NOTIFY=&SYSUID ifadesi ise, iş tamamlandığında kullanıcının (&SYSUID) bildirim alacağını belirtir.
//***************************************************/
//* Copyright Contributors to the COBOL Programming Course
//* SPDX-License-Identifier: CC-BY-4.0
//***************************************************/
//COBRUN  EXEC IGYWCL
//* Bu satır, COBRUN adında bir adımı (EXEC) tanımlar ve IGYWCL adlı bir COBOL derleyicisini çalıştırır.
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(CBL0001),DISP=SHR
//* Bu satır, COBOL.SYSIN adında bir veri kümesini tanımlar. Bu veri kümesi, COBOL kaynak kodunu içeren bir dosyanın
//* adresini belirtir. &SYSUID..CBL(CBL0001) ifadesi, kullanıcının özgün tanımlayıcısını (&SYSUID), CBL adlı bir kütüphaneyi
//* ve CBL0001 adlı bir kaynak kod dosyasını gösterir. DISP=SHR ifadesi, dosyanın paylaşımlı (SHR) olarak açılacağını belirtir.
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(CBL0001),DISP=SHR
//* Bu satır, LKED.SYSLMOD adında bir veri kümesini tanımlar. Bu veri kümesi, derlenen ve bağlanan COBOL programının yüklenmiş
//* modülünün adresini belirtir. &SYSUID..LOAD(CBL0001) ifadesi, kullanıcının özgün tanımlayıcısını (&SYSUID), LOAD adlı bir 
//* kütüphaneyi ve CBL0001 adlı bir modülü gösterir. DISP=SHR ifadesi, dosyanın paylaşımlı (SHR) olarak açılacağını belirtir.
// IF RC = 0 THEN
//* Bu satır, bir koşul ifadesini başlatır. Burada, bir dönüş kodu (RC) değeri kontrol edilmektedir. Eğer RC değeri 0 ise, yani
//* önceki adımda bir hata oluşmamışsa, RUN adımını çalıştırmak için bir şart oluşturulur.
//RUN     EXEC PGM=CBL0001
//* Bu satır, RUN adımını tanımlar ve CBL0001 adlı programı çalıştırır.
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//* Bu satır, STEPLIB adında bir veri kümesini tanımlar. Bu veri kümesi, yürütme zamanında kullanılacak programın yer aldığı yük kitaplığını belirtir.
//ACCTREC   DD DSN=&SYSUID..DATA,DISP=SHR
//* Bu satır, ACCTREC adında bir veri kümesini tanımlar. Bu veri kümesi, programın çalışması sırasında kullanacağı giriş verilerini 
//* içeren bir veri dosyasını belirtir.
//PRTLINE   DD DSN=&SYSUID..CBL0001.OUTPUT,DISP=(NEW,CATLG,DELETE),
//            SPACE=(CYL,(10,5),RLSE)
//* Bu satır, PRTLINE adında bir veri kümesini tanımlar. Bu veri kümesi, programın çıktılarının yazılacağı bir çıktı dosyasını belirtir.
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//* Bu satır, programın çıktılarının yazılacağı standart sistem çıktı (SYSOUT) tanımlamasını belirtir.
//CEEDUMP   DD DUMMY
//* Bu satır, hata durumunda oluşturulacak CEEDUMP (sistem çökme) veri kümesini DUMMY olarak belirtir. Bu durumda, bir CEEDUMP oluşturulmayacaktır.
//SYSUDUMP  DD DUMMY
//*  Bu satır, hata durumunda oluşturulacak SYSUDUMP (sistem çökme) veri kümesini DUMMY olarak belirtir. Bu durumda, bir SYSUDUMP oluşturulmayacaktır.
// ELSE
// ENDIF
