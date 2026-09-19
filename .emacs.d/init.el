;; -*- lexical-binding: t; -*-

(setq inhibit-startup-screen t)   ; 关闭启动画面
(tool-bar-mode -1)                ; 关闭工具栏
(scroll-bar-mode -1)              ; 关闭滚动条
(menu-bar-mode -1)                ; 关闭菜单栏（可选）
(setq make-backup-files nil)      ; 不生成 ~ 备份
(setq auto-save-default nil)      ; 不生成 #autosave#
(global-display-line-numbers-mode 1) ; 显示行号
(show-paren-mode 1)               ; 高亮匹配括号
(setq-default indent-tabs-mode nil) ; 用空格代替 Tab

(global-set-key (kbd "M-SPC") 'set-mark-command)
(global-unset-key (kbd "C-SPC"))

(set-face-attribute 'default nil :family "CaskaydiaCove NFM" :height 140)

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t) ; 自动安装 use-package 声明的包

(use-package gruvbox-theme
  :config (load-theme 'gruvbox-dark-medium t))

(use-package which-key
  :init (which-key-mode 1))

(use-package multiple-cursors
  :ensure t
  :bind (("C->"   . mc/mark-next-like-this)      ; 标记下一个相同项
         ("C-<"   . mc/mark-previous-like-this)  ; 标记上一个相同项
         ("C-c C-<" . mc/mark-all-like-this)     ; 标记所有相同项
         ("C-S-c C-S-c" . mc/edit-lines)))       ; 为选中区域的每一行创建一个光标

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(gruvbox-theme multiple-cursors)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
