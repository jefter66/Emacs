(setq-default user-full-name "Jefter Santiago")
(setq-default user-mail-address "jeftersantiago@protonmail.com")

(load "~/.local/bin/private.el")

(setq confirm-kill-processes nil)
   (setq-default transient-mark-mode t)
   (setq-default visual-line-mode t)
   (setq-default truncate-lines nil)
   (setq-default cursor-type 'box)
   (setq-default fill-column 78)
   (setq-default sentence-end-double-space nil)
   ; i don't like syntax highlight very much
;   (global-font-lock-mode 0)

;;      (fset 'yes-or-no-p 'y-or-n-p)
        (defalias 'yes-or-no-p 'y-or-n-p)

(use-package smartparens
  :ensure t
  :config
  (sp-use-paredit-bindings)
  (add-hook 'prog-mode-hook #'smartparens-mode)
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET"))))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq inhibit-splash-screen t
;  initial-scratch-message nil
        initial-major-mode 'org-mode)
(setq inhibit-startup-echo-area-message t)

(setq kill-buffer-query-functions
  (remq 'process-kill-buffer-query-function
   kill-buffer-query-functions))
(setq scroll-step            1
scroll-conservatively  10000
mouse-wheel-scroll-amount '(1 ((shift) . 1))
mouse-wheel-progressive-speed nil
mouse-wheel-follow-mouse 't)

(defun insert-new-line-below ()
  "Add a new line below the current line"
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))
(global-set-key (kbd "C-o") 'insert-new-line-below)

(setq custom-file "~/.emacs.d/custom.el")

;    (use-package dracula-theme 
;      :config
;      (load-theme 'dracula t)
;      :ensure t)
     (use-package cherry-blossom-theme 
       :config
       (load-theme 'cherry-blossom t)
       :ensure t)

;; set transparency
(set-frame-parameter (selected-frame) 'alpha '(90 90))
(add-to-list 'default-frame-alist '(alpha 90 90))

(add-to-list 'default-frame-alist '(font . "Monospace 20"))
;; https://emacs.stackexchange.com/q/45895
(set-face-attribute 'fixed-pitch nil :family "Monospace 20")

(use-package default-text-scale
      :demand t
 :hook (after-init . default-text-scale-mode))

(global-set-key (kbd "C-x C-l") 'font-lock-mode)

(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(set-language-environment "UTF-8")
(global-prettify-symbols-mode t)

(use-package diff-hl
      :config
      (add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
      (add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode))

(global-display-line-numbers-mode)
(setq display-line-numbers-type 'relative)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(set-window-scroll-bars (minibuffer-window) nil nil)

(use-package rainbow-delimiters)
;; simple mode line
(use-package mood-line)
(mood-line-mode)

(use-package dired-sidebar
:ensure t)
(global-set-key (kbd "C-x C-n") 'dired-sidebar-toggle-sidebar)

(use-package dired-open
  :config
  (setq dired-open-extensions
        '(("doc" . "openoffice4")
          ("docx" . "openoffice4")
          ("xopp" . "xournalpp")
          ("gif" . "mirage")
          ("jpeg" ."mirage")
          ("jpg" . "mirage")
          ("png" . "mirage")
          ("mkv" . "mpv")
          ("avi" . "mpv")
          ("mov" . "mpv")
          ("mp3" . "mpv")
          ("mp4" . "mpv")
          ("pdf" . "xreader")
          ("webm" . "mpv")
          )))

(use-package dired-hide-dotfiles
        :config
        (dired-hide-dotfiles-mode)
        (define-key dired-mode-map "." 'dired-hide-dotfiles-mode))

(setq-default dired-listing-switches "-lhvA")
(add-hook 'dired-mode-hook (lambda () (dired-hide-details-mode 1)))

(defun my-reload-dir-locals-for-current-buffer ()
  "reload dir locals for the current buffer"
  (interactive)
  (let ((enable-local-variables :all))
        (hack-dir-local-variables-non-file-buffer)))

(defun my-reload-dir-locals-for-all-buffer-in-this-directory ()
  "For every buffer with the same `default-directory` as the
current buffer's, reload dir-locals."
  (interactive)
  (let ((dir default-directory))
        (dolist (buffer (buffer-list))
          (with-current-buffer buffer
                (when (equal default-directory dir))
                (my-reload-dir-locals-for-current-buffer)))))

;  (add-hook 'org-mode-hook 'font-lock-mode)

(require 'org-tempo)

(add-to-list 'org-modules 'org-tempo t)
  (use-package org-bullets
   :ensure t
   :config
   (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
   (setq org-ellipsis "⮟")

(font-lock-add-keywords
 'org-mode
 '(("^[[:space:]]*\\(-\\) "
        (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ; (setq org-src-tab-acts-natively t)
   (setq org-src-window-setup 'current-window)
   (add-to-list 'org-structure-template-alist
   '("el" . "src emacs-lisp"))

(require 'org-tempo)

(add-hook 'org-mode-hook 'auto-fill-mode)
(setq-default fill-column 79)
(setq org-todo-keywords '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)" "DROP(x!)"))
      org-log-into-drawer t)

(defun org-file-path (filename)
  " Return the absolute address of an org file, give its relative name"
  (concat (file-name-as-directory org-directory) filename))

(setq org-index-file (org-file-path "todo.org"))
(setq org-archive-location
      (concat (org-file-path "done.org") "::* From %s"))

;; copy the content out of the archive.org file and yank in the inbox.org
(setq org-agenda-files (list org-index-file))
                                        ; mark  a todo as done and move it to an appropriate place in the archive.
(defun hrs/mark-done-and-archive ()
  " Mark the state of an org-mode item as DONE and archive it."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree))
(global-set-key (kbd "C-c C-x C-s") 'hrs/mark-done-and-archive)
(setq org-log-done 'time)

(setq org-capture-templates
      '(("t" "Todo"
         entry
         (file+headline org-index-file "Inbox")
         "* TODO %?\n")))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)
(define-key global-map "\C-cc" 'org-capture)

(defun my/fix-inline-images ()
  (when org-inline-image-overlays
    (org-redisplay-inline-images)))
(add-hook 'org-babel-after-execute-hook 'my/fix-inline-images)
(setq-default org-image-actual-width 620)

(add-hook 'org-mode-hook
(lambda () (org-toggle-pretty-entities)))

(global-set-key (kbd "C-c i") 'org-toggle-inline-images)

(add-to-list 'org-file-apps '("\\.pdf" . "xreader %s"))
(global-set-key (kbd "C-x p") 'org-latex-export-to-pdf)

(setq org-html-postamble nil)
(setq browse-url-browse-function 'browse-url-generic
              browse-url-generic-program "firefox")
(setenv "BROWSER" "firefox")

(use-package graphviz-dot-mode
      :ensure t)
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

(setq TeX-auto-save t)
 (setq TeX-parse-self t)
 (setq TeX-save-query t)
 (setq-default TeX-master nil)
 (setq TeX-PDF-mode t)
; (add-hook 'LateX-mode-hook (lambda () (latex-preview-pane-mode)))
; (global-set-key (kbd "C-x l ") 'latex-preview-pane-mode)
 (global-set-key (kbd "C-x l ") 'pdflatex)
(add-to-list 'org-latex-packages-alist '("" "listings" nil))
(setq org-latex-listings t)   
(setq org-latex-listings-options '(("breaklines" "true")))

(use-package auctex
      :hook ((latex-mode LaTeX-mode) . tex)
      :config
   (add-to-list 'font-latex-math-environments "dmath"))
;  (use-package auctex-latexmk
;      :after auctex
;      :init
;   (auctex-latexmk-setup))

    (add-hook 'LaTeX-mode-hook 'visual-line-mode)
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

    (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    (setq reftex-plug-into-AUCTeX t)

;; with latex i like colors :)
(add-hook 'LaTeX-mode-hook 'font-lock-mode)

(require 'evil)
(evil-mode 1)

(use-package multi-term 
 :ensure t
 :config 
 (progn
   (global-set-key (kbd "C-x t") 'multi-term)))
 (setq multi-term-program "/bin/bash")

(ac-config-default)

(use-package yasnippet
      :ensure t
      :init
      (yas-global-mode 1))



(use-package swiper
      :ensure t
      :config
      (progn
        (ivy-mode 1)
        (setq ivy-use-virtual-buffers t)
        (global-set-key "\C-s" 'swiper)
        (global-set-key "\C-r" 'swiper)))

(use-package ace-window
  :ensure t
  :init
  (progn
        (global-set-key [remap other-window] 'ace-window)
        (custom-set-faces
         '(aw-leading-char-face
               ((t (:inherit ace-jump-face-foreground :height 2.0)))))
        ))

(use-package try
  :ensure t
  :config
  (progn  (global-set-key (kbd "C-x b") 'ivy-switch-buffer)))
(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-display-style 'fancy)

(use-package which-key
  :ensure t
  :config
  (which-key-mode))

;; backup disabled
(setq-default backup-inhibited t)
(setq-default create-lockfiles nil)
(setq-default make-backup-files nil)
(use-package real-auto-save
  :ensure t
  :demand t
  :config (setq real-auto-save-interval 10)
  :hook (prog-mode . real-auto-save-mode))

(use-package elcord
:config
(setq elcord-refresh-rate 5)
:init
(elcord-mode))
