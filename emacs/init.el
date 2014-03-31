(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (dolist (source '(("melpa" . "http://melpa.milkbox.net/packages/")
                    ("marmalade" . "http://marmalade-repo.org/packages/")))
  (add-to-list 'package-archives source)))

;; ensure packages are installed
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(starter-kit
                      starter-kit-lisp
                      starter-kit-bindings
                      starter-kit-js
                      starter-kit-ruby
                      clojure-mode
                      coffee-mode
                      color-theme-solarized
                      gist
                      rainbow-delimiters
                      nrepl
                      android-mode
                      auto-complete
                      yasnippet)
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
        (package-install p)))

;; global settings
(global-whitespace-mode t)

(setq whitespace-action '(auto-cleanup)
      whitespace-line-column 80
      whitespace-style '(face tabs trailing lines-tail))

(load-theme 'solarized-dark t)

(defun disable-auto-wrap ()
  (auto-fill-mode -1))

;; ido-mode
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; prog-mode settings
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; html-mode settings
(add-hook 'html-mode-hook 'disable-auto-wrap)

;; ruby-mode settings
(setq auto-mode-alist (cons '("\\.rake\\'" . ruby-mode) auto-mode-alist))
(setq ruby-deep-indent-paren nil)

;; coffee-mode settings
(setq coffee-tab-width 2)
(add-hook 'coffee-mode-hook 'enable-more-columns)

;; android-mode settings
(setq android-mode-sdk-dir "/usr/local/opt/android-sdk")

;;yasnippet
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"
        "~/.emacs.d/elpa/yasnippet-20130112.1823/snippets"))
(yas-global-mode 1)

;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20130209/dict")

(setq-default ac-sources
             '(ac-source-abbrev
               ac-source-dictionary
               ac-source-yasnippet
               ac-source-words-in-buffer
               ac-source-words-in-same-mode-buffers
               ac-source-semantic))

(ac-config-default)

(dolist (m '(c-mode c++-mode java-mode))
  (add-to-list 'ac-modes m))

(global-auto-complete-mode t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("3c708b84612872e720796ea1b069cf3c8b3e909a2e1da04131f40e307605b7f9" default)))
 '(safe-local-variable-values (quote ((encoding . utf-8) (whitespace-line-column . 80) (lexical-binding . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Silently ensure newline at end of file
(setq require-final-newline t)
