;; Set font
(set-frame-font "Source Code Pro 18" nil t)
;; Mark 80th column
(setq-default fill-column 80)
(set-face-attribute 'fill-column-indicator nil :foreground "grey25")
(global-display-fill-column-indicator-mode)
;; Disable backup and lock files (but not autosave)
(setq make-backup-files nil)
(setq create-lockfiles nil)
;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
;; Use relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)
;; Show active buffers as tabs
(global-tab-line-mode)
;; Don't open a bunch of dired buffers
(setq dired-kill-when-opening-new-dired-buffer t)
;; Disable tool and menu bars
(menu-bar-mode -1)
(tool-bar-mode -1)
;; I hope the Church of Emacs will forgive me for this
(defalias 'Ex 'dired)
;; Start term with bash
(defun TERM ()
  (interactive)
  (term "/bin/bash"))
;; Close window when killing buffer
(defalias 'Kill 'kill-buffer-and-window)
;; RSS
(defun RSS ()
  (interactive)
  (newsticker-start)
  (newsticker-treeview))
(setq newsticker-url-list '( ;; Example feed
  ("Trisquel" "https://trisquel.info/en/node/feed")
  ("Artix" "https://artixlinux.org/feed.php")
  ("Arch" "https://archlinux.org/feeds/news")
  ("Gentoo GLSA" "https://security.gentoo.org/glsa/feed.rss")
  ("Mint" "https://blog.linuxmint.com/?feed=rss2")))
;; HTML template
(defun html ()
  (interactive)
  (insert "<!DOCTYPE html>\n<html lang=\"en\">\n  <head>\n    <meta charset=\"UTF-8\">\n    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">\n    <title>Webpage</title>\n    <link rel=\"icon\" href=\"assets/images/favicon.png\">\n    <link href=\"style/main.css\" rel=\"stylesheet\">\n    <script src=\"scripts/main.js\" defer></script>\n  </head>\n  <body>\n    <header>\n    </header>\n\n    <main>\n    </main>\n\n    <footer>\n    </footer>\n\n    <script>\n      // Inline script\n    </script>\n  </body>\n</html>"))


;; ----------------------------- ;;
;; ------ Package sources ------ ;;
;; ----------------------------- ;;

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("elpa" . "https://elpa.gnu.org/packages/"))
(package-initialize)
;;(package-refresh-contents)


;; --------------------------- ;;
;; ------ Atom One Dark ------ ;;
;; --------------------------- ;;

(unless (package-installed-p 'atom-one-dark-theme)
  (package-install 'atom-one-dark-theme))

(load-theme 'atom-one-dark t)


;; -------------------------- ;;
;; ------ company-mode ------ ;;
;; -------------------------- ;;

(unless (package-installed-p 'company)
  (package-install 'company))

(add-hook 'after-init-hook 'global-company-mode)


;; ----------------------- ;;
;; ------ yasnippet ------ ;;
;; ----------------------- ;;

(unless (package-installed-p 'yasnippet)
  (package-install 'yasnippet))
(unless (package-installed-p 'yasnippet-snippets)
  (package-install 'yasnippet-snippets))

(require 'yasnippet)
(require 'yasnippet-snippets)
(yas-global-mode 1)


;; ---------------------- ;;
;; ------ Flycheck ------ ;;
;; ---------------------- ;;

(unless (package-installed-p 'flycheck)
  (package-install 'flycheck))

(global-flycheck-mode +1)


;; ------------------ ;;
;; ------ Evil ------ ;;
;; ------------------ ;;

(unless (package-installed-p 'evil)
  (package-install 'evil))

(require 'evil)
(evil-mode 1)
(evil-define-key 'normal dired-mode-map
  (kbd "D") 'dired-do-delete
  (kbd "H") 'dired-up-directory
  (kbd "L") 'dired-find-file
  (kbd "R") 'dired-do-rename
  (kbd "N") 'dired-create-directory
  (kbd "n") 'dired-create-empty-file)


;; ------------------------ ;;
;; ------ Treesitter ------ ;;
;; ------------------------ ;;
;; 1. Download grammars from: https://github.com/emacs-tree-sitter/tree-sitter-langs/releases
;; 2. Extract to $HOME/.emacs.d/tree-sitter
;; 3. Rename files to libtree-sitter-LANG.so (for f in *.so; do mv "$f" "libtree-sitter-$f"; done)

;; Get rid of libtree-sitter-gomod not found warnings
(setq treesit-load-name-override-list
      '((gomod "libtree-sitter-go" "tree_sitter_go")))
;; Modes to use treesitter in
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode))
(add-to-list 'auto-mode-alist '("\\.css\\'" . css-ts-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . html-ts-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js-ts-mode))
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cs\\'" . csharp-ts-mode))
;; Maximum syntax highlighting
(setq font-lock-support-mode 'tree-sitter-lock-mode)
(setq treesit-font-lock-level 4)


;; ----------------- ;;
;; ------ LSP ------ ;;
;; ----------------- ;;
;; Find servers here:
;; https://emacs-lsp.github.io/lsp-mode/page/languages/
;; Install globally or symlink to /usr/bin/

(unless (package-installed-p 'lsp-ui)
  (package-install 'lsp-ui))
(unless (package-installed-p 'lsp-mode)
  (package-install 'lsp-mode))

(require 'lsp-mode)
(add-hook 'prog-mode-hook 'lsp)
(defalias 'Fmt 'lsp-format-buffer)


;; ------------------------ ;;
;; ------ git-gutter ------ ;;
;; ------------------------ ;;

(unless (package-installed-p 'git-gutter)
  (package-install 'git-gutter))

(require 'git-gutter)
(global-git-gutter-mode +1)

(custom-set-variables
 '(git-gutter:added-sign "|")
 '(git-gutter:deleted-sign "|")
 '(git-gutter:modified-sign "|"))

(set-face-foreground 'git-gutter:modified "yellow")
(set-face-foreground 'git-gutter:added "green")
(set-face-foreground 'git-gutter:deleted "red")
