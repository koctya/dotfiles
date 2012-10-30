;; Load CEDET.
;; This is required by ECB which will be loaded later.
;; See cedet/common/cedet.info for configuration details.
(load-file "~/.emacs.d/vendor/cedet-1.0/common/cedet.el")

;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; * This enables the database and idle reparse engines
(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
(semantic-load-enable-code-helpers)

;; enable ecb
(add-to-list 'load-path "~/.emacs.d/vendor/ecb-2.40")
(load-file "~/.emacs.d/vendor/ecb-2.40/ecb.el")

