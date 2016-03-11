;;; -*- lexical-binding: t -*-
;;; .emacs --- Max  Bozzi's GNU Emacs init file.
;;;
;;; Copyright (C) 2013-2015 Max Bozzi
;;; Version 2.2
;;;
;;; This program is free software; you can redistribute it and/or
;;; modify it under the terms of the GNU General Public License as
;;; published by the Free Software Foundation, either version 3 of the
;;; License, or (at your option) any later version.
;;;
;;; This program is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;;; General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with this program.  If not, see
;;; <http://www.gnu.org/licenses/>.

;;; Commentary:
;;;
;;;  copy this file to the location of your Emacs initialization
;;; file.  When loaded, this file will prompt you to download (or
;;; attempt to download) all the referenced packages from Marmalade
;;; or ELPA, respectively.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Code:

;;; I don't understand what the point of the raster UI is at all.
;;; This should get rid of it so we don't see it at all.
(menu-bar-mode   -1)
(tool-bar-mode   -1)
(scroll-bar-mode -1)
(global-hl-line-mode)

(display-time)

(show-paren-mode  t)
(setq visible-bell t)
(electric-pair-mode 1)
(setq column-number-mode t)

(require 'cl)

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs.d/saves"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;; Enable MELPA and GNU/ELPA repositories.
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
             '("gnu"   . "http://elpa.gnu.org/packages/"))

(defvar lisp-mode-common-hooks '(lisp-mode-hook
                                 emacs-lisp-mode-hook
                                 lisp-interaction-mode-hook
                                 ielm-mode-hook
                                 slime-mode-hook))

(defvar customization-file-path
  (expand-file-name "~/.emacs.d/emacs-auto-customizations.el"))
(when (file-exists-p customization-file-path)
  (load customization-file-path))
(setq custom-file customization-file-path)

(add-to-list 'default-frame-alist '(fullscreen   . fullscreen))
(add-to-list 'default-frame-alist '(alpha        . 74))
(add-to-list 'default-frame-alist '(font         . "clean"))
(add-to-list 'default-frame-alist '(fringe-style . '(2 . 2)))
(set-fringe-style '(2 . 2))

(add-to-list 'custom-theme-load-path
             (expand-file-name "~/.emacs.d/themes"))
(load-theme 'heat)

(setq-default fill-column 72)
(auto-fill-mode)

(defmacro alambda (args &rest body)
  "Anaphoric lambda binding `self' to itself for recursion."
  `(labels ((self ,args ,@body))
     #'self))

(defun flatten (list)
  "Return a list of all the leaves of LIST as a tree."
  (funcall (alambda (l acc)
             (cond ((null l) ())
                   ((atom l) (cons l acc))
                   (t        (nconc (self (car l) acc)
                                    (self (cdr l) acc)))))
           list nil))

(require 'key-chord)
(key-chord-mode t)

(defun bind (key command &optional hook)
  "Bind KEY to COMMAND, optionally via HOOK.

 COMMAND is any command -- i.e., any function for which
`commandp' returns true.  KEY is a string representation of a
key.

If HOOK is supplied, COMMAND will be bound to KEY locally when
HOOK is run."
  ;; KBD seems to be idempotent, which simplifies this job a bit.
  (condition-case nil
      (bind-normal key command hook)
    (error
     (bind-key-chord key command hook))))

(defun bind-normal (key command &optional hook)
  (if hook
      (add-hook hook
                (lambda nil (local-set-key (kbd key) command)))
    (global-set-key (kbd key) command)))

(defun bind-key-chord (key command &optional hook)
  (require 'key-chord)
  (if hook
      (add-hook hook (lambda nil
                       (key-chord-define-local key command)))
    (key-chord-define-global key command)))

(defmacro with-gensyms (symbols &rest body)
  "Execute BODY in a context where the variables in SYMBOLS are bound to
fresh gensyms."
  `(let ,(mapcar* #'list symbols '#1=((gensym) . #1#))
     ,@body))

(defmacro once-only (symbols &rest body)
  "Execute BODY in a context where the values bound to the variables in
SYMBOLS are bound to fresh gensyms, and the variables in SYMBOLS are bound
to the corresponding gensym."
  (let ((gensyms (mapcar (lambda (x) (gensym)) symbols)))
    `(with-gensyms ,gensyms
       (list 'let (mapcar* #'list (list ,@gensyms) (list ,@symbols))

             ,(list* 'let (mapcar* #'list symbols gensyms)
                     body)))))

(defmacro value-if (value predicate &optional alternative)
  "Return VALUE if PREDICATE, else return ALTERNATIVE.

If PREDICATE is t, return VALUE if VALUE is not nil.

VALUE is only evaluated once.  ALTERNATIVE (the `false' branch)
will not be evaluated unless it is required.  This allows for
`value-if' to be used in nullity testing, e.g.,

\(value-if \(foo bar #'fn\) t
  \(error \"add-hook returned nil\"\)\)

Which returns the value of \(foo bar #'fn\) if it was not nil,
otherwise, throws an error."
  (once-only (value predicate)
    `(if (eq ,predicate t)
         (if ,value ,value ,alternative)
       (if (funcall ,predicate ,value) ,value
         ,alternative))))

(defun listify (l)
  "If l is not a list, wrap it in one.  Else, return it."
  (value-if l #'listp (list l)))

(defmacro nested-dolist (vars lists &rest body)
  "Bind each symbol in VARS to each in LISTS, doing BODY."
  `(dolist ,(list (value-if
                      (car vars) t (gensym "dummy-iterator"))
                  (car lists))
     ,(if (null (cdr lists))
          `(progn ,@body)
        `(nested-dolist
             ,(cdr vars)
             ,(cdr lists)
           ,@body))))


(defmacro defbind (name args bind-specs &rest body)
  "Define a function with NAME, ARGS, BODY, with BIND-SPECS."
  `(progn
     (defun ,name ,args
       ,@(value-if body
                   (lambda (b) (member 'interactive (flatten b)))
                   (error "%s has no `interactive' specifier!" ',name)))
     (nested-dolist (key hook) (,(car bind-specs)
                                ,(value-if (cadr bind-specs) t
                                ''(())))
                    (bind key #',name hook))))

(define-key function-key-map    [tab] nil)
(define-key key-translation-map [9] [tab])
(define-key key-translation-map [tab] [9])

;; Start-up quotes
(let ((message-file (expand-file-name
                     "~/.emacs.d/start-up-quotes.txt")))
  (if (file-readable-p message-file)
      (let ((number-forms 0))
        (with-temp-buffer
          (insert-file-contents message-file)
          (ignore-errors
            (while (incf number-forms)
              (read (current-buffer)))))
        (with-temp-buffer
          (insert-file-contents message-file)
          (setq initial-scratch-message
                (concat
                 (dotimes (i (random number-forms)
                             (read (current-buffer)))
                   (read (current-buffer)))
                 "\n"))))
    (setq initial-scratch-message
          "You suck.  This is the default message.  Copy down some \
quotes, please!\n")))

(defun inside-comment-p nil (nth 4 (syntax-ppss)))
(defun inside-string-p nil (nth 3 (syntax-ppss)))
(defun smarter-newline (arg) (interactive "p")
       (if (inside-comment-p)
           (c-indent-new-comment-line)
         (newline arg)))

(setq inhibit-splash-screen t)

(defbind rename-current-buffer-file () ('("C-c C-r"))
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))

(defbind lisp-end-of-list nil ('("C-M-;") lisp-mode-common-hooks)
  "Move point to the end of the current s-expression."
  (interactive)
  (backward-up-list)
  (forward-sexp)
  (backward-char))

(defbind lisp-down-and-end-of-list nil ('("C-M-S-d") lisp-mode-common-hooks)
  "Move point forward, down and to the end of the current s-expression."
  (interactive)
  (down-list)
  (lisp-end-of-list))

(defbind lower-current-line (n-times) ('("<tab>"))
  "Lower the current line to the one N-TIMES below, adding whitespace."
  (interactive "p")
  (save-excursion
    (beginning-of-line)
    (newline n-times)))

(defbind raise-current-line (n-times) ('("M-i"))
  "Raise the current-line N-TIMES lines up, and indent."
  (interactive "p")
  (save-excursion
    (cl-loop repeat n-times do
             (delete-indentation)
             (indent-for-tab-command))))

(defbind raise-next-line (n-times) ('("M-o"))
  "Raise the next line to the one N-TIMES above, folding whitespace."
  (interactive "p")
  (save-excursion
    (cl-loop repeat n-times do
             (forward-line)
             (raise-current-line 1)
             (delete-trailing-whitespace
              (point)
              (line-end-position))))
  (indent-for-tab-command))

(defbind lower-next-line (n-times) ('("C-M-o"))
 "Lower the next line N-TIMES lines below, entering newlines."
 (interactive "p")
 (save-excursion
   (end-of-line)
   (open-line n-times)))

;; (defbind dired-jump-to-bottom () ('("M->")
;;                                   '(dired-mode-hook))
;; (interactive)
;; (end-of-buffer)
;; (dired-next-line -1))

(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(defbind kill-this-buffer () ('("s-k"))
  (interactive)
  (kill-buffer nil))

(require 'ace-jump-mode)
(ace-jump-mode-enable-mark-sync)

(require 'iy-go-to-char)
(require 'iedit)

(bind "C-,"     'other-window)
(bind "C-x g"   'magit-status 'prog-mode-hook)
(bind "jf"      'ace-jump-mode)
(bind "kd"      'iy-go-to-char)
(bind "kx"      'iy-go-to-char-backward)
(bind "C-'"     'ff-find-other-file) (setq-default ff-always-in-other-window t)
(bind "C-x C-d" 'dired)
(bind "<f5>"    'compile)
(bind "s-SPC"   'pop-to-mark-command)

(mapc (lambda (hook)
        (add-hook hook #'enable-paredit-mode))
      lisp-mode-common-hooks)

(require 'pretty-lambdada)
(pretty-lambda-for-modes)

(defbind remove-pair-or-electric-delete nil ('("DEL") '(c-mode-common-hook))
  "Remove both paired characters or just behave normally."
  (interactive)
  (cl-flet ((match-chars (pair-string)
                         (and (string-equal (string (preceding-char))
                                            (substring pair-string 0 1))
                              (string-equal (string (following-char))
                                            (substring pair-string 1 2)))))
    (if (or
         (match-chars "()")
         (match-chars "[]")
         (match-chars "<>")
         (match-chars "{}")
         (match-chars "\"\"")
         (match-chars "''"))
        (progn (delete-char -1) (delete-char 1))
      (progn (backward-delete-char-untabify 1)))))

(defbind make-line-below-and-go-to-it (times) ('("C-M-o") '(c++-mode-hook))
  (interactive "p")
  (lower-next-line times)
  (next-line times)
  (indent-for-tab-command))

(defbind insert-std::-c++ nil ('("C-M-;") '(c++-mode-hook))
  (interactive)
  (insert "std::"))


(defbind append-semicolon nil ('("C-c C-;") '(c++-mode-hook))
  (interactive)
  (save-excursion
    (end-of-line)
    (insert ";")))

(defbind switch-to-scratch-buffer nil ('("<f6>"))
  (interactive)
  (switch-to-buffer "*scratch*"))

(defbind upcase-last-sexp (times) ('("s-u"))
  (interactive "p")
  (save-excursion
    (let ((place (point)))
      (backward-sexp (if times times 0))
      (upcase-region (point) place))))

(require 'slime)
(defvar *my-common-lisp-interpreter* "/usr/bin/sbcl"
  "SLIME's default Lisp.")

(if (not (file-executable-p *my-common-lisp-interpreter*))
    (warn "Can't run %S." *my-common-lisp-interpreter*)
  (progn
    (require 'slime-autoloads)

    (defvar slime-contribs)
    (defvar slime-lisp-implementations)
    (defvar slime-default-lisp)

    (setq slime-contribs '(slime-fancy))
    (setq slime-lisp-implementations
          `((sbcl (,*my-common-lisp-interpreter*))))
    (setq slime-default-lisp 'sbcl)

    (defvar inferior-lisp-program)
    (setq inferior-lisp-program *my-common-lisp-interpreter*)

    (let ((quicklisp (expand-file-name "~/quicklisp/slime-helper.el")))
      (if (file-readable-p quicklisp)
          (load quicklisp)
        (message "Can't find QuickLisp at %S." quicklisp)))

    (mapcar* (lambda (key function)
               (bind key function 'slime-mode-hook))
             '("C-h f" "C-h M-f" "C-h v" "C-h M-v")
             '(slime-documentation describe-function slime-describe-symbol describe-variable))))

(require 'yasnippet)
(setq-default yas-snippet-dirs
              (list (expand-file-name "~/.emacs.d/snippets/")))
(yas-global-mode)

(setq font-latex-fontify-sectioning 'color)
(add-hook 'latex-mode-hook 'auto-fill-mode)

(require 'flycheck)
(add-hook 'c-mode-common-hook #'flycheck-mode)

(defvar flycheck-clang-language-standard)
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-clang-language-standard "c++14")))
(add-hook 'c-mode-hook
          (lambda () (setq flycheck-clang-language-standard "c11")))

(defvar flycheck-gcc-language-standard)
(add-hook 'c++-mode-hook
          (lambda () (setq flycheck-gcc-language-standard "c++14")))
(add-hook 'c-mode-hook
          (lambda () (setq flycheck-gcc-language-standard "c11")))

(defvar flycheck-disabled-checkers nil)
(setq-default flycheck-disabled-checkers '(c/c++-clang))
(add-to-list 'flycheck-disabled-checkers 'c/c++-clang)

(defvar preserve-tabs-major-modes '(makefile-mode makefile-gmake-mode))
(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Doesn't indent the buffer, because it is used for a
before-save-hook, and that might be bad."
  (interactive)
  (unless (member major-mode preserve-tabs-major-modes)
   (untabify (point-min) (point-max)))
  (delete-trailing-whitespace)
  (set-buffer-file-coding-system 'utf-8))
(add-hook 'before-save-hook 'cleanup-buffer)

(defun yas-expand-all-on-line nil
  "For each token on the line, try to expand it.
For modes which define keyword shortcuts, this will let us chain
abbreviations and then expand them all at once."
  (interactive)
  (save-excursion
    (end-of-line)
    (back-to-indentation)
    (while (<= (point) (line-end-position))
      (forward-word)
      (cl-flet ((yas--fallback 'ignore))
        (yas-expand-from-trigger-key)))))

(defadvice open-line (after indent)
  (save-excursion
    (next-line)
    (indent-for-tab-command))
  (indent-for-tab-command))
(ad-activate 'open-line t)

(defadvice delete-blank-lines (after indent)
  (indent-for-tab-command))
(ad-activate 'delete-blank-lines)

(setq disabled-command-hook nil)

;;  Missing C++ Keywords introduced in C++11:
(font-lock-add-keywords
 'c++-mode
 `((,(regexp-opt '("override" "final" "alignas" "alignof" "char16_t"
                   "char32_t" "concept" "constexpr" "decltype"
                   "noexcept" "nullptr" "static_assert"
                   "thread_local")
                 'words) . font-lock-keyword-face)))

(setq-default c-doc-comment-style 'javadoc)
(defalias 'yes-or-no-p 'y-or-n-p)

(put 'alambda 'lisp-indent-function 1)
(put 'value-if 'lisp-indent-function 1)
(put 'once-only 'lisp-indent-function 1)
(put 'with-gensyms 'lisp-indent-function 1)
(put 'nested-dolist 'lisp-indent-function 2)

(provide '.emacs)
;;; .emacs ends here
