;;; 行頭とインデント末をトグル
(defun beggining-of-indented-line (point)
  (interactive "d")
  (if (string-match
       "^[ \t]+$"
       (save-excursion
         (buffer-substring-no-properties
          (progn (beginning-of-line) (point))
          point)))
      (beginning-of-line)
    (back-to-indentation)))

;;; 行頭のスペースをtab-width分ずつ消す
(defun hungry-backspace ()
  (interactive)
  (let* ((current (- (point) (line-beginning-position)))
         (div (% current tab-width))
         (nextperiod (min (+ (point) (- tab-width (if (= div 0) tab-width div))) (line-end-position))))
    (if (and (string-match "^\s+$" (buffer-substring-no-properties (line-beginning-position) nextperiod))
             (not (= (point) (line-beginning-position)))
             (= (% (- nextperiod (line-beginning-position)) tab-width) 0))
        (backward-delete-char (if (= (% current tab-width) 0) tab-width (% current tab-width)))
      (backward-delete-char 1))))

;;; スペースが続いている時はtab-widthずつ消す
(defun hungry-delete ()
  (interactive)
  (let* ((current (- (point) (line-beginning-position)))
         (step (- tab-width (% current tab-width)))
         (nextperiod (min (+ (point) step) (line-end-position))))
    (if (and (string-match "^\s+$" (buffer-substring-no-properties (line-beginning-position) nextperiod))
             (not (= (point) (line-end-position)))
             (= (% (- nextperiod (line-beginning-position)) tab-width) 0))
        (delete-char step)
      (delete-char 1))))

;;; スペースが続いている時はタブ幅ごとまとめて移動する
(defun hungry-forward-char ()
  (interactive)
  (let* ((current (- (point) (line-beginning-position)))
         (nextperiod (min (+ (point) (- tab-width (% current tab-width))) (line-end-position))))
    (if (and (string-match "^\s+$" (buffer-substring-no-properties (line-beginning-position) nextperiod))
             (not (= (point) (line-end-position)))
             (= (% (- nextperiod (line-beginning-position)) tab-width) 0))
        (forward-char (- tab-width (% current tab-width)))
      (forward-char 1))))

;;; スペースが続いている時はタブ幅ごとまとめて移動する
(defun hungry-backward-char ()
  (interactive)
  (let* ((current (- (point) (line-beginning-position)))
         (div (% current tab-width))
         (nextperiod (min (+ (point) (- tab-width (if (= div 0) tab-width div))) (line-end-position))))
    (if (and (string-match "^\s+$" (buffer-substring-no-properties (line-beginning-position) nextperiod))
             (not (= (point) (line-beginning-position)))
             (= (% (- nextperiod (line-beginning-position)) tab-width) 0))
        (backward-char (if (= (% current tab-width) 0) tab-width (% current tab-width)))
      (backward-char 1))))
