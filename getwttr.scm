#!/usr/bin/env -S guile -s
!#
(use-modules (web client) (srfi srfi-11) (json) (rnrs bytevectors))

; GetWttr.scm unofficially gets data from russian Gidrometeocenter.
; That's actual to use the script in Russia, where weather.com banned users from by IP and, on the other hand, where it is not actual to use wttr.in service hosted by dear @chubin (Igor Chubin)
;If you use the script, please, do not flood them; new weather data upcomes every 10 minutes, not more!!!!

; pipe implementation copy
(define-syntax pipe
  (syntax-rules (map)
    ((pipe data) data)
    ((pipe data map func) (map func data))
    ((pipe data map func . other_funcs) (pipe (map func data) . other_funcs ))
    ((pipe data func) (func data))
    ((pipe data func . other_funcs) (pipe (func data) . other_funcs ))
    ))

(define city 16578) ; moscow city

(let-values
    (((res body) (http-request (string-append "https://meteoinfo.ru/hmc-output/obs_ams_json/" (number->string city) ".dat"))))
    (pipe body utf8->string json-string->scm vector->list reverse car vector->list display)) ; many transforms to get the last record. after all, just display it (of course you may change this behaivour)
