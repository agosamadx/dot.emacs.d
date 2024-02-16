;;(setq debug-on-error t)

;;; package.el
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(require 'use-package)

;; install packages
(defvar package-list '(company undo-tree yasnippet ddskk lsp-mode lsp-ui flycheck cmake-mode csharp-mode))
(unless package-archive-contents (package-refresh-contents))
(dolist (pkg package-list)
  (unless (package-installed-p pkg)
    (package-install pkg)))

;;; setting
(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq completion-ignore-case t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq kill-whole-line t)
(setq visible-bell t)
(setq ring-bell-function 'ignore)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default truncate-lines t)
(custom-set-variables '(custom-file (expand-file-name "custom.el" user-emacs-directory)))

;;; func
(load-file (locate-user-emacs-file "func.el"))

;;; for mac
(when (memq window-system '(mac ns))
  (load-file (locate-user-emacs-file "mac.el")))

;;; for windows
(when window-system '(windows-nt)
      (load-file (locate-user-emacs-file "windows.el")))

;;; frame
(defvar frame-parameters
  '((width . 180)
    (height . 50)
    (top . 64)
    (left . 192)
    (tool-bar-lines . nil)))

(when (memq window-system '(x w32 mac ns))
  (set-scroll-bar-mode nil)
  (setq frame-title-format '(multiple-frames "%b" ("" invocation-name)))
  (setq default-frame-alist frame-parameters))

;;; paren-mode
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'mixed)

(global-set-key "\C-h" 'backward-delete-char)
(global-set-key "\C-ce" 'eshell)
(global-set-key "\C-x\C-b" 'electric-buffer-list)
(global-set-key "\C-a" 'beggining-of-indented-line)
(global-set-key "\C-k" 'kill-line)
(global-set-key "\M-k" (lambda () (interactive) (kill-line 0)))
(add-hook 'electric-buffer-menu-mode-hook
          (lambda()
            (local-set-key "x" 'Buffer-menu-execute)))

;;; white space
(use-package whitespace
  :config
  (progn
    (setq whitespace-style
          '(face
            trailing
            tabs
            space-mark
            tab-mark
            empty))
    (set-face-attribute
     'whitespace-tab nil
     :background nil
     :foreground nil
     :underline nil)
    (set-face-attribute
     'whitespace-empty nil
     :background nil)
    (setq whitespace-display-mappings
          '((tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))
    (setq whitespace-action
          '(auto-cleanup))
    (add-hook 'c++-mode-hook 'whitespace-mode)))

;;; company
(use-package company
  :config
  (progn
    (add-hook 'after-init-hook 'global-company-mode)
    (setq company-minimum-prefix-length 2)
    (setq company-selection-wrap-around t)
    (setq completion-ignore-case t)
    (define-key company-active-map (kbd "TAB") 'nil)
    (define-key company-active-map (kbd "C-m") 'company-complete-selection)
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)
    (define-key company-active-map (kbd "C-h") nil)
    (define-key company-active-map (kbd "M-n") nil)
    (define-key company-active-map (kbd "M-p") nil)
    (define-key company-search-map (kbd "C-n") 'company-select-next)
    (define-key company-search-map (kbd "C-p") 'company-select-previous)
    (define-key company-search-map (kbd "M-n") nil)
    (define-key company-search-map (kbd "M-p") nil)))

;;; lsp
(use-package lsp-mode
  :config
  (progn
    (setq lsp-prefer-capf t)
    (setq lsp-enable-indentation nil)
    (setq lsp-enable-on-type-formatting nil)))

;;; redo-tree
(use-package undo-tree
  :bind
  (("C-/" . 'undo-tree-undo)
   ("C-M-/" . 'undo-tree-redo))
  :config
  (progn
    (global-undo-tree-mode)
    (setq undo-tree-auto-save-history nil)))

(use-package cmake-mode
  :config
  (progn
    (setq auto-mode-alist
          (append
           '(("CMakeLists\\.txt$" . cmake-mode)
             ("\\.cmake$" . cmake-mode))
           auto-mode-alist))))

;; yasnippet
(use-package yasnippet
  :config
  (progn
    (yas-global-mode)))

;;; ddskk
(use-package skk
  :commands
  (skk skk-study)
  :config
  (progn
    (setq default-input-method "japanese-skk")
    (add-hook 'isearch-mode-hook 'skk-isearch-mode-setup)
    (add-hook 'isearch-mode-end-hook 'skk-isearch-mode-cleanup)
    (setq skk-isearch-start-mode 'latin)))

;;; c-mode
(add-hook 'c-mode-common-hook
          (lambda()
            (setq c-default-style "stroustrup")
            (setq c-basic-offset 4)
            (setq tab-width 4)
            (setq indent-tabs-mode nil)
            (local-set-key "\C-h" 'hungry-backspace)
            (local-set-key "\C-d" 'hungry-delete)
            (local-set-key "\C-f" 'hungry-forward-char)
            (local-set-key "\C-b" 'hungry-backward-char)))

;;; c++-mode
(setq auto-mode-alist
      (append
       '(("\\.h$" . c++-mode)
         ("\\.hpp$" . c++-mode))
       auto-mode-alist))
(add-hook 'c++-mode-hook
          (lambda()
            (c-set-offset 'innamespace 0)
            (c-set-offset 'inlambda 0)
            (c-set-offset 'arglist-intro '+)
            (c-set-offset 'arglist-close 0)
            (c-set-offset 'arglist-cont-nonempty 0)))
(add-hook 'c++-mode-hook 'company-mode)
(add-hook 'c++-mode-hook 'flycheck-mode)
(add-hook 'c++-mode-hook #'lsp)

;;; csharp-mode
(add-hook 'csharp-mode-hook #'lsp)
