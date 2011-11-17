(add-to-list 'load-path "~/.emacs.d")
(load "kal")

;loads ruby mode when a .rb file is opened.
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
;(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))
;You must turn on font-lock-mode. Try M-X font-lock-mode after you have opened a ruby file
(global-font-lock-mode 1)

(setq c-default-style "bsd"
      c-basic-offset 4)

