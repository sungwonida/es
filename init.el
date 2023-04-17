;; Path for the local packages
(setq local-packages-path "~/.emacs.d/local/packages")
(add-to-list 'load-path local-packages-path)
(let ((default-directory local-packages-path))
  (normal-top-level-add-subdirs-to-load-path))

;; Install straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
	 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Install use-package
(straight-use-package 'use-package)

;; Configure use-package to use straight.el by default
(use-package straight
  :custom (straight-use-package-by-default t))

;; helm
(use-package helm
  :config
  (helm-mode)
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  ("C-x C-l" . helm-locate)
  ("C-x C-b" . helm-mini)
  ("C-x r b" . helm-filtered-bookmarks)
  ("C-c C-r" . helm-recentf)
  ("M-y" . helm-show-kill-ring)
  ("M-s o" . helm-occur)
  ("M-g M-o M-k" . helm-google-suggest)
  :custom
  (helm-split-window-in-side-p t)
  (helm-autoresize-mode	t)
  (helm-move-to-line-cycle-in-source t)
  (helm-ff-search-library-in-sexp t)
  (helm-scroll-amount 8)
  (helm-ff-file-name-history-use-recentf t)
  (helm-show-completion-display-function #'helm-show-completion-default-display-function))

;; helm-ls-git
(use-package helm-ls-git
  :bind ("C-c h f" . helm-ls-git-ls))

;; helm-git-grep
(use-package helm-git-grep
  :bind ("C-c h g" . helm-git-grep-at-point))

;; helm-projectile
(use-package helm-projectile
  :config
  (projectile-global-mode)
  :bind
  ("C-c h p" . helm-projectile)
  (:map projectile-mode-map ("C-c h a" . helm-projectile-ag))
  :custom
  (helm-ag-insert-at-point 'symbol))

;; helm-descbinds
(use-package helm-descbinds
  :config (helm-descbinds-mode))

;; diminish
(use-package diminish :ensure t)

;; org-mode
(use-package org-mode
  :config
  (defun org-templates-load-templates ()
    (interactive)
    (setq org-capture-templates
          '(("t" "Todo" entry (file "~/org/gtd.org")
             "* TODO %?\n  %i\n  %a")
            ("j" "Journal" entry (file+datetree "~/org/journal.org")
             "* %?\nEntered on %U\n  %i\n  %a")
            ("e" "Event" entry (file "~/org/event.org")
             "* %?\n  %U\n  %i\n  %a")))
    (add-to-list 'org-structure-template-alist
                 (list "p" (concat ":PROPERTIES:\n"
                                   "?\n"
                                   ":END:")))
    (add-to-list 'org-structure-template-alist
                 (list "eh" (concat ":EXPORT_FILE_NAME: ?\n"
                                    ":EXPORT_TITLE:\n"
                                    ":EXPORT_OPTIONS: toc:nil html-postamble:nil num:nil"))))
  (org-templates-load-templates)
  :bind
  ("C-c c" . org-capture)
  ("C-c l" . org-store-link)
  ("C-c a" . org-agenda)
  ("C-c b" . org-switchb)
  :custom
  (org-image-actual-width nil)
  (org-html-inline-image-rules
   '(("file" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'")
     ("http" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'")
     ("https" . "\\.\\(jpeg\\|jpg\\|png\\|gif\\|svg\\|bmp\\)\\'"))))

;; My swiss army knife (notes, todos, agenda, etc.)
(setq org-root-path (concat (file-name-as-directory (getenv "HOME")) (file-name-as-directory "org")))
(defun note ()
  "Show my Notes"
  (interactive)
  (find-file (concat org-root-path "note.org")))
(defun gtd ()
  "Show my TODOs"
  (interactive)
  (find-file (concat org-root-path "gtd.org")))
(defun dict ()
  "Show my Dictionary."
  (interactive)
  (find-file (concat org-root-path "dict.org")))
(defun scratch ()
  "Show my Scratch Pad."
  (interactive)
  (find-file (concat org-root-path "scratch.org")))

(setq org-default-notes-file
      (concat org-root-path "note.org"))

;; theme
(use-package vscode-dark-plus-theme
  :config
  (load-theme 'vscode-dark-plus t)
  (set-mouse-color "white"))

;; face
;;  Monaco for Linux
;;      1) http://www.gringod.com/wp-upload/software/Fonts/Monaco_Linux.ttf
;;      2) Copy the downloaded font into ~/.fonts/
;;      3) Run sudo fc-cache -fv
;;  Monaco for Windows
;;      1) http://www.gringod.com/wp-upload/software/Fonts/Monaco_5.1.ttf
;;      2) Copy the downloaded font into %SystemRoot%/Fonts/
(if (display-graphic-p)
    (progn
      (setq default-frame-alist
            '((width . 240)
              (height . 60)))
      (tool-bar-mode -1)
      ;; (menu-bar-mode -1)
      (scroll-bar-mode -1)
      (setq scroll-step 1)))

(set-language-environment '"Korean")
(prefer-coding-system 'utf-8)
(cond
 ((eq system-type 'gnu/linux)
  (add-to-list 'default-frame-alist '(font . "Monaco-10"))
  (set-fontset-font t 'hangul (font-spec :name "NanumGothicCoding")))
 ((eq system-type 'darwin)
  (add-to-list 'default-frame-alist '(font . "Monaco-10")))
 ((eq system-type 'windows-nt)
  (add-to-list 'default-frame-alist '(font . "Monaco-9"))
  (unicode-fonts-setup)))

;; anzu
(use-package anzu
  :config (global-anzu-mode +1))

;; tern
(use-package tern
  :hook (js-mode . (lambda () (tern-mode t))))

;; tern-auto-complete
(use-package tern-auto-complete
  :config (tern-ac-setup))

;; octave
(use-package octave
  :config
  (add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
  (defun my-octave-mode-hook ()
    (define-key octave-mode-map (kbd "M-s M-l") 'octave-send-line)
    (define-key octave-mode-map (kbd "M-s M-b") 'octave-send-block)
    (define-key octave-mode-map (kbd "M-s M-f") 'octave-send-defun)
    (define-key octave-mode-map (kbd "M-s M-a") 'octave-send-buffer)
    (define-key octave-mode-map (kbd "M-s M-r") 'octave-send-region))
  :hook
  (octave-mode . my-octave-mode-hook))

;; semantic
(use-package semantic
  :config
  (semantic-mode 1)
  (global-semantic-idle-summary-mode 1)
  :bind
  ("C-c i j" . semantic-ia-fast-jump)
  ("C-c i m" . semantic-ia-complete-symbol-menu))

;; stickyfunc-enhance
(use-package stickyfunc-enhance
  :config (add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode))

;; company
(use-package company
  :hook (prog-mode . (lambda ()
                       (company-mode t)
                       (define-key company-mode-map [backtab] 'company-complete)
                       (define-key company-active-map [tab] 'company-complete-selection))))

;; lsp-mode
(use-package lsp-mode
  :commands
  lsp
  :hook
  ((c-mode . lsp)
   (c++-mode . lsp)
   (objc-mode . lsp)
   (python-mode . lsp))
  :custom
  ;; '-background-index' requires clangd v8+
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error")))

(use-package lsp-ui
  :commands
  lsp-ui-mode
  :config
  (defun my-lsp-ui-mode-hook ()
    (define-key lsp-ui-mode-map [remap xref-find-definitions] #'lsp-ui-peek-find-definitions)
    (define-key lsp-ui-mode-map [remap xref-find-references] #'lsp-ui-peek-find-references))
  (my-lsp-ui-mode-hook))

(use-package company-lsp
  :commands company-lsp)

(use-package helm-lsp
  :commands helm-lsp-workspace-symbol)

(add-hook 'lsp-mode-hook #'lsp-headerline-breadcrumb-mode)

;; magit
(use-package magit
  :diminish
  magit-auto-revert-mode
  :bind
  ("C-c v s" . magit-status)
  ("C-c v y" . magit-show-refs-popup)
  ("C-c v l" . magit-log-head))

;; exec-path-from-shell
(use-package exec-path-from-shell
  :config
  (when (or (not (eq system-type 'windows-nt))
	    (memq window-system '(mac ns)))
    (setq exec-path-from-shell-check-startup-files nil)
    (setq exec-path-from-shell-variables '("PATH"))
    (exec-path-from-shell-initialize)))

;; Auto-save, File Lock and Backup
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; yes-or-no
(defalias 'yes-or-no-p 'y-or-n-p)

;; Mark the region in Windows
(cond
 ((string-equal system-type "windows-nt")
  (global-set-key [C-kanji] 'set-mark-command)))

;; Suppress the startup page
(setq inhibit-startup-message t)

;; Google Translate
(use-package google-translate
  :config
  (defun my-google-translate-query-translate-ko-to-en ()
    (interactive)
    (let ((google-translate-default-source-language "ko")
          (google-translate-default-target-language "en"))
      (google-translate-query-translate)))
  :custom
  (google-translate-default-source-language "en")
  (google-translate-default-target-language "ko")
  :bind
  ("C-M-g" . google-translate-at-point)
  ("M-g t" . google-translate-query-translate)
  ("M-g k t" . my-google-translate-query-translate-ko-to-en))

;; Quick Insert-Date
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %a %p %l:%M")))

;; Easier transition between the windows
;;	 M-up, M-down, M-left, and M-right keys.
(windmove-default-keybindings 'meta)

;; spawning the windows
(fset 'spawn-window-right
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 51 M-left] 0 "%d")) arg)))
(fset 'spawn-window-left
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 51 M-right] 0 "%d")) arg)))
(fset 'spawn-window-down
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 50 M-down] 0 "%d")) arg)))
(fset 'spawn-window-up
      (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ([24 49 24 50 M-up] 0 "%d")) arg)))
(bind-key* "C-<right>" 'spawn-window-left)
(bind-key* "C-<left>" 'spawn-window-right)
(bind-key* "C-<down>" 'spawn-window-down)
(bind-key* "C-<up>" 'spawn-window-up)

;; dired-mode
(defun mydired-sort ()
  "Sort dired listings with directories first."
  (save-excursion
    (let (buffer-read-only)
      (forward-line 2) ;; beyond dir. header
      (sort-regexp-fields t "^.*$" "[ ]*." (point) (point-max)))
    (set-buffer-modified-p nil)))

(defadvice dired-readin
  (after dired-after-updating-hook first () activate)
  "Sort dired listings with directories first before adding marks."
  (mydired-sort))

(add-hook 'dired-mode-hook
          (function (lambda ()
     		      (load "dired-x")
                      ;; Set dired-x buffer-local variables here.  For example:
                      (setq dired-omit-files-p t)
     		      (setq dired-omit-files "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..+$")
     		      (setq dired-omit-extensions '("~"))
                      )))

(defun my-dired-mode-hook ()
  (define-key dired-mode-map [backspace] 'dired-up-directory))
(add-hook 'dired-mode-hook 'my-dired-mode-hook)

;; Development generic
(add-hook 'prog-mode-hook '(lambda () (setq tab-width 4)))
(add-hook 'before-save-hook 'prog-delete-trailing-whitespace)

(defun prog-delete-trailing-whitespace ()
  (interactive)
  (when (derived-mode-p 'prog-mode 'emacs-lisp-mode)
    (delete-trailing-whitespace)))
(add-hook 'before-save-hook 'prog-delete-trailing-whitespace)

;;; yasnippet
(use-package yasnippet
  :init (add-hook 'prog-mode-hook #'yas-minor-mode)
  :config (yas-reload-all))

;; CMake
(setq cmake-tab-width 4)

;; C
(add-to-list 'auto-mode-alist '("\\.cpp\\'" . c++-mode))
(setq c-basic-offset 4)
(setq c-default-style
	  '((c-mode . "k&r")
		(c++-mode . "k&r")
		(java-mode . "java")
		(awk-mode . "awk")
		(other . "gnu")))

(defun my-c-mode-common-hook ()
  (hs-minor-mode t)
  (define-key c-mode-base-map (kbd "M-o") 'eassist-switch-h-cpp)
  (define-key c-mode-base-map (kbd "M-m") 'helm-semantic-or-imenu)
  (local-set-key (kbd "C-c u") 'hs-toggle-hiding)
  (local-set-key (kbd "C-c <down>") 'hs-hide-all)
  (local-set-key (kbd "C-c <up>") 'hs-show-all))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(defun highlight-if-0/1 ()
  "Modify the face of text in between #if 0 ... #endif."
  (interactive)
  (setq cpp-known-face 'default)
  (setq cpp-unknown-face 'default)
  (setq cpp-face-type 'dark)
  (setq cpp-known-writable 't)
  (setq cpp-unknown-writable 't)
  (setq cpp-edit-list
        '((#("1" 0 1
             (fontified nil))
           nil
           (foreground-color . "dim gray")
           both nil)
          (#("0" 0 1
             (fontified nil))
           (foreground-color . "dim gray")
           nil
           both nil)))
  (cpp-highlight-buffer t))

(defun c-cpp-highlight-if-0/1 ()
  (when (derived-mode-p 'c-mode 'c++-mode)
    (highlight-if-0/1)))
(add-hook 'c-mode-common-hook 'c-cpp-highlight-if-0/1)
(add-hook 'before-save-hook 'c-cpp-highlight-if-0/1)

;; Python
(defun my-python-mode-hook ()
  (define-key python-mode-map (kbd "M-m") 'helm-semantic-or-imenu))
(add-hook 'python-mode-hook 'my-python-mode-hook)
(define-key lisp-mode-shared-map (kbd "M-m") 'helm-semantic-or-imenu)

;; elpy
(use-package elpy
  :init
  (defun my-elpy-mode-hook ()
	(cl-dolist (key '("C-<right>" "C-<left>" "C-<down>" "C-<up>" "M-<right>" "M-<left>" "M-<down>" "M-<up>"))
      (define-key elpy-mode-map (kbd key) nil))
	(print "applied my-elpy-mode-hook"))
  :config
  (elpy-enable)
  :hook
  (elpy-mode . my-elpy-mode-hook))

;; jedi
(use-package jedi
  :config
  (jedi:setup)
  :custom
  (jedi:use-shortcuts t)
  (jedi:complete-on-dot t))

;; py-autopep8
(use-package py-autopep8
  :hook (python-mode . py-autopep8-mode)
  :custom (py-autopep8-options '("--max-line-length=119")))

;; smartparens
(use-package smartparens
  :config
  (smartparens-global-mode t)
  :diminish
  (smartparens-mode "()"))

;; Recent files
;; (require 'recentf)
;; (setq recentf-auto-cleanup 'never)
(recentf-mode 1)
(setq recentf-keep
	  '(lambda (file)
		 (cond
          ((file-remote-p file nil t)
           (file-readable-p file))
          ((file-readable-p file)))))

;; eshell
(add-hook 'eshell-mode-hook
		  '(lambda ()
			 (define-key eshell-mode-map (kbd "C-c C-l") 'helm-eshell-historyoctave-send-line)))

;; redo
(use-package redo+
  :bind ("C-." . redo))

;; smart-compile
(use-package smart-compile)

;; tdd
;;		Turn on/off the mode manually because it runs recompile automatically
;;		after saving any buffer no matters it's prog-mode or not.
(use-package tdd
  :straight nil
  :load-path local-packages-path
  :init (defun selective-tdd-after-save ()
		  (when (derived-mode-p 'c-mode 'c++-mode 'cmake-mode) (tdd-after-save)))
  :config (custom-set-variables '(tdd-test-function (smart-compile)))
  :hook (after-save . selective-tdd-after-save)
  :bind ([f12] . tdd-mode))

;; Semantic Refactor
(use-package srefactor
  :init
  (defun my-srefactor-mode-hook ()
	(define-key c-mode-map (kbd "M-s M-RET") 'srefactor-refactor-at-point)
	(define-key c++-mode-map (kbd "M-s M-RET") 'srefactor-refactor-at-point))
  :hook
  (c-mode . my-srefactor-mode-hook)
  (c++-mode . my-srefactor-mode-hook))

;; Pandoc
(if (or (eq system-type 'gnu/linux) (eq system-type 'darwin))
    (setq markdown-command "pandoc"))

;; Publishing the live buffer
;;		http://stackoverflow.com/questions/36183071/how-can-i-real-time-preview-markdown-in-emacs]]
;;		1) M-x httpd-start
;;		2) M-x impatient-mode
;;		3) localhost:8080/imp
(use-package simple-httpd)
(use-package impatient-mode)
(defun markdown-html (buffer)
  (princ (with-current-buffer buffer
           (format "<!DOCTYPE html><html><title>Impatient Markdown</title><xmp theme=\"united\" style=\"display:none;\"> %s  </xmp><script src=\"http://strapdownjs.com/v/0.2/strapdown.js\"></script></html>" (buffer-substring-no-properties (point-min) (point-max))))
         (current-buffer)))

;; Replace the region with yank buffer
(delete-selection-mode 1)

;; Anaconda
(use-package conda
  :config
  (conda-env-initialize-interactive-shells)
  (conda-env-initialize-eshell)
  (conda-env-autoactivate-mode t)
  :custom
  (let (setq conda-anaconda-home
			 (concat
			  (file-name-as-directory (getenv "HOME"))
			  "miniconda3"))
	(conda-env-home-directory conda-anaconda-home)))

;; highlight-symbol
(use-package highlight-symbol
  :init
  (defun my-highlight-symbol-hook ()
	(highlight-symbol-mode)
	(define-key prog-mode-map [(shift control s)] 'highlight-symbol-next)
	(define-key prog-mode-map [(shift control r)] 'highlight-symbol-prev)
	(define-key prog-mode-map (kbd "C-c h h") 'highlight-symbol)
	(define-key prog-mode-map (kbd "C-c h r") 'highlight-symbol-remove-all)
	(define-key prog-mode-map (kbd "C-c h q") 'highlight-symbol-query-replace))
  :hook
  (prog-mode . my-highlight-symbol-hook)
  :custom
  (highlight-symbol-on-navigation-p t))

;; Saving Emacs Sessions
(desktop-save-mode 1)
