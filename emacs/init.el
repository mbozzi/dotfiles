;;; -*- lexical-binding: t -*-
;;; .emacs --- Max  Bozzi's GNU Emacs init file.
;;;
;;; Copyright (C) 2013-2015 Max Bozzi
;;; Version 2.2
;;;
;;; This program is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.
;;;
;;; This program is distributed in the hope that it will be useful, but WITHOUT
;;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
;;; FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
;;; more details.
;;;
;;; You should have received a copy of the GNU General Public License along with
;;; this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;;
;;; This is my init file.  If you want to get it to work, you best ask me to
;;; find you a list of all the packages you need to install.  You can contact me
;;; at mjb@mbozzi.com, and I will be happy to help.
;;;
;;; My computer's interface has been modified quite heavily, and this setup
;;; reflects this.  Since I use a older laptop whose keyboard configuration is
;;; not suitable for programming, I've had to make adjustments.
;;;
;;; Specifically, I have moved the Caps-Lock key, replacing it with another
;;; control key.  I have changed the "Menu" key (immediately right of Right-Alt)
;;; to an additional function key used as another modifier, physically moved the
;;; Tab key over a bit more, toggled the quick-key option in BIOS to get my
;;; function keys back, and replaced the "windows key" (immediately left of
;;; Left-Alt) with a Super key.  I have switched each top-row number key (I
;;; don't have a numeric keypad) with each corresponding symbol, so that I don't
;;; type the Shift key to get !@#$%^&*(). The same has been done for
;;; the brace and bracket keys ({} and []).
;;;
;;; I do not use Emacs from the terminal.  If you try to use this configuration
;;; from the terminal, you'll regret it.  I type on a U.S. QWERTY keyboard and I
;;; do touch type prose.  I am less marginally less-effective touch-typing
;;; C-style code.
;;;
;;; Most of the default bindings are intact.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Code:

;;; This is Emacs.  I don't want raster UI.  Get rid of it so I don't see it at
;;; all.
(menu-bar-mode        -1)
(tool-bar-mode        -1)
(scroll-bar-mode      -1)
(transient-mark-mode nil)
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
(setq package-list '(cl package key-chord ace-jump-mode
                        helm iy-go-to-char iedit org
                        pretty-lambdada slime yasnippet flycheck tramp
                        solarized))
(setq package-archives  '(("melpa" . "http://melpa.milkbox.net/packages/")
                          ("gnu"   . "http://elpa.gnu.org/packages/")
                          ("elpa" . "http://tromey.com/elpa/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(package-initialize)

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

;;; (add-to-list 'default-frame-alist '(fullscreen   . maximized))
;;; (add-to-list 'default-frame-alist '(alpha        . 74))
(add-to-list 'default-frame-alist '(font         . "clean"))
(add-to-list 'default-frame-alist '(fringe-style . '(2 . 2)))
(set-fringe-style '(2 . 2))

(defun switch-theme-exclusive (theme)
  (interactive)
  (mapc (lambda (theme)
          (disable-theme theme))
        custom-enabled-themes)
  (load-theme theme t))

(add-to-list 'custom-theme-load-path
             (expand-file-name "~/.emacs.d/themes"))
(load-theme 'solarized-dark)

(setq-default fill-column 80)

(defmacro alambda (args &rest body)
  "Anaphoric lambda binding `self' to itself for recursion."
  `(labels ((self ,args ,@body))
     #'self))

(defmacro aif (condition do-if-true &rest do-if-false)
  "If statement binding the anaphor `if' to the result of
CONDITION."
  `(let ((it ,condition))
     (if it ,do-if-true ,@do-if-false)))

(defun flatten (list)
  "Return a list of all the leaves of LIST as a tree."
  (funcall (alambda (l acc)
             (cond ((null l) ())
                   ((atom l) (cons l acc))
                   (t        (nconc (self (car l) acc)
                                    (self (cdr l) acc)))))
           list nil))

(defun allp (&rest args)
  (block 'exit-early
    (reduce (lambda (a b)
              (if (and a b) t
                (return-from 'exit-early)))
            args)))

(defun nonep (&rest args)
  (block 'exit-early
    (apply 'allp
           (mapcar (lambda (a) (if a (return-from 'exit-early) t))
                   args))))

(require 'key-chord)
(key-chord-mode t)

(defun bind (key command &optional hook)
  "Bind KEY to COMMAND, optionally via HOOK.

 COMMAND is any command -- i.e., any function for which
`commandp' returns true.  KEY is a string representation of a
key, i.e., as the argument to `kbd'.

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
  "Define a function with NAME, ARGS, BODY, with BIND-SPECS.

defbind is similar to defun in that it defines a function named
NAME, with a lambda-list specified by ARGS, performing the actions
defined in BODY.

The difference is that the defined function must be a
command (i.e., it must have an `interactive' specifier), and it
is immediately bound to key-maps according to BIND-SPECS.

BIND-SPECS takes the form \(\(make-list-of-keys\)
\(make-list-of-hooks\)\), where the expression make-list-of-keys
evaluates to a list of keys to which the command will be bound,
and the expression make-list-of-hooks evaluates to a list of
hooks to which the command will be attached, or nil.  If
make-list-of-hooks evaluates to nil, then the key will be bound
globally.

An example invocation is shown below.  The following will bind a
new function named `lisp-end-of-list' to the keychord C-M-\; in
all the modes whose hooks are contained in the variable
`lisp-mode-common-hooks' .

\(defbind lisp-end-of-list nil \('\(\"C-M-\;\"\)
                                lisp-mode-common-hooks\)
  \"Move point to the end of the current s-expression.\"
  \(interactive\)
  \(backward-up-list\)
  \(forward-sexp\)
  \(backward-char\)\)"
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
                     "~/prj/dotfiles/emacs/start-up-quotes.el")))
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
                 (dotimes (i (random (1- number-forms))
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

(require 'dired)
(require 'wdired)

(setq dired-listing-switches "-alDhB")

(defbind dired-go-to-home-directory ()
  ('("~") '(dired-mode-hook wdired-mode-hook))
  "Immediately open a dired buffer in the home directory."
  (interactive)
  (dired (getenv "HOME")))
(defbind dired-beginning-of-buffer ()
  ('("M-<") '(dired-mode-hook wdired-mode-hook))
  "Put the cursor on the first line of the file list."
  (interactive)
  (beginning-of-buffer)
  (dired-next-line 2))
(defbind dired-end-of-buffer ()
  ('("M->") '(dired-mode-hook wdired-mode-hook))
  "Put the cursor on the last line of the file list."
  (interactive)
  (end-of-buffer)
  (dired-previous-line 1))

(defbind c-new-line () ('("<C-M-return>") '(c++-mode-hook c-mode-hook))
  "Add a semi-colon and newline at the end of the line."
  (interactive)
  (end-of-line) (insert ";") (newline) (indent-for-tab-command))

;;; Thanks someone else for this code.
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

(defbind down-and-end-of-list nil ('("s-d") lisp-mode-common-hooks)
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



(setq tags-revert-without-query t)

;; (defbind dired-jump-to-bottom () ('("M->")
;;                                   '(dired-mode-hook))
;; (interactive)
;; (end-of-buffer)
;; (dired-next-line -1))

(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

(require 'ace-jump-mode)
(ace-jump-mode-enable-mark-sync)

(require 'helm-config)
(helm-mode 1)

(bind "M-x" 'helm-M-x)
(bind "C-x C-f" 'helm-find-files)

(bind "M-y"       'yank-pop)
(bind "C-x C-f"   'helm-find-files)
(bind "C-c <SPC>" 'helm-all-mark-rings)
(bind "C-x r b"   'helm-filtered-bookmarks)
(bind "C-h r"     'helm-info-emacs)
(bind "C-:"       'helm-eval-expression-with-eldoc)
(bind "C-h i"     'helm-info-at-point)
(bind "<f9>"      'helm-register)
(bind "C-x C-d"   'helm-browse-project)
(bind "<f1>"      'helm-resume)
(bind "C-h C-f"   'helm-apropos)
(bind "C-h a"     'helm-apropos)
(bind "<f2>"      'helm-execute-kmacro)
(bind "C-c i"     'helm-imenu-in-all-buffers)
(bind "C-s"       'helm-occur)
(bind "C-*"       'dabbrev-expand)
(bind "s-k"       'bury-buffer)
(bind "C-x C-b"   'helm-buffers-list)

(require 'iy-go-to-char)
(require 'iedit)

(bind "C-,"      'other-window)
(bind "C-x g"    'magit-status)
(bind "jf"       'ace-jump-mode)
(bind "C-'"      'ff-find-other-file) (setq-default ff-always-in-other-window t)
(bind "C-x C-d"  'dired)
(bind "<f5>"     'compile)
;;; Change the default compile command to look in the parent directory.
(setq compile-command "pushd .. && make -kj2 ")

(bind "s-p"     'pop-to-mark-command)
(bind "s-C-p"   'push-mark-command)

(bind "<f14> g" 'magit-status)
(bind "<f14> l" 'magit-log)

(require 'wdired)
(require 'dired)
(bind "C-c C-w" 'wdired-change-to-wdired-mode 'dired-mode-hook)
(bind "C-s"     'dired-isearch-filenames-regexp 'dired-mode-hook)

(mapc (lambda (hook)
        (add-hook hook #'enable-paredit-mode))
      lisp-mode-common-hooks)

(require 'org)
(add-hook 'org-mode-hook
          (lambda nil (local-unset-key (kbd "C-,"))))
;;; Don't scale headings.
(custom-set-faces
  '(org-level-1 ((t (:inherit outline-1 :height 1.0))))
  '(org-level-2 ((t (:inherit outline-2 :height 1.0))))
  '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
  '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
  '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

(add-hook 'dired-mode-hook  (lambda nil (auto-revert-mode 1)))
(add-hook 'wdired-mode-hook (lambda nil (auto-revert-mode 1)))

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

(setq iy-go-to-char-continue-when-repeating nil)
(defbind fast-fix-typo (char) ('("M-/"))
  (interactive "cGo back to char: ")
  (iy-go-to-char-backward 1 char)
  (forward-char))

(defbind make-line-below-and-go-to-it (times) ('("C-M-o"))
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

(defbind upcase-last-sexp (times) ('("s-u"))
  (interactive "p")
  (save-excursion
    (let ((place (point)))
      (backward-sexp (if times times 0))
      (upcase-region (point) place))))

(defun align-numbers (beg end)
  (interactive "r")
  (let (indent-tabs-mode
        (align-rules-list
         '((temporary
            (regexp  . "\\( *[+-]?[0-9]*\\.\\)")
            (group   . 1)
            (justify . t)
            (repeat  . t)))))
    (align beg end)))

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
              (list (expand-file-name "~/prj/dotfiles/emacs/snippets/")))
(yas-global-mode nil)

(setq font-latex-fontify-sectioning 'color)
(add-hook 'LaTeX-mode-hook (lambda nil (auto-fill-mode)))

(require 'flycheck)

;;; This is largely copied from flycheck.el, because the path to the tool is
;;; hard-coded.
(flycheck-define-checker c/c++-avr-gcc
  "Check C/C++ using avr-gcc and the built-in code."
  :command ("avr-gcc" "-fshow-column"
            "-fno-diagnostics-show-caret"
            "-fno-diagnostics-show-option"
            "-Wp,-DF_CPU=16000000ul,-DARDUINO=10608,-DARDUINO_AVR_UNO,-DARDUINO_ARCH_AVR"
            "-mmcu=atmega328p"
            (option "-std=" flycheck-gcc-language-standard concat)
            (option-flag "-pedantic" flycheck-gcc-pedantic)
            (option-flag "-pedantic-errors" flycheck-gcc-pedantic-errors)
            (option-flag "-fno-exceptions" flycheck-gcc-no-exceptions)
            (option-flag "-fno-rtti" flycheck-gcc-no-rtti)
            (option-flag "-fopenmp" flycheck-gcc-openmp)
            (option-list "-include" flycheck-gcc-includes)
            (option-list "-W" flycheck-gcc-warnings concat)
            (option-list "-D" flycheck-gcc-definitions concat)
            (option-list "-I" flycheck-gcc-include-path)
            (eval flycheck-gcc-args)
            "-x" (eval
                  (pcase major-mode
                    (`c++-mode "c++")
                    (`c-mode "c")))
            ;; GCC performs full checking only when actually compiling, so
            ;; `-fsyntax-only' is not enough. Just let it generate assembly
            ;; code.
            "-S" "-o" null-device
            ;; Read from standard input
            "-")
  :standard-input t
  :error-patterns
  ((info line-start (or "<stdin>" (file-name)) ":" line ":" column
         ": note: " (message) line-end)
   (warning line-start (or "<stdin>" (file-name)) ":" line ":" column
            ": warning: " (message) line-end)
   (error line-start (or "<stdin>" (file-name)) ":" line ":" column
          ": " (or "fatal error" "error") ": " (message) line-end))
  :modes (c-mode c++-mode)
  :next-checkers ((warning . c/c++-cppcheck)))
(add-to-list 'flycheck-checkers 'c/c++-avr-gcc)

(add-hook 'c-mode-common-hook #'flycheck-mode)

(put 'flycheck-gcc-args 'safe-local-variable (lambda (&rest args) t))

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

(defvar preserve-tabs-major-modes
  '(makefile-mode makefile-gmake-mode m4-mode))
(defun cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Doesn't indent the buffer, because it is used for a
before-save-hook, and that might be bad.

Also, do not delete the tabs if the buffer's major mode is set to
one of the modes specified in the variable
`preserve-tabs-major-modes'"
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

(require 'tramp)
(require 'tramp-sh)
(defconst my-tramp-prompt-regexp
   (concat (regexp-opt '("Passcode or option (1-3): ") t)
           "\\s-*")
   "Regular expression matching my login prompt question.")

(defun my-tramp-action (proc vec)
  "Enter 1 to get duo authentication."
  (save-window-excursion
    (with-current-buffer (tramp-get-connection-buffer vec)
      (tramp-message vec 6 "\n%s" (buffer-string))
      (tramp-send-string vec "1"))))

(defvar tramp-actions-before-shell)
 (add-to-list 'tramp-actions-before-shell
              '(my-tramp-prompt-regexp my-tramp-action))

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

(defun c-macroify-string (str)
  (if str (replace-regexp-in-string
           "^\\(_*[0-9]*\\)*" ""
           (upcase (replace-regexp-in-string
                    "[^A-Z0-9_]" "_" str))) ""))

(defun project-name-or-guess ()
  (if (and (boundp 'project-name) (stringp project-name))
      project-name
    (file-name-base
     (replace-regexp-in-string ".*/\\(.+?\\)/?\\.?$" "\\1"
                               (expand-file-name
                                (concat default-directory "../"))))))

;;; Beaufort
(setq calendar-latitude   32.4316)
(setq calendar-longitude -80.6698)

(defun sunrise-sunset-time-today nil
  (require 'solar)
  (require 'calendar)
  (let* ((local-sunrise-sunset (solar-sunrise-sunset (calendar-current-date)))
         (sunrise-time         (apply 'solar-time-string
                                      (car local-sunrise-sunset)))
         (sunset-time          (apply 'solar-time-string
                                      (cadr local-sunrise-sunset))))
    (list sunrise-time sunset-time)))

(defun do-at-sunrise (function &rest args)
  (let ((sunrise-time (car (sunrise-sunset-time-today))))
    (run-at-time sunrise-time nil function args)))

(defun do-at-sunset (function &rest args)
  (let ((sunset-time (cadr (sunrise-sunset-time-today))))
    (run-at-time sunset-time nil function args)))

(defun do-every-sunrise (function &rest args)
  (run-at-time nil (* 60 60 24) 'do-at-sunrise function args))

(defun do-every-sunset (function &rest args)
  (run-at-time nil (* 60 60 24) 'do-at-sunset function args))

;;;  This is a bit broken at the moment.
;; (do-every-sunrise
;;  (lambda (&rest ignored)
;;    (message "switching to light theme on sunrise timer.")
;;    (switch-theme-exclusive 'solarized-light)))
;; (do-every-sunset
;;  (lambda (&rest ignored)
;;    (message "switching to dark theme on sunset timer.")
;;    (switch-theme-exclusive 'solarized-dark)))

(defun down-list-or-next (arg)
  (interactive "p")
  (condition-case ex
      (down-list arg)
    ('error
     (up-list) (down-list-or-next arg))))

(define-key global-map [remap down-list] 'down-list-or-next)

(provide '.emacs)
;;; .emacs ends here
