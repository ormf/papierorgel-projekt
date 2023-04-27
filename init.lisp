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

(setf *print-case* :downcase)
(cm:cd (namestring (asdf:system-relative-pathname :papierorgel-projekt "")))

(setf *orgel-presets-file*
  (asdf:system-relative-pathname :papierorgel-projekt "presets/orgel-presets.lisp"))

(setf *route-presets-file*
    (asdf:system-relative-pathname :papierorgel-projekt "presets/route-presets.lisp"))


(load-orgel-presets)
(load-route-presets)

(edit-preset-in-emacs (setf *curr-preset-nr* 0))

(sleep 0.5)
(ats-cuda::reconnect-midi)
;;; *curr-state*


;;; (orgel-ctl :orgel01 :level10 0.2)

