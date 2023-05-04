;;;; Scratchpad für papierorgel.lisp


;;; (sleep 0.5)

;;; (ats-cuda::reconnect-midi)

;;; *curr-state*


;;; (orgel-ctl :orgel01 :level10 0.2)

(unless (find-package :cl-orgelctl) (ql:quickload "papierorgel-projekt"))

(in-package :cl-orgelctl)

(orgel-ctl :orgel01 :level01 0.5)

(orgel-ctl :orgel01 :ramp-up 0.5)

(gethash :level01 *observed*)

(format nil "/~a/~a/~a" 'hallo :peng "Lydia")

(format t "Hallo")

(ccin 0)

(ats-cuda::reconnect-midi)

(setf (incudine::logger-level) :warn)

(copy-orgel-preset *curr-state* (aref *orgel-presets* 0))

(save-orgel-presets)

(incudine::rt-stop)

(defparameter *global-targets* nil)

(permute)

(setf *global-targets* '((level 1 1) (level 1 2) (level 2 1) (level 2 2) (level 1 3)
                         (level 1 5) (level 1 4) (level 2 11) (level 2 13) (level 2 3)
                         (level 1 15) (level 1 12) (level 2 7) (level 1 6) (level 2 5) (level 1 11)))

(setf *global-targets* '((level 3 1) (level 1 2) (level 1 1) (level 2 5) (level 1 3)
                         (level 1 5) (level 1 4) (level 2 11) (level 2 13) (level 2 3)
                         (level 3 15) (level 2 12) (level 2 7) (level 1 6) (level 2 5) (level 1 11)))


(setf (level 1 1) 0.2)


(switch-targets '((level 3 1) (level 1 2) (level 1 1) (level 2 5) (level 1 3)
                  (level 1 5) (level 1 4) (level 2 11) (level 2 13) (level 2 3)
                  (level 3 15) (level 2 12) (level 2 7) (level 1 6) (level 2 5) (level 1 11))
                :trigger '(bias-pos 1))

(switch-targets '((level 1 1) (level 1 2) (level 2 1) (level 2 2) (level 1 3)
                  (level 1 5) (level 1 4) (level 2 11) (level 2 13) (level 2 3)
                  (level 1 15) (level 1 12) (level 2 7) (level 1 6) (level 2 5) (level 1 11))
                :trigger '(bias-pos 1))


(get-trig-fns '(bias-pos 1))




(digest-route :orgel01 (:global ((bias-cos-n :bias-pos :bias-bw :targets *global-targets*)
                                 *global-targets*))
              nil)

(untrace)
(set-global-faders *global-targets* (n-bias-cos (bias-pos 1) (bias-bw 1) :targets *global-targets*))


(replace-keywords '(bias-cos :bias-pos :bias-bw :targets *global-targets*)
                  (orgel-nr :orgel01))

(defun set-levels ())



(let ((test `(level 1 1)))
  (setf (first test) 0.7))

(orgel-ctl-fader :orgel01 'level 2 0.8)

(gethash :orgel01 *orgeltargets*
         )
(set-faders :orgel01 :level (bias-wippe (bias-pos 1) (bias-bw 1)))

(funcall (bias-wippe (bias-pos 1) (bias-bw 1)) 0.4)

(bias-cos)

(/ 15.0 16)

(bias-bw :orgel01)

(set-faders :orgel01 :level)

(let ((fn (n-bias-cos 7/15 0.5)))
  (loop for x from 0 to 1 by 1/15 collect (funcall fn x)))

(defparameter *targets* '(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15))
(setf *targets* '(0 1 2 3 4 5 6 7))



*orgel-osc-responder*

(incf (base-freq :orgel01) 103)
