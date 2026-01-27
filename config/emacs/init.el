;;; init.el --- Professional Emacs setup for C/C++ Development -*- lexical-binding: t; -*-
;;; Author: Pawan Bhatta (xentixar)
;;; Description: Comprehensive C/C++ development environment with LSP, debugging, and modern tooling
;;; ----------------------------------------------------------------------

;; -----------------------
;; Performance Optimizations
;; -----------------------
(setq gc-cons-threshold (* 100 1024 1024))  ; 100MB
(setq read-process-output-max (* 1024 1024))  ; 1MB

;; -----------------------
;; UI & Startup Tweaks
;; -----------------------
(setq inhibit-startup-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(setq ring-bell-function 'ignore)
(setq make-backup-files nil)
(setq auto-save-default nil)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(global-hl-line-mode 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(set-frame-font "JetBrains Mono-13" nil t)

;; Better scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; UTF-8 encoding
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8
      coding-system-for-read 'utf-8
      coding-system-for-write 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; -----------------------
;; Package System Setup
;; -----------------------
(require 'package)
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Use-package bootstrap
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)
(setq use-package-verbose t)

;; -----------------------
;; Theme & Visuals
;; -----------------------
(use-package dracula-theme
  :config (load-theme 'dracula t))

(use-package nerd-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-height 25)
  (doom-modeline-bar-width 3)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-mode-icon t))

(use-package which-key
  :defer 0
  :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.3))

;; -----------------------
;; Vertico & Completion Framework
;; -----------------------
(use-package vertico
  :init
  (vertico-mode)
  :custom
  (vertico-cycle t)
  (vertico-count 20))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init
  (marginalia-mode))

(use-package consult
  :bind (("C-x b" . consult-buffer)
         ("C-x 4 b" . consult-buffer-other-window)
         ("C-x 5 b" . consult-buffer-other-frame)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g i" . consult-imenu)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s r" . consult-ripgrep)))

;; -----------------------
;; C/C++ Development Setup
;; -----------------------
(use-package lsp-mode
  :hook ((c-mode . lsp)
         (c++-mode . lsp)
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")
  :custom
  ;; Performance tweaks
  (lsp-idle-delay 0.5)
  (lsp-log-io nil)
  (lsp-completion-provider :none)  ; Use company-capf
  (lsp-headerline-breadcrumb-enable t)
  (lsp-enable-symbol-highlighting t)
  (lsp-signature-auto-activate t)
  (lsp-signature-render-documentation t)
  (lsp-prefer-flymake nil)
  (lsp-enable-on-type-formatting nil)
  (lsp-enable-indentation nil)
  (lsp-enable-snippet t)
  ;; clangd specific
  (lsp-clients-clangd-args '("--background-index"
                             "--clang-tidy"
                             "--completion-style=detailed"
                             "--header-insertion=iwyu"
                             "--header-insertion-decorators"))
  :config
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection "clangd")
                    :major-modes '(c-mode c++-mode)
                    :remote? t
                    :server-id 'clangd-remote)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-show-with-cursor t)
  (lsp-ui-doc-show-with-mouse t)
  (lsp-ui-doc-position 'top)
  (lsp-ui-doc-delay 0.5)
  (lsp-ui-sideline-enable t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-update-mode 'line)
  (lsp-ui-peek-enable t)
  (lsp-ui-peek-always-show t)
  :bind (:map lsp-ui-mode-map
              ("C-c d" . lsp-ui-doc-show)
              ("C-c h" . lsp-ui-doc-hide)
              ("C-c f" . lsp-ui-doc-focus-frame)
              ("M-." . lsp-ui-peek-find-definitions)
              ("M-?" . lsp-ui-peek-find-references)))

(use-package company
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.1)
  (company-tooltip-align-annotations t)
  (company-tooltip-limit 20)
  (company-show-numbers t)
  (company-selection-wrap-around t)
  (company-dabbrev-downcase nil)
  :bind (:map company-active-map
              ("C-n" . company-select-next)
              ("C-p" . company-select-previous)
              ("M-<" . company-select-first)
              ("M->" . company-select-last)
              ("<tab>" . company-complete-selection)))

(use-package company-box
  :if (display-graphic-p)
  :hook (company-mode . company-box-mode))

(use-package flycheck
  :hook (prog-mode . flycheck-mode)
  :custom
  (flycheck-display-errors-delay 0.3)
  (flycheck-check-syntax-automatically '(save mode-enabled))
  (flycheck-highlighting-mode 'lines)
  :config
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

(use-package clang-format
  :custom
  (clang-format-style "llvm")  ; or "google", "chromium", "mozilla", "webkit"
  :config
  (defun pb/clang-format-on-save ()
    "Format buffer with clang-format on save."
    (when (and (derived-mode-p 'c-mode 'c++-mode)
               (locate-dominating-file "." ".clang-format"))
      (clang-format-buffer)))
  ;; Uncomment to enable auto-formatting on save
  ;; (add-hook 'before-save-hook 'pb/clang-format-on-save)
  :bind (("C-c C-f" . clang-format-buffer)
         ("C-c C-r" . clang-format-region)))

;; CMake support
(use-package cmake-mode
  :mode ("CMakeLists\\.txt\\'" "\\.cmake\\'"))

(use-package cmake-font-lock
  :after cmake-mode
  :config (cmake-font-lock-activate))

;; Modern C++ font-lock
(use-package modern-cpp-font-lock
  :hook (c++-mode . modern-c++-font-lock-mode))

;; Debugging with DAP
(use-package dap-mode
  :after lsp-mode
  :commands dap-debug
  :custom
  (dap-auto-configure-features '(sessions locals controls tooltip))
  :config
  (require 'dap-gdb-lldb)
  (dap-gdb-lldb-setup)
  (dap-register-debug-template "C++ Debug"
                               (list :type "gdb"
                                     :request "launch"
                                     :name "GDB::Run"
                                     :target nil
                                     :cwd nil))
  :bind (:map dap-mode-map
              ("<f7>" . dap-step-in)
              ("<f8>" . dap-next)
              ("<f9>" . dap-continue)))

;; C/C++ mode settings
(add-hook 'c-mode-common-hook
          (lambda ()
            (c-set-style "linux")
            (setq c-basic-offset 4)
            (setq indent-tabs-mode nil)))

;; Header/Source switching
(defun pb/switch-between-header-source ()
  "Switch between header and source file."
  (interactive)
  (let* ((file-name (buffer-file-name))
         (extension (file-name-extension file-name))
         (base-name (file-name-sans-extension file-name))
         (other-file
          (cond
           ((string-match-p "\\.h\\'" extension)
            (or (concat base-name ".cpp")
                (concat base-name ".c")
                (concat base-name ".cc")))
           ((string-match-p "\\.\\(cpp\\|c\\|cc\\)\\'" extension)
            (or (concat base-name ".h")
                (concat base-name ".hpp"))))))
    (if (and other-file (file-exists-p other-file))
        (find-file other-file)
      (message "Corresponding file not found"))))

(global-set-key (kbd "C-c o") 'pb/switch-between-header-source)

;; -----------------------
;; Project Management
;; -----------------------
(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-mode +1)
  (setq projectile-project-search-path '("~/Projects" "~/Work" "~/Code"))
  (setq projectile-completion-system 'default)
  (setq projectile-enable-caching t)
  (setq projectile-indexing-method 'alien)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :bind (:map projectile-mode-map
              ("C-c p f" . projectile-find-file)
              ("C-c p s" . projectile-switch-project)
              ("C-c p g" . projectile-grep)))

;; Treemacs for project navigation
(use-package treemacs
  :bind (:map global-map
              ("M-0"       . treemacs-select-window)
              ("C-x t 1"   . treemacs-delete-other-windows)
              ("C-x t t"   . treemacs)
              ("C-x t B"   . treemacs-bookmark)
              ("C-x t C-t" . treemacs-find-file)
              ("C-x t M-t" . treemacs-find-tag))
  :config
  (setq treemacs-width 30))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

;; -----------------------
;; GDB / Debugging
;; -----------------------
(setq gdb-many-windows t
      gdb-show-main t
      gdb-display-io-nopopup t)

;; -----------------------
;; Compilation & Build
;; -----------------------
(setq compilation-scroll-output t)
(setq compilation-window-height 15)

(defun pb/compile-and-run ()
  "Compile and run current C/C++ file."
  (interactive)
  (let* ((src (buffer-file-name))
         (exe (file-name-sans-extension src))
         (extension (file-name-extension src))
         (compiler (if (string= extension "cpp") "g++" "gcc"))
         (std (if (string= extension "cpp") "-std=c++17" "-std=c11"))
         (cmd (format "%s %s -O2 -Wall -Wextra -g %s -o %s && %s" 
                      compiler std src exe exe)))
    (compile cmd)))

(defun pb/compile-with-cmake ()
  "Build project using CMake."
  (interactive)
  (let ((build-dir (or (projectile-project-root) default-directory)))
    (compile (format "cd %s && cmake -B build && cmake --build build" build-dir))))

(defun pb/compile-with-make ()
  "Build project using Make."
  (interactive)
  (compile "make -k"))

(defun pb/compile-and-test ()
  "Build and run tests."
  (interactive)
  (compile "make test"))

(global-set-key (kbd "<f5>") 'pb/compile-and-run)
(global-set-key (kbd "<f6>") 'pb/compile-with-cmake)
(global-set-key (kbd "C-c m") 'pb/compile-with-make)
(global-set-key (kbd "C-c t") 'pb/compile-and-test)

;; -----------------------
;; Git Integration
;; -----------------------
(use-package magit
  :bind (("C-x g" . magit-status)
         ("C-c g" . magit-file-dispatch))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(use-package diff-hl
  :hook ((prog-mode . diff-hl-mode)
         (magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  (diff-hl-flydiff-mode))

;; -----------------------
;; Code Navigation & Editing
;; -----------------------
(use-package avy
  :bind (("C-:" . avy-goto-char)
         ("C-'" . avy-goto-char-2)
         ("M-g f" . avy-goto-line)
         ("M-g w" . avy-goto-word-1)))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package smartparens
  :hook (prog-mode . smartparens-mode)
  :config
  (require 'smartparens-config))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package hl-todo
  :hook (prog-mode . hl-todo-mode)
  :config
  (setq hl-todo-keyword-faces
        '(("TODO"   . "#FF0000")
          ("FIXME"  . "#FF0000")
          ("DEBUG"  . "#A020F0")
          ("NOTE"   . "#1E90FF")
          ("HACK"   . "#FF8C00")
          ("REVIEW" . "#FFD700"))))

(use-package comment-dwim-2
  :bind ("M-;" . comment-dwim-2))

;; -----------------------
;; Documentation
;; -----------------------
(use-package eldoc
  :ensure nil
  :diminish eldoc-mode
  :hook (prog-mode . eldoc-mode)
  :custom
  (eldoc-idle-delay 0.5))

;; -----------------------
;; Snippets
;; -----------------------
(use-package yasnippet
  :diminish yas-minor-mode
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

(use-package yasnippet-snippets
  :after yasnippet)

;; -----------------------
;; Multiple Cursors
;; -----------------------
(use-package multiple-cursors
  :bind (("C-S-c C-S-c" . mc/edit-lines)
         ("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

;; -----------------------
;; Better Help
;; -----------------------
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)
         ("C-c C-d" . helpful-at-point)))

;; -----------------------
;; Terminal Integration
;; -----------------------
(use-package vterm
  :commands vterm
  :bind ("C-c v" . vterm)
  :custom
  (vterm-max-scrollback 10000))

;; -----------------------
;; Custom Functions
;; -----------------------
(defun pb/insert-header-guard ()
  "Insert C/C++ header guard."
  (interactive)
  (when (member (file-name-extension (buffer-file-name)) '("h" "hpp"))
    (let* ((guard (upcase (replace-regexp-in-string
                           "[^a-zA-Z0-9]" "_"
                           (file-name-nondirectory (buffer-file-name))))))
      (goto-char (point-min))
      (insert (format "#ifndef %s\n#define %s\n\n" guard guard))
      (goto-char (point-max))
      (insert (format "\n#endif // %s\n" guard)))))

(defun pb/create-cpp-class ()
  "Create C++ class skeleton."
  (interactive)
  (let ((class-name (read-string "Class name: ")))
    (insert (format "class %s {\npublic:\n    %s();\n    ~%s();\n\nprivate:\n    \n};\n"
                    class-name class-name class-name))))

;; -----------------------
;; Window Management
;; -----------------------
(use-package ace-window
  :bind ("M-o" . ace-window)
  :custom
  (aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

;; Winner mode for window configuration undo/redo
(winner-mode 1)
(global-set-key (kbd "C-c <left>") 'winner-undo)
(global-set-key (kbd "C-c <right>") 'winner-redo)

;; -----------------------
;; Org Mode for Documentation
;; -----------------------
(use-package org
  :ensure nil
  :mode ("\\.org\\'" . org-mode)
  :custom
  (org-startup-indented t)
  (org-pretty-entities t)
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-image-actual-width '(300)))

;; -----------------------
;; Performance Monitoring (Optional)
;; -----------------------
(defun pb/display-startup-time ()
  "Display Emacs startup time."
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'pb/display-startup-time)

;; -----------------------
;; Final Touch
;; -----------------------
(setq-default cursor-type 'bar)

;; Restore GC threshold after init
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024))))  ; 20MB

(message "🚀 Professional C/C++ Emacs Development Environment Loaded Successfully!")

;;; ----------------------------------------------------------------------
;;; END OF FILE
;;; ----------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-show-quick-access t nil nil "Customized with use-package company")
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
