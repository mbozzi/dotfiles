;;; heat-theme.el --- A theme based around the warm colors of the sun.

;;; Commentary:
;;; Author:  Max Bozzi <mjb@mbozzi.com>
;;; Version: 1.0.1

;;; License:


;;; Code:
(deftheme heat "The Heat color theme")

(let ((class '((class color)))
      (bg-0 "#000000")
      (bg-1 "#0A070E")
      (bg-2 "#130F0E")
      (bg-3 "#18202A")
      (md-0 "#844F55")
      (md-1 "#1C1209")
      (md-2 "#44290C")
      (md-3 "#BD7306")
      (md-4 "#DAA406")
      (fg-0 "#E0CD6F")
      (fg-1 "#E7D597")
      (fg-2 "#DFDFA0")
      (fg-3 "#E3D8BA")
      (ac-0 "#FD482F")
      (ac-1 "#FF0A0F")
      (ac-2 "#AF0A9F")
      (ac-3 "#1A95FF"))

  (custom-theme-set-faces
   'heat
   `(default                    ((,class (:foreground ,fg-3 :background ,bg-1))))
   `(compliation-error          ((,class (:foreground ,ac-1 :weight bold))))
   `(compilation-info           ((,class (:foreground ,md-3))))
   `(compilation-mode-line-run  ((,class (:foreground ,md-4 :background ,bg-1))))
   `(compilation-mode-line-exit ((,class (:foreground ,ac-3 :background ,bg-1))))
   `(compilation-mode-line-fail ((,class (:foreground ,ac-1 :background ,bg-1))))
   `(hl-line                    ((,class (:background ,bg-3))))
   `(mode-line                  ((,class (:foreground ,ac-0 :weight bold :background ,bg-3))))
   `(mode-line-inactive         ((,class (:foreground ,fg-3 :weight bold :background ,bg-3))))
   `(fringe                     ((,class (:foreground ,bg-3))))
   
   `(font-lock-builtin-face              ((,class (:foreground ,ac-0))))
   `(font-lock-comment-face              ((,class (:foreground ,md-0))))
   `(font-lock-constant-face             ((,class (:foreground ,fg-1))))
   `(font-lock-doc-face                  ((,class (:foreground ,ac-3))))
   `(font-lock-function-name-face        ((,class (:foreground ,fg-1))))
   `(font-lock-keyword-face              ((,class (:foreground ,ac-0 :weight bold))))
   `(font-lock-preprocessor-face         ((,class (:foreground ,fg-0 :weight bold))))
   `(font-lock-string-face               ((,class (:foreground ,md-3))))
   `(font-lock-type-face                 ((,class (:foreground ,md-4))))
   `(font-lock-variable-name-face        ((,class (:foreground ,fg-2))))
   `(font-lock-warning-face              ((,class (:foreground ,ac-0))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,md-2 :bold) t)))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,md-3 :bold t))))))

;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'heat)

;;; heat-theme.el ends here
