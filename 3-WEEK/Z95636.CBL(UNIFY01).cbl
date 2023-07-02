       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    PBEG005.
       AUTHOR.        YASAR OKTEN.
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE ASSIGN TO IDXFILE
                           ORGANIZATION INDEXED
                           ACCESS RANDOM
                           RECORD KEY IDX-KEY
                           STATUS IDX-ST.
           SELECT INP-FILE ASSIGN TO INPFILE
                           STATUS INP-ST.
           SELECT OUT-FILE ASSIGN TO OUTFILE
                           STATUS OUT-ST.
      *-------------
       DATA DIVISION.
      *-------------
       FILE SECTION.
      *Bu tanımlamalar, COBOL programında kullanılacak olan "IDX-FILE" 
      *adlı dosyanın kayıt yapısını ve içerdiği veri alanlarını belirtir.
       FD  IDX-FILE.
       01  IDX-REC.
           05 IDX-KEY.
              10 IDX-ID       PIC S9(5) COMP-3.
              10 IDX-DVZ      PIC S9(3) COMP.
           05 IDX-NAME        PIC X(15).
           05 IDX-SURNAME     PIC 9(15).
           05 IDX-DATE        PIC S9(7) COMP-3.
           05 IDX-BALLANCE    PIC S9(15) COMP-3.
      *Bu tanımlamalar, COBOL programında kullanılacak olan "OUT-FILE" 
      *adlı dosyanın kayıt yapısını ve içerdiği veri alanlarını belirtir.
       FD  OUT-FILE RECORDING MODE F.
        01  HEADER.
       01  OUT-REC.
           05 OUT-ID-O        PIC 9(5).
           05 FILLER          PIC X              VALUE SPACE.
           05 OUT-DVZ-O       PIC X(3).
           05 FILLER          PIC X              VALUE SPACE.
           05 OUT-NAME-O      PIC X(15).
           05 FILLER          PIC X              VALUE SPACE.
           05 OUT-SURNAME-O   PIC X(15).
           05 FILLER          PIC X              VALUE SPACE.
           05 OUT-DATE-O      PIC 9(8).
           05 FILLER          PIC X              VALUE SPACE.
           05 OUT-BALLANCE-O  PIC 9(15).
      *Bu tanımlamalar, COBOL programında kullanılacak olan "INP-FILE"
      *adlı dosyanın kayıt yapısını ve içerdiği veri alanlarını belirtir.
       FD  INP-FILE RECORDING MODE F.
       01  INP-REC.
           05 INP-ID          PIC X(5).
           05 INP-DVZ         PIC X(3).
      *Bu tanımlamalar, COBOL programının çalışma alanında kullanılan 
      *değişkenleri ve durum kodlarını belirtir. Bu değişkenler, 
      *programın çalışma sırasında geçici verileri saklamak ve durumları
      * takip etmek için kullanılır.
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05  INT-DATE      PIC 9(7).
           05  GREG-DATE     PIC 9(8).
           05  DVZ-TYPE      PIC X(3).
         03  PROGRAM-ST.
           05 IDX-ST         PIC 99.
              88 IDX-SUCCESS             VALUE 00 97.
              88 IDX-NOTFND              VALUE 23.
           05 INP-ST         PIC 99.
              88 INP-SUCCESS             VALUE 00 97.
              88 INP-EOF                 VALUE 10.
           05 OUT-ST         PIC 99.
              88 OUT-SUCCESS             VALUE 00 97.
      *------------------

       PROCEDURE DIVISION.
      *------------------
      *Bu paragraf, bir COBOL programının temel çalışma akışını gösterir.
      * Dosyaların açılması, veri işleme ve programın düzgün bir şekilde
      * sonlandırılması gibi adımların gerçekleştirildiği ana işlemi 
      *temsil eder.
       0000-MAIN.
           PERFORM H100-OPEN-FILES.
           PERFORM H200-PROCESS UNTIL INP-EOF.
           PERFORM H999-PROGRAM-EXIT.
       MAIN-END. EXIT.
      *Bu paragraf, COBOL programında kullanılan dosyaların açılması ve
      *gerekli kaynakların hazırlanması için yapılan işlemleri içerir.
      *Dosyaların açılması, programın veri okuması ve çıktısı için hazır hale ge
       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN INPUT  IDX-FILE.
           OPEN OUTPUT OUT-FILE.
           PERFORM H110-OPEN-CONTROL.
           READ INP-FILE.
       H100-END. EXIT.
      *Bu adımlar, giriş, çıkış ve indeks dosyalarının açılması 
      *sırasında hataların kontrol edildiği ve gerekli işlemlerin 
      *gerçekleştirildiği bir kontrol mekanizmasını temsil eder. 
      *Eğer dosyalar başarıyla açılamazsa, hata mesajları gösterilir, 
      *dönüş kodu ayarlanır ve program sonlandırılır.
       H110-OPEN-CONTROL.
           IF (INP-ST NOT = 0) AND (INP-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN INPUT FILE: ' INP-ST
           MOVE INP-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
      *
           IF (OUT-ST NOT = 0) AND (OUT-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN OUTPUT FILE: ' OUT-ST
           MOVE OUT-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
      *
           IF (IDX-ST NOT = 0) AND (IDX-ST NOT = 97)
           DISPLAY 'UNABLE TO OPEN INDEX FILE: ' IDX-ST
           MOVE IDX-ST TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H110-END. EXIT.
      *Giriş verilerinin işlenmesini ve indeks dosyasından
      *ilgili kaydın okunmasını sağlar. Giriş verileri sayısal formata 
      *dönüştürülür ve indeks dosyasından kayıtlar okunur. Okuma işlemi
      *sırasında geçersiz bir anahtar durumu oluşursa ilgili işlemler 
      *gerçekleştirilir, aksi takdirde geçerli bir kayıt durumunda 
      *ilgili işlemler gerçekleştirilir.
       H200-PROCESS.
           COMPUTE IDX-ID = FUNCTION NUMVAL (INP-ID).
           COMPUTE IDX-DVZ = FUNCTION NUMVAL (INP-DVZ).
           READ IDX-FILE KEY IS IDX-KEY
           INVALID KEY PERFORM H210-INVALID-RECORD
           NOT INVALID KEY PERFORM H220-VALID-RECORD.
       H200-END. EXIT.
      *Geçersiz bir kayıt durumunda yapılacak işlemleri temsil eder.
      *Kayıt bulunamadığında bir hata mesajı gösterilir ve işlem sonraki
      *kayda geçer. Bu, programın uygun şekilde devam etmesini sağlar.
       H210-INVALID-RECORD.
           DISPLAY 'No such record : ' INP-ID.
           READ INP-FILE.
       H210-END. EXIT.
      *Geçerli bir kayıt durumunda yapılacak işlemleri temsil eder.
      *İndeks tarih değeri hesaplanır, hesaplama işlemleri 
      *gerçekleştirilir, çıkış kaydı oluşturulur ve yazılır. Son olarak,
      *bir sonraki giriş kaydı okunur. Bu, programın işlem yapısının bir
      *parçasını oluşturur.
       H220-VALID-RECORD.
           COMPUTE INT-DATE = FUNCTION INTEGER-OF-DAY(IDX-DATE).
           COMPUTE GREG-DATE = FUNCTION DATE-OF-INTEGER(INT-DATE).
           PERFORM H300-CALCULATE.
           MOVE SPACES TO OUT-REC.
           MOVE IDX-ID TO OUT-ID-O.
           MOVE DVZ-TYPE TO OUT-DVZ-O.
           MOVE IDX-NAME TO OUT-NAME-O.
           MOVE IDX-SURNAME TO OUT-SURNAME-O.
           MOVE GREG-DATE TO OUT-DATE-O.
           MOVE IDX-BALLANCE TO OUT-BALLANCE-O.
           WRITE OUT-REC.
           READ INP-FILE.
       H220-END. EXIT.
      * "IDX-DVZ" değişkeninin değerine göre farklı hesaplamaların 
      *yapılmasını ve "DVZ-TYPE" değişkeninin uygun değerlerle 
      *güncellenmesini sağlar. Bu işlemler, hesaplama ve döviz türü 
      *belirleme işlemlerini temsil eder.
       H300-CALCULATE.
           IF IDX-DVZ = 949
              COMPUTE IDX-BALLANCE = IDX-BALLANCE + 25000
              MOVE 'TRY' TO DVZ-TYPE
           END-IF.
      *
           IF IDX-DVZ = 840
              COMPUTE IDX-BALLANCE = IDX-BALLANCE + 3000
              MOVE 'USD' TO DVZ-TYPE
           END-IF.
      *
           IF IDX-DVZ = 978
              COMPUTE IDX-BALLANCE = IDX-BALLANCE + 4000
              MOVE 'EUR' TO DVZ-TYPE
           END-IF.
       H300-END. EXIT.
      * programın düzgün bir şekilde sonlandırılmasını sağlar.
      *Dosyaların kapatılması ve programın durdurulması işlemleri 
      *gerçekleştirilir. Bu, programın tamamlanmasını ve çalışmanın sona
      *ermesini temsil eder.
       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE OUT-FILE.
           CLOSE IDX-FILE.
           STOP RUN.
       H999-END. EXIT.
      * 