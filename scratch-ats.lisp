;;;; Scratchpad für papierorgel.lisp

(unless (find-package :cl-orgelctl) (ql:quickload "papierorgel-projekt"))
(in-package :ats-cuda)

(defparameter village01 nil)
(defparameter village02a nil)
(defparameter village02b nil)

(tracker "/home/orm/work/unterricht/frankfurt/ss_23/yan/yan-2023-04-19/export/village01.wav"
           'village01
           :start 0.0
           :hop-size 1/4
           :lowest-frequency 100.0
           :highest-frequency 20000.0
           :frequency-deviation 0.5
           :lowest-magnitude (db-amp -40)
           :SMR-continuity 0.7
           :track-length 6
           :min-segment-length 3
           :residual "/tmp/village01-res.snd"
           :verbose nil
           :debug nil)

(tracker "/home/orm/work/unterricht/frankfurt/ss_23/yan/village02a.wav"
           'village02a
           :start 0.0
           :hop-size 1/4
           :lowest-frequency 100.0
           :highest-frequency 20000.0
           :frequency-deviation 0.5
           :lowest-magnitude (db-amp -40)
           :SMR-continuity 0.7
           :track-length 6
           :min-segment-length 3
           :residual "/tmp/village02a-res.snd"
           :verbose nil
           :debug nil)

(tracker "/home/orm/work/unterricht/frankfurt/ss_23/yan/village02b.wav"
           'village02b
           :start 0.0
           :hop-size 1/4
           :lowest-frequency 100.0
           :highest-frequency 20000.0
           :frequency-deviation 0.5
           :lowest-magnitude (db-amp -40)
           :SMR-continuity 0.7
           :track-length 6
           :min-segment-length 3
           :residual "/tmp/village02b-res.snd"
           :verbose nil
           :debug nil)

(slynk:eval-in-emacs "(incudine-hush)")
(incudine::node-free-all)

(defun ftom (freq)
  (+ 69 (* 12 (log (/ freq 440) 2))))


(defun filter-chord (chord &key (db-thresh -60))
  (let ((new-chord (remove-duplicates (sort chord (lambda (x y) (or (< (first x) (first y))
                                                                 (and (= (first x) (first y))
                                                                      (> (second x) (second y))))))
                                      :key #'first :from-end t)))
    (remove-if (lambda (evt) (or (< (second evt) db-thresh) (> (first evt) 87))) new-chord)))

(defun get-chords (ats-snd &key (db-thresh -60) (tscale 10))
  (with-slots (frames partials frq amp) ats-snd
    (loop for frame below frames by tscale
          collect
          (list :time frame
                :chord
                (filter-chord
                 (loop
                   for partial below partials
                   collect (list
                            (let ((f (aref frq partial frame)))
                              (if (zerop f) 0 (round (ftom f))))
                            (let ((amp (aref amp partial frame)))
                              (if (zerop amp) -100 (ou:amp->db amp)))))
                 :db-thresh db-thresh)))))

(defun collect-midi-evts (chd &key (tscale 10) )
  (let ((time (float (/ (getf chd :time) tscale) 1.0)))
    (loop for (keynum db) in (getf chd :chord)
          collect (cm:new cm:midi :time time :keynum keynum
                    :duration (float (/ tscale) 1.0) :amplitude (float (ou:db->amp (* 0.5 db)) 1.0)))))

(let* ((snd village02a)
       (evts1 (loop for x in (get-chords snd :db-thresh -60 :tscale 10)
                    append (collect-midi-evts x :tscale 100)))
       (evts2 (loop for x in (get-chords snd :db-thresh -90)
                   append (collect-midi-evts x :tscale 80))))
;;;  (sin-noi-synth 0.0 snd :amp-scale 0.3)
;;;  (cm:events evts1 cm:*rts-out*)
  (cm:events evts2 "/tmp/village02a.midi" :play t)
;;;  (cm:events evts2 "/tmp/village02a.ly")
  nil)

(cm:sprout (cm:import-events "/tmp/village02a.midi"))

(let* ((snd village02b)
       (evts1 (loop for x in (get-chords snd :db-thresh -90 :tscale 10)
                    append (collect-midi-evts x :tscale 100)))
       (evts2 (loop for x in (get-chords snd :db-thresh -90)
                   append (collect-midi-evts x :tscale 80))))
  (sin-noi-synth 0.0 snd :amp-scale 0.3)
  (cm:events evts1 cm:*rts-out*)
  (cm:events evts2 "/tmp/village02b.midi" :play nil)
;;;  (cm:events evts2 "/tmp/village02b.ly")
  nil)

presets bis Freitag Abend

Transport letzte Worte Freitag Abend.

(progn
  (sin-noi-synth 0.0 village02b :amp-scale 1)
  (cm:sprout (cm:import-events "/tmp/village02b.midi")))

(node-free-all)



(browser-play village01 :amp-scale 0.3)

(cm:sprout (cm:new cm:midi :time 0))
(db-amp)
(defparameter *ats-snd-dir*
  (asdf:system-relative-pathname :ats-cuda "snd/"))

(defparameter *ats-snd-dir*
  (asdf:system-relative-pathname :papierorgel-projekt "snd/"))

(setf *ats-snd-dir*
            (pathname "/home/orm/work/unterricht/frankfurt/ws_22_23/musikinformatik/lisp/snd/"))

(browser-play village02b :id 2 :amp-scale 0.5)

(ats->svg cl)
*curr-browser-player*
(browser-play cl :id 2 :amp-scale 0.5)

(set-control 2 :res-bal 0)

(rt-start)

(defparameter *test* (make-array 1 :initial-contents (list (make-array 1 :element-type 'double-float))))

(ats-setf *test* 0 0 1.2d0)

(setf (ats-aref *test* 0 0) 2d0)

(defun (setf ats-aref) (val array partial frame)
  (setf (aref (aref array partial) frame) val))

(typep (ats-sound-frq barock) '(array (array double-float)))

(progn
  (tracker "barock.wav"
	   'barock
	   :start 0.0
	   :hop-size 1/4
	   :lowest-frequency 50.0
	   :highest-frequency 20000.0
	   :frequency-deviation 0.2
	   :lowest-magnitude (db-amp -45)
	   :SMR-continuity 0.7
	   :track-length 6
	   :min-segment-length 3
	   :residual "/tmp/sample3.snd"
	   :verbose nil
	   :debug nil)
  (sin-noi-synth 0 barock :amp-scale 0.3 :noise-only nil))
(browser-play Barock :amp-scale 0.1)
(setf (bw *curr-browser-player*) 10)
(incudine::i-aref-n)

(typep 0 'non-negative-integer)
(list 0 most-positive-fixnum)

(browser-play barock :amp-scale 0.1)

(broadcast-message "reload")

(type-of
 (make-array 1 :element-type '(simple-array (simple-array double-float *))
               :adjustable t
               :initial-contents
             (ou:n-collect 1
                           (make-array 1 :element-type 'double-float :initial-element (double 0.0))))
)

(length (aref (make-ats-array 10 20) 1))


(array-dimension
 (make-array 5 :element-type '(simple-array double-float 10)

              :initial-contents (n-collect 5 (make-array 10 :element-type 'double-float :initial-element 0.0d0))) 0)



(make-array 2 :element-type 'double-float)

(length (array-slice (make-array '(10 20)) 1))

(array-dimension
 (make-array 10 :initial-contents (n-collect 10
                                             (make-array 20 :element-type 'double-float :initial-element (double 0.0)))
                :element-type '(array double-float *)) 0)

  (time *sample-darray* :type (array double-float *))

(labels ((fn (idx &optional seq)
           (if (< idx 10)
               (cons
                (let ((n idx))
                  (make-array 20 :element-type 'double-float :initial-element
                              (double 0.0)))
                (fn (+ idx 1) seq))
               seq)))
  (fn 0 nil))

*curr-browser-player*

(setf (bw *curr-browser-player*) 1000)

(progn
  (tracker "sample3.wav"
	   'sample3
	   :start 0.0
	   :hop-size 1/4
	   :lowest-frequency 100.0
	   :highest-frequency 20000.0
	   :frequency-deviation 0.05
	   :lowest-magnitude (db-amp -75)
	   :SMR-continuity 0.7
	   :track-length 6
	   :min-segment-length 3
	   :residual "/tmp/sample3.snd"
	   :verbose nil
	   :debug nil)
  (sin-noi-synth 0 sample3 :amp-scale 0.3 :noise-only nil))

(sin-noi-synth 0 sample3 :amp-scale 1 :time-ptr '(0 1 1 0))
(browser-play sample3)

(browser-play sample3)

(progn
  (defvar cl nil)
  (defvar crt-cs6 nil)
  (defvar said nil)
  (defvar barock nil)

  (tracker "clarinet.aif"
	   'cl
	   :start 0.0
	   :hop-size 1/4
	   :lowest-frequency 100.0
	   :highest-frequency 20000.0
	   :frequency-deviation 0.05
	   :lowest-magnitude (db-amp -70)
	   :SMR-continuity 0.7
	   :track-length 6
	   :min-segment-length 3
	   :residual "/tmp/cl-res.snd"
	   :verbose nil
	   :debug nil)
  
  (tracker "clarinet.aif"
	   'cl
	   :start 0.0
	   :hop-size 1/4
	   :lowest-frequency 100.0
	   :highest-frequency 20000.0
	   :frequency-deviation 0.05
	   :lowest-magnitude (db-amp -70)
	   :SMR-continuity 0.7
	   :track-length 6
	   :min-segment-length 3
	   :residual "/tmp/cl-res.snd"
	   :verbose nil
	   :debug nil)

  (tracker "crt-cs6.snd" 
	   'crt-cs6
	   :start 0.1
	   :lowest-frequency 500.0
	   :highest-frequency 20000.0
	   :frequency-deviation 0.15
	   :window-cycles 4
	   :window-type 'blackman-harris-4-1
	   :hop-size 1/8
	   :lowest-magnitude (db-amp -90)
	   :amp-threshold -80
	   :track-length 6
	   :min-segment-length 3
	   :last-peak-contribution 0.5
	   :SMR-continuity 0.3
	   :residual "/tmp/crt-cs6-res.snd"
	   :verbose nil
	   :debug nil
	   :optimize t)
    (tracker "/home/orm/work/unterricht/frankfurt/ws_22_23/musikinformatik/lisp/snd/said.wav"
           'said
           :start 0.0
           :hop-size 1/4
           :lowest-frequency 100.0
           :highest-frequency 20000.0
           :frequency-deviation 0.1
           :lowest-magnitude (db-amp -30)
           :SMR-continuity 0.7
           :track-length 6
           :min-segment-length 3
           :residual "/tmp/said-res.snd"
           :verbose nil
           :debug nil))

(sin-noi-synth 0 crt-cs6 :amp-scale 1 :duration 150 :noise-only t :time-ptr '(0 0 0.001 0.1 1 1))




()

(coords)
(browser-play village01 :amp-scale 0.0)


(node-free-all)
(sin-noi-synth 0.0 village01 :amp-scale 0.1)

(setf (bw *curr-browser-player*) 10)
(rt-start)
(setf (bw *curr-browser-player*) 10)
(browser-play cl)
*bw*

11th Gen i511500H at 2.9GHz

(sin-noi-synth 0 cl :amp-scale 0.1)

(sin-noi-rtc-synth 0.2 cl :amp-scale 0.1 :id 5)

(sin-noi-rtc-synth 0.1 cl :amp-scale 0.1 :id 6)

(set-control 5 :soundpos 0.6 )

(set-control 5 :amp-scale 0.01)

(rt-start)

(case)
(setf (bw *curr-browser-player*) 10)

*curr-browser-player*
(browser-play cl :amp-scale 0.1)
(browser-play crt-cs6)
*curr-browser-player*
(reconnect-midi)

*midi-in1*

(defun coords (x y)
;;  (format t "x: ~,2f, y: ~,2f~%" x y)
  (set-control 2 :soundpos x)
  (setf (browser-player-soundpos *curr-browser-player*) x)
  (setf (browser-player-mousefreq *curr-browser-player*)
        (* (max 0.0 (min y 1.0)) (browser-player-maxfreq *curr-browser-player*)))
  (recalc-amps))


(setf (bw *curr-browser-player*) 100)
(set-control (browser-player-id *curr-browser-player*) :bw 100)
(add-ats-cc-responder 2 (lambda (val)
                          (setf (browser-player-bw *curr-browser-player*)
                                (* 10000 (expt 1/1000 val)))
                          (recalc-amps)))

(add-ats-cc-responder 3 (lambda (val)
                          (setf (browser-player-amp-scale *curr-browser-player*) val)
                          (set-control (browser-player-id *curr-browser-player*)
                                       :amp-scale val)))

(add-ats-cc-responder 4 (lambda (val)
                          (setf (browser-player-res-bal *curr-browser-player*) val)
                          (set-control (browser-player-id *curr-browser-player*)
                                       :res-bal val)))

(remove-ats-channel-cc-responders 5)

(remove-ats-channel-cc-responders 5)

(cl-orgelctl::remove-channel-cc-responders 5)
(setf (incudine::logger-level) :warn)
(setf (incudine::logger-level) :info)

*midi-in1*
(in-package #:cl-orgelctl)


(defparameter *global-targets* nil)

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
