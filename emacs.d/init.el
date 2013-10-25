;;; init.el --- Where the magic begins
;;
;; portions borrowed from Emacs Starter Kit
;;
;; This is first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the same
;; way that the noonday sun does the stars. It is not just bigger and
;; brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

; allows syntax highlighting to work
 (global-font-lock-mode 1)
;;; --- start original kal.el

(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/vendor")
(add-to-list 'load-path "/usr/local/scala/misc/scala-tool-support/emacs")
;(require 'scala-mode-auto)

;;(setq custom-file "~/.emacs.d/local.el")
(setq custom-file "~/.emacs.d/old-lisp/custom.el")
(load custom-file 'noerror)

;; go mode
;;(setq load-path (cons "/usr/local/go/misc/emacs" load-path))
;;(require 'go-mode-load)

(global-auto-revert-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; stuff from old .emacs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;(load "kal")

;loads ruby mode when a .rb file is opened.
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".ru$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '(".rake$" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '("Gemfile" . ruby-mode) auto-mode-alist))
(setq auto-mode-alist  (cons '("Rakefile" . ruby-mode) auto-mode-alist))
;(setq auto-mode-alist  (cons '(".rhtml$" . html-mode) auto-mode-alist))

;You must turn on font-lock-mode. Try M-X font-lock-mode after you have opened a ruby file
(global-font-lock-mode 1)

(setq c-default-style "bsd"
      c-basic-offset 4)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; showoff mode
;;(add-to-list 'load-path "~/.emacs.d/vendor/showoff-mode")
;;(require 'showoff-mode)
;;(add-to-list 'auto-mode-alist '("\\.md$" . showoff-mode))


;(load "kal/ecb")
;(load "kal/env")
;(load "kal/global")
(load "defuns")
;(load "kal/bindings")
;(load "kal/tabs")
;(load "kal/disabled")
;(load "kal/fonts")
;(load "kal/utf-8")
;(load "kal/scratch")
;(load "kal/grep")
;(load "kal/diff")
;(load "kal/ido")
;(load "kal/dired")
;(load "kal/recentf")
;(load "kal/rectangle")
;;(load "kal/org")
;(load "kal/zoom")
;(load "kal/flymake")
;(load "kal/javascript")
;(load "kal/ri-emacs")
;(load "kal/mac")
;(load "kal/server-mode")
;(load "kal/shell-mode")
;(load "kal/private" 'noerror)

;(load 'kal/color-theme)
;(load 'maxframe)
;(load "kal/yasnippet")

;; (load "kal/hl-line")
;; (load "kal/iswitchb")

(add-to-list 'load-path "~/.emacs.d/vendor/coffee-mode")
(require 'coffee-mode)
;;(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(vendor 'ruby-mode)
;(vendor 'go-mode)
;(vendor 'rinari)
;(load "kal/haml-mode")
;(load "kal/sass-mode")
;;(vendor 'textmate)
;;(vendor 'filladapt)
(vendor 'coffee-mode)
;(vendor 'htmlize)
;;(vendor 'full-ack      'ack 'ack-same 'ack-find-same-file 'ack-find-file 'ack-interactive)
;;(vendor 'cdargs        'cv 'cdargs)
;(vendor 'magit         'magit-status)
;;(vendor 'psvn          'svn-status)
(vendor 'js2-mode      'js2-mode)
;(load "kal/markdown-mode")
(add-to-list 'load-path "~/.emacs.d/vendor/markdown-mode")
(autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;(vendor 'markdown-mode 'markdown-mode)
;;(vendor 'textile-mode  'textile-mode)
;;(vendor 'csv-mode      'csv-mode)
;(vendor 'yaml-mode     'yaml-mode)
;;(vendor 'inf-ruby      'inf-ruby)
;;(vendor 'rcodetools    'xmp)
;(vendor 'yasnippet)
;;(vendor 'jekyll)
;;(vendor 'lua-mode      'lua-mode)
;;(vendor 'feature-mode)
;;(vendor 'mode-line-bell)
;;(vendor 'revbufs       'revbufs)

;; (vendor 'ruby-electric 'ruby-electric-mode)
;; (vendor 'auctex)

(transient-mark-mode 1) ; makes the region visible
(line-number-mode 1)    ; makes the line number show up
(column-number-mode 1)  ; makes the column number show up

(add-to-list 'load-path   "~/.emacs.d/plugins/yasnippet-0.6.1c")
    (require 'yasnippet) ;; not yasnippet-bundle
    (yas/initialize)
    (yas/load-directory "~/.emacs.d/plugins/yasnippet-0.6.1c/snippets")

(add-to-list 'auto-mode-alist '("Guardfile" "Rakefile" . ruby-mode))

(add-hook 'c-mode-common-hook
               (lambda ()
                (font-lock-add-keywords nil
                 '(("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)))))

;; cycle through buffers with Ctrl-Tab (like Firefox)
(global-set-key (kbd "<C-tab>") 'bury-buffer)

;;showing trailing whitespace
(add-hook 'makefile-mode-hook
  (lambda()
    (setq show-trailing-whitespace t)))

;;showing line numbers
;;(add-hook 'ruby-mode-hook
;;  (lambda() (linum-mode 1)))

;;(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
;;(global-set-key (kbd "C-<f5>") 'linum-mode)


;; -------------
;; color config
;; -------------

;(defvar bjh-color 'dark) ;; light or dark?


;; -----------------
;; package.el config
;; -----------------

;(require 'cl)
;(require 'package)
;(setq package-archives '(;("gnu" . "http://elpa.gnu.org/packages/")
			 ;("marmalade" . "http://marmalade-repo.org/packages/")
;                         ("melpa" . "http://melpa.milkbox.net/packages/")))
;(setq package-enable-at-startup nil)
;(package-initialize)

;(defvar bjh-packages
;  '(ag
;    autopair
;    browse-kill-ring
;    buffer-move
;    c-eldoc
;    clojure-mode
;    coffee-mode
;    color-theme
;    dash
;    deft
;    diminish
;    dired-single
;    enh-ruby-mode
;    erlang
;    evil
;    expand-region
;    find-file-in-project
;    flycheck
;    flymake
;    flymake-go
;    full-ack
;    gist
;    git-commit-mode
;    git-rebase-mode
;    gitignore-mode
;    gnuplot-mode
;    go-autocomplete
;    go-eldoc
;    go-errcheck
;    go-mode
;    goto-last-change
;    haskell-mode
;    highlight-parentheses
;    gitconfig-mode
;    htmlize
;    idle-highlight-mode
;    ido-ubiquitous
;    js-comint
;    js2-mode
;    magit
;    markdown-mode
;    multi-term
;    paredit
;    php-mode
;    puppet-mode
;    rainbow-mode
;    redo+
;    rust-mode
;    scala-mode2
;    scpaste
;    scratch
;    slime
;    smex
;    smooth-scrolling
;    undo-tree
;    vcl-mode
;    yaml-mode
;    yasnippet))

;(defun bjh-install-packages ()
   ;(interactive)
   ;(package-refresh-contents)
;  (mapc #'(lambda (package)
;            (unless (package-installed-p package)
;              (package-install package)))
;        bjh-packages))
