#lang racket

; Racket interface for apertium-tat-rus
;
; REQUIRES: apertiumpp package.
; https://taruen.github.io/apertiumpp/apertiumpp/ gives info on how to install
; it.

(provide tat-rus
         tat-rus-from-pretransfer-to-biltrans
         tat-rus-from-t1x-to-postgen)

(require pkg/lib
         rackunit
         rash
         apertiumpp/streamparser)

(define (symbol-append s1 s2)
  (string->symbol (string-append (symbol->string s1) (symbol->string s2))))

(define A-TAT-RUS './)
(define A-TAT-RUS-BIL (symbol-append A-TAT-RUS 'tat-rus.autobil.bin))
(define A-TAT-RUS-T1X (symbol-append A-TAT-RUS 'apertium-tat-rus.tat-rus.t1x))
(define A-TAT-RUS-T1X-BIN (symbol-append A-TAT-RUS 'tat-rus.t1x.bin))
(define A-TAT-RUS-T2X (symbol-append A-TAT-RUS 'apertium-tat-rus.tat-rus.t2x))
(define A-TAT-RUS-T2X-BIN (symbol-append A-TAT-RUS 'tat-rus.t2x.bin))
(define A-TAT-RUS-T3X (symbol-append A-TAT-RUS 'apertium-tat-rus.tat-rus.t3x))
(define A-TAT-RUS-T3X-BIN (symbol-append A-TAT-RUS 'tat-rus.t3x.bin))
(define A-TAT-RUS-T4X (symbol-append A-TAT-RUS 'apertium-tat-rus.tat-rus.t4x))
(define A-TAT-RUS-T4X-BIN (symbol-append A-TAT-RUS 'tat-rus.t4x.bin))
(define A-TAT-RUS-GEN (symbol-append A-TAT-RUS 'tat-rus.autogen.bin))
(define A-TAT-RUS-PGEN (symbol-append A-TAT-RUS 'tat-rus.autopgen.bin))

(define (tat-rus s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-rus")])
    (rash
     "echo (values s) | apertium -d . tat-rus")))

(define (tat-rus-from-pretransfer-to-biltrans s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-rus")])
    (rash
     "echo (values s) | apertium-pretransfer | "
     "lt-proc -b (values A-TAT-RUS-BIL)")))

(define (tat-rus-from-t1x-to-postgen s)
  (parameterize ([current-directory (pkg-directory "apertium-tat-rus")])
    (rash
     "echo (values s) | "
     "apertium-transfer -b (values A-TAT-RUS-T1X) (values A-TAT-RUS-T1X-BIN) | "
     "apertium-interchunk (values A-TAT-RUS-T2X) (values A-TAT-RUS-T2X-BIN) | "
     "apertium-interchunk (values A-TAT-RUS-T3X) (values A-TAT-RUS-T3X-BIN) | "
     "apertium-postchunk (values A-TAT-RUS-T4X) (values A-TAT-RUS-T4X-BIN) | "      
     "lt-proc -g (values A-TAT-RUS-GEN) | "
     "lt-proc -p (values A-TAT-RUS-PGEN)"))) 
