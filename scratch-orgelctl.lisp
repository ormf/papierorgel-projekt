;;; 
;;; init.lisp
;;;
;;; **********************************************************************
;;; Copyright (c) 2023 Orm Finnendahl <orm.finnendahl@selma.hfmdk-frankfurt.de>
;;;
;;; Revision history: See git repository.
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the Gnu Public License, version 2 or
;;; later. See https://www.gnu.org/licenses/gpl-2.0.html for the text
;;; of this agreement.
;;; 
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;;; GNU General Public License for more details.
;;;
;;; **********************************************************************

(in-package :cl-orgelctl)

(add-cc-responder 0 (lambda (val) (format t "~&ccnum: 0, val: ~a" val)))

(remove-channel-cc-responders 5)

()

(cm:events
 (loop for x from 1 to 16 collect (cm:new cm:midi :time 0 :keynum (+ 40 (/ (ou:fv->ct x) 100)) :channel 2))
 "/tmp/oton.svg"
 :width 10000)

(loop )
