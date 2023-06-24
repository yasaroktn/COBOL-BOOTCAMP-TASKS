      *Bu bölüm programın kimlik bilgilerinin belirtildiği bölümdür.
      *Bu bölümde programın adını ve programı oluşturan kişi
      *belirtilmiştir.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. DAYCALC.
       AUTHOR. Yasar Okten.
      *Bu bölüm programın çalışma ortamını ve kullanılacak dosyaların
      *tanımlarını içeren önemli bir bölümdür.
       ENVIRONMENT DIVISION.
      *Bu bölümde programın kullanacağı girdi ve çıktı dosyaları
      *tanımlanmaktadır.
       INPUT-OUTPUT SECTION.
      *Bu kod bloğu, programın "PRT-LINE" ve "DATE-REC" dosyalarını
      *kullanacağını ve bu dosyaların fiziksel bağlantılarını ve 
      *durumlarını belirlediğini göstermektedir.
      *Bu tanımlamalar, programın dosya işlemlerini yapabilmesi için
      * gerekli olan dosya bağlantılarını ve durum kontrollerini sağlar.
       FILE-CONTROL.
           SELECT PRT-LINE ASSIGN PRTLINE
                                  STATUS ST-PRINT-LINE.
           SELECT DATE-REC ASSIGN DATEREC
                                  STATUS ST-DATE-REC.
      *Bu bölüm programın veri yapılarını organize etmesini ve veri
      *erişimi ve işleme işlevlerini gerçekleştirmesini sağlar. 
      *Bu bölümde tanımlanan veriler, programın çalışması sırasında
      *veri alışverişi, veri depolama ve işlem yapma yeteneklerini
      *sağlar.
       DATA DIVISION.
       FILE SECTION.
       FD  PRT-LINE RECORDING MODE F.
      *"PRT-LINE" adlı dosyanın tanımının başladığını belirtir ve kayıt
      *yapısının "Fixed" (F) modda olduğunu ifade eder. 
         01  RECORD-PRT-LINE.
           05 PRT-LINE-SRT      PIC 9(4).
           05 PRT-LINE-NAME     PIC A(15).
           05 PRT-LINE-SURNAME  PIC A(15).
           05 PRT-LINE-BDAY     PIC 9(8).
           05 PRT-LINE-TODAY    PIC 9(8).
           05 PRT-LINE-TDAY     PIC 9(5).
       FD  DATE-REC RECORDING MODE F.
      *"FD DATE-REC RECORDING MODE F." ifadesi, "DATE-REC" adlı dosyanın
      *tanımının başladığını belirtir ve kayıt yapısının "Fixed" (F) 
      *modda olduğunu ifade eder.
         01   RECORD-DATE-REC.
           05 DATE-REC-SRT      PIC 9(4).
           05 DATE-REC-NAME     PIC A(15).
           05 DATE-REC-SURNAME  PIC A(15).
           05 DATE-REC-BDAY     PIC 9(8).
           05 DATE-REC-TODAY    PIC 9(8).
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           05  TOTAL-DAY         PIC 9(5).
           05  BDAY-INT          PIC 9(8).
           05  TODAY-INT         PIC 9(8).
           05  ST-PRINT-LINE     PIC 99.
             88  ST-PRINT-SC       VALUE 00 97.
           05  ST-DATE-REC       PIC 99.
             88 ST-DATE-SC         VALUE 00 97.
             88 ST-DATE-EOF        VALUE 10.
       PROCEDURE DIVISION.
      *Maini oluşturduk burada yazılı olan sırada paragrafları takip
      *edip programı tamamlayacağız.
       0000-MAIN.
           PERFORM H100-OPEN-FILE.
           PERFORM H200-PROCESS UNTIL ST-DATE-EOF.
           PERFORM H999-CLOSE-FILE.
       0000-END. EXIT.
      *INPUT ve OUTPUT dosyalarını açtık ve output dosyasının ilk
      *satırını okuduk.
       H100-OPEN-FILE.
           OPEN INPUT  DATE-REC.
           OPEN OUTPUT PRT-LINE.
           PERFORM H110-OPEN-FILE-CONTROL.
           READ DATE-REC.
       H100-END. EXIT.
      *Dosyalar açılırken bir problemle karşılaşıldı mı diye kontrol
      *ettik eğer ki karşılaşılmışsa hata mesajı yazdırıp programı 
      *sonlandırdık.
       H110-OPEN-FILE-CONTROL.
           IF (ST-DATE-REC NOT = 97) AND (ST-DATE-REC NOT = 0)
            DISPLAY 'OUTPUT FILE NOT OPEN.'
            PERFORM H999-CLOSE-FILE
           END-IF.
           IF (ST-PRINT-LINE NOT = 97) AND (ST-PRINT-LINE NOT = 0)
              DISPLAY 'INPUT FILE NOT OPEN.'
              PERFORM H999-CLOSE-FILE
           END-IF.
       H110-END. EXIT.
      *INPUT dosyasından edindiğimiz bilgileri OUTPUT dosyamıza aktarmak
      *için OUTPUT dosyası için oluştuduğumuz değişkenlere bu bilgileri
      *yerleştiriyoruz ve yapılması gereken matematiksel işlemleri
      *yapıyoruz.
       H200-PROCESS.
           COMPUTE BDAY-INT = FUNCTION INTEGER-OF-DATE(DATE-REC-BDAY).
           COMPUTE TODAY-INT = FUNCTION INTEGER-OF-DATE(DATE-REC-TODAY).
           COMPUTE TOTAL-DAY = TODAY-INT - BDAY-INT.
           MOVE DATE-REC-SRT TO PRT-LINE-SRT.
           MOVE DATE-REC-NAME TO PRT-LINE-NAME.
           MOVE DATE-REC-SURNAME TO PRT-LINE-SURNAME.
           MOVE DATE-REC-TODAY  TO PRT-LINE-TODAY.
           MOVE DATE-REC-BDAY TO PRT-LINE-BDAY.
           MOVE TOTAL-DAY TO PRT-LINE-TDAY.
           WRITE RECORD-PRT-LINE.
           READ DATE-REC.
       H200-END. EXIT.
      *INPUT ve OUTPUT dosyalarını kapatıp programı sonlandırıyoruz.
       H999-CLOSE-FILE.
           CLOSE DATE-REC.
           CLOSE PRT-LINE.
           STOP RUN.
       H999-END. EXIT.
