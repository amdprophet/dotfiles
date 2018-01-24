;;;;; Package Management

(require 'package)
(package-initialize)

(setq package-archives
      '(("melpa-stable" . "https://stable.melpa.org/packages/")
	("gnu"         . "https://elpa.gnu.org/packages/")
	("org"         . "https://orgmode.org/elpa/")))

;; only want stable melpa for now
;;("melpa"       . "https://melpa.org/packages/")

;; no longer maintained?
;;("marmalade"   . "https://marmalade-repo.org/packages/")

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)


;;;;; Override Emacs Defaults

;; turn off mouse interface early in startup to avoid momentary display
(when (fboundp 'menu-bar-mode) (menu-bar-mode 0))
(when (fboundp 'tool-bar-mode) (tool-bar-mode 0))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode 0))

;; disable startup message
(setq inhibit-startup-message t)

;; disable beep sound
(setq ring-bell-function 'ignore)

;; making tooltips appear in the echo area
(tooltip-mode 0)
(setq tooltip-use-echo-area t)

;; highlight current line
(global-hl-line-mode 0)

;; display column number in mode line
(column-number-mode 1)

;; show buffer file name in title bar
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; electric-pair-mode
(electric-pair-mode 1)
(show-paren-mode 1)

;; windmove keybindings (use shift & arrows to navigate between windows)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))


;;;;; Themes

;; solarized-theme
(use-package color-theme
  :ensure t
  :config
  (load-theme 'tango-dark t))

;; rainbow-mode
(use-package rainbow-mode
  :ensure t
  :config
  (rainbow-mode))


;;;;; Completion

(use-package flx)

(use-package ivy
  :ensure t
  :diminish ivy-mode
  :config
  (ivy-mode 1)
  ;; fuzzy-search
  ;;(setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
  ;;(setq ivy-initial-inputs-alist nil)
  (bind-key "C-c C-r" 'ivy-resume))

;; ivy-rich
;; https://github.com/Yevgnen/ivy-rich
(use-package ivy-rich
  :after ivy
  :init
  (setq ivy-rich-abbreviate-paths t)
  :config
  (ivy-set-display-transformer 'ivy-switch-buffer 'ivy-rich-switch-buffer-transformer))

(use-package swiper
  :bind
  (([remap isearch-forward]  . swiper)
   ([remap isearch-backward] . swiper))
  :custom
  (swiper-action-recenter t))

(use-package ag
  :ensure t
  :config
  (add-hook 'ag-mode-hook 'toggle-truncate-lines)
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers 't))

(use-package counsel
  :ensure t
  :bind
  ("M-x" . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("<f1> C-f" . counsel-describe-function)
  ("<f1> v" . counsel-describe-variable)
  ("<f1> l" . counsel-find-library)
  ("<f2> i" . counsel-info-lookup-symbol)
  ("<f2> u" . counsel-unicode-char)
  ("C-c g" . counsel-git)
  ("C-c j" . counsel-git-grep)
  ("C-c k" . counsel-ag)
  ("C-x l" . counsel-locate)
  ("C-S-o" . counsel-rhythmbox))

;; company
(use-package company
  :ensure t
  :diminish company-mode
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :bind
  ("M-/" . company-complete-common)
  :config
  (setq company-dabbrev-downcase nil))

;; flycheck
(use-package flycheck
  :ensure t
  :config
  (setq flycheck-check-syntax-automatically '(mode-enabled save)))

;; zoom
(use-package zoom
  :ensure t
  :config
  (zoom-mode t))

;; dired-sidebar
(use-package dired-sidebar
  :bind (("C-x C-n" . dired-sidebar-toggle-sidebar))
  :ensure t
  :commands (dired-sidebar-toggle-sidebar)
  :config
  (setq dired-sidebar-subtree-line-prefix " .")
  (cond
   ((eq system-type 'darwin)
    (if (display-graphic-p)
        (setq dired-sidebar-theme 'icons)
      (setq dired-sidebar-theme 'nerd))
    (setq dired-sidebar-face '(:family "Helvetica" :height 140)))
   ((eq system-type 'windows-nt)
    (setq dired-sidebar-theme 'nerd)
    (setq dired-sidebar-face '(:family "Lucida Sans Unicode" :height 110)))
   (:default
    (setq dired-sidebar-theme 'nerd)
    (setq dired-sidebar-face '(:family "Arial" :height 140))))

  (setq dired-sidebar-use-term-integration t)
  (setq dired-sidebar-use-custom-font t)

  (use-package all-the-icons-dired
    ;; M-x all-the-icons-install-fonts
    :ensure t
    :commands (all-the-icons-dired-mode)))

;; linum
;; https://www.emacswiki.org/emacs/LineNumbers
(use-package linum
  :config
  (add-hook 'prog-mode-hook 'linum-mode)
  (setq linum-format "%4d \u2502 "))


;;;;; Golang

;; go-mode
(use-package go-mode
  :ensure t
  :config
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook #'gofmt-before-save)
  (add-hook 'projectile-after-switch-project-hook #'go-set-project)
  (add-hook 'go-mode-hook (lambda ()
                            (subword-mode)
                            (local-set-key (kbd "C-c C-k") 'godoc-at-point))))

;; go-rename - requires gorename (go get -u golang.org/x/tools/cmd/gorename)
(use-package go-rename
;;  :load-path "vendor"
  :config
  (add-hook 'go-mode-hook (lambda ()
                            (local-set-key (kbd "C-c r") 'go-rename))))

;; go-guru - requires guru (go get -u golang.org/x/tools/cmd/guru)
(use-package go-guru)
;;  :load-path "vendor")

;; go-add-tags
(use-package go-add-tags
  :ensure t
  :config
  (with-eval-after-load 'go-mode
    (define-key go-mode-map (kbd "C-c t") #'go-add-tags)))

;; go-direx
(use-package go-direx
  :ensure t
  :config
  (define-key go-mode-map (kbd "C-c C-t") 'go-direx-switch-to-buffer))

;; go-eldoc
(use-package go-eldoc
  :ensure t
  :config
  (add-hook 'go-mode-hook 'go-eldoc-setup))

;; company-go - requires gocode (go get -u github.com/nsf/gocode)
(use-package company-go
  :ensure t
  :config
  (add-to-list 'company-backends 'company-go))

(use-package flycheck-gometalinter
  :ensure t
  :config
  (flycheck-gometalinter-setup)
  (setq flycheck-gometalinter-fast t)
  (setq flycheck-gometalinter-disable-linters '("gotype"))
  (add-hook 'go-mode-hook 'flycheck-mode))


;;;;; YAML

;; yaml-mode
;; https://github.com/yoshiki/yaml-mode
(use-package yaml-mode
  :mode
  (("\\.yml\\'" . yaml-mode)))


;;;;; Git

;; diff-hl
;; https://github.com/dgutov/diff-hl
(use-package diff-hl
  :after magit
  :config
  (global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))


(use-package gitattributes-mode)

(use-package gitconfig-mode)

(use-package gitignore-mode)

;; ghub
;; https://github.com/tarsius/ghub
(use-package ghub)

;; magit
;; https://magit.vc/
(use-package magit
  :after ivy
  :init
  (setq magit-completing-read-function 'ivy-completing-read)
  :config
  (global-magit-file-mode)
  :bind
  (("C-x g" . magit-status)
   ("C-x M-g" . magit-dispatch-popup)))

;; magit-gitflow
;; https://github.com/jtatarik/magit-gitflow
(use-package magit-gitflow
  :after magit
  :config
  (add-hook 'magit-mode-hook 'turn-on-magit-gitflow))

;; magithub
;; https://github.com/vermiculus/magithub
(use-package magithub
  :disabled
  :after (magit ghub)
  :config
  (magithub-feature-autoinject t))


;;;;; editorconfig

(use-package editorconfig
  :ensure t
  :config
  (editorconfig-mode 1))
  

;;;;; Generated Junk

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit ghub+ all-the-icons-dired nyan-mode use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
