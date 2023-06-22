       IDENTIFICATION DIVISION.
       PROGRAM-ID. DAYCALC.
       AUTHOR. Yasar Okten.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PRT-LINE ASSIGN PRTLINE
                                  STATUS ST-PRINT-LINE.
           SELECT DATE-REC ASSIGN DATEREC
                                  STATUS ST-DATE-REC.
       DATA DIVISION.
       FILE SECTION.
       FD  PRT-LINE RECORDING MODE F.
         01  RECORD-PRT-LINE.
           05 PRT-LINE-SRT      PIC 9(4).
           05 PRT-LINE-NAME     PIC A(15).
           05 PRT-LINE-SURNAME  PIC A(15).
           05 PRT-LINE-BDAY     PIC 9(8).
           05 PRT-LINE-TODAY    PIC 9(8).
           05 PRT-LINE-TDAY     PIC 9(5).
       FD  DATE-REC RECORDING MODE F.
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
       0000-MAIN.
           PERFORM H100-OPEN-FILE.
           PERFORM H200-PROCESS UNTIL ST-DATE-EOF.
           PERFORM H999-CLOSE-FILE.
       0000-END. EXIT.
       H100-OPEN-FILE.
           OPEN INPUT  DATE-REC.
           OPEN OUTPUT PRT-LINE.
           READ DATE-REC.
       H100-END. EXIT.
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
       H999-CLOSE-FILE.
           CLOSE DATE-REC.
           CLOSE PRT-LINE.
       H999-END. EXIT.
           STOP RUN.
