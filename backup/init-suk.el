(add-to-list 'load-path "~/.emacs.d/site-lisp/suk")

(setq popup-terminal-command '("cmd.exe /k"))
;; 编码设置 begin
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; 23.2 之后废弃，用buffer-file-coding-system
(setq default-buffer-file-coding-system 'utf-8)
(setq buffer-file-coding-system 'utf-8)

;; for windows
(setq-default pathname-coding-system 'gb18030)
(set-language-environment 'Chinese-GB)
(setq file-name-coding-system 'gb18030)
;; 重要提示:写在最后一行的，实际上最优先使用; 最前面一行，反而放到最后
;; 才识别。utf-16le-with-signature 相当于 Windows 下的 Unicode 编码，
;; 这里也可写成utf-16 (utf-16 实际上还细分为 utf-16le, utf-16be,
;; utf-16le-with-signature等多种)
                                        ;(prefer-coding-system 'utf-16le-with-signature)
(prefer-coding-system 'utf-16)
(prefer-coding-system 'cp950)
(prefer-coding-system 'gb2312)
(prefer-coding-system 'cp936)
(prefer-coding-system 'gb18030)
;; 新建文件使用utf-8-unix方式
;; 如果不写下面两句，只写
;; (prefer-coding-system 'utf-8)
;; 这一句的话，新建文件以utf-8编码，行末结束符平台相关
(prefer-coding-system 'utf-8-dos)
(prefer-coding-system 'utf-8-unix)


(auto-compression-mode 1)
(setq default-major-mode 'text-mode)
(setq show-paren-style 'parentheses)
;; 当使用 M-x COMMAND 后，过 1 秒钟显示该 COMMAND 绑定的键。
(setq suggest-key-bindings 1)
;;只渲染当前屏幕语法高亮，加快显示速度
(setq font-lock-maximum-decoration t)
;; 书签文件的路径及文件名
(setq bookmark-default-file "d:/temp/emacs/.emacs.bmk")
;; 同步更新书签文件 ;; 或者退出时保存
(setq bookmark-save-flag 1)
;;C-x r m (name)  M-x bookmark-set  设置书签
;;C-x r b (name)  M-x bookmark-jump  跳转到书签
;;C-x r l         M-x bookmark-bmenu-list  书签列表
;;                M-x bookmark-delete  删除书l签
;;                M-x bookmark-load  读取存储书签文件
;;备份策略
(setq backup-directory-alist '(("" . "d:/temp/emacs/backup")))
(setq-default make-backup-file t)
(setq make-backup-file t)
(setq make-backup-files t)
(setq version-control t)
(setq kept-old-versions 2)
(setq kept-new-versions 10)
(setq delete-old-versions t)
;; 设置 sentence-end 可以识别中文标点。不用在 fill 时在句号后插 入两个
;; 空格。
(setq sentence-end
      "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
      )
(setq sentence-end-double-space nil)
(setq adaptive-fill-regexp
      "[ \t]+\\|[ \t]*\\([0-9]+\\.\\|\\*+\\)[ \t]*"
      )
(setq adaptive-fill-first-line-regexp "^\\* *$")

(require 'eval-after-load)


;; M-x global-set-key RET 交互式的绑定你的键。
;; C-x Esc Esc 调出上一条“复杂命令”
;; 设置绑定
(defun suk/set-key-bindings (action bindingList)
  ""
  (mapcar (lambda(lst)
            ""
            (let ((x (car lst))
                  (y (car (last lst))))
              (funcall action x y))) bindingList ))
;; 使用方式
;; (suk/set-key-bindings 'global-set-key
;;     (list
       ; '([f2]                            calendar)
       ; '([(shift f2)]                    remember)
       ; '([f5]                            revert-buffer)
       ; (list (kbd "C-c l")               'copy-line)
       ; ))

;; 另外一种解决乱码的办法，就是用命令 C-x <RET> r ( M-x
;; revert-buffer-with-coding-system) 来用指定的编码重新读入这个文件。

;; suk/revert-buffer-with-coding-system-no-confirm 调用之
(defun suk/revert-buffer-no-confirm ()
  "执行`revert-buffer'时不需要确认"
  (interactive)
  (when (buffer-file-name)
    (let (revert-buffer buffer-file-name t) )
    )
  )

;; suk/revert-buffer-with-gbk suk/revert-buffer-with-utf8 调用之
(defun suk/revert-buffer-with-coding-system-no-confirm (coding-system)
  "Call `revert-buffer-with-coding-system', but when `revert-buffer' do not need confirm."
  (interactive "Coding system for visited file (default nil): ")
  (let ((coding-system-for-read coding-system))
    (suk/revert-buffer-no-confirm)))

(defun suk/revert-buffer-with-gbk ()
  "Call `suk/revert-buffer-with-coding-system-no-confirm' with gbk."
  (interactive)
  (suk/revert-buffer-with-coding-system-no-confirm 'gbk))

(defun suk/revert-buffer-with-utf8 ()
  "Call `suk/revert-buffer-with-coding-system-no-confirm' with utf-8."
  (interactive)
  (suk/revert-buffer-with-coding-system-no-confirm 'utf-8))


;; Emacs可以做为一个server, 然后用emacsclient连接这个server,
;; 无需再打开两个Emacs
;;(server-force-delete)
;; (server-start)

;; eshell
(defun suk/eshell-settings ()
  "Settings for `eshell'."
  (defun eshell-mode-hook-settings ()
    "Settings for `term-mode-hook'"
    (make-local-variable 'scroll-margin)
    (setq scroll-margin 0))

  (add-hook 'eshell-mode-hook 'eshell-mode-hook-settings))


;; 简写模式
(setq-default abbrev-mode t)
(setq save-abbrevs nil)


;; table
;;(require 'table)
;;(add-hook 'text-mode-hook 'table-recognize)

;; 把文件或buffer彩色输出成html
(require 'htmlize)

;; 可以为重名的buffer在前面加上其父目录的名字来让buffer的名字区分开来，而不是单纯的加一个没有太多意义的序号
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; 方便的切换major mode
(defvar suk/switch-major-mode-last-mode nil)

(defun suk/major-mode-heuristic (symbol)
  (and (fboundp symbol)
       (string-match ".*-mode$" (symbol-name symbol))))

(defun suk/switch-major-mode (mode)
  "切换major mode"
  (interactive
   (let ((fn suk/switch-major-mode-last-mode) val)
     (setq val
           (completing-read
            (if fn (format "切换major-mode为(缺省为%s): " fn) "切换major mode为: ")
            obarray 'suk/major-mode-heuristic t nil nil (symbol-name fn)))
     (list (intern val))))
  (let ((last-mode major-mode))
    (funcall mode)
    (setq suk/switch-major-mode-last-mode last-mode)))


(defun suk/get-mode-name ()
  "显示`major-mode'及`mode-name'"
  (interactive)
  (message "major-mode为%s, mode-name为%s" major-mode mode-name))


(defun suk/count-brf-lines (&optional is-fun)
  "显示当前buffer或region或函数的行数和字符数"
  (interactive "P")
  (let (min max)
    (if is-fun
        (save-excursion
          (beginning-of-defun) (setq min (point))
          (end-of-defun) (setq max (point))
          (message "当前函数%s内共有%d行, %d个字符" (which-function) (count-lines min max) (- max min)))
      (if mark-active
          (progn
            (setq min (min (point) (mark)))
            (setq max (max (point) (mark))))
        (setq min (point-min))
        (setq max (point-max)))
      (if (or (= 1 (point-min)) mark-active)
          (if mark-active
              (message "当前region内共有%d行, %d个字符" (count-lines min max) (- max min))
            (message "当前buffer内共有%d行, %d个字符" (count-lines min max) (- max min)))
        (let ((nmin min) (nmax max))
          (save-excursion
            (save-restriction
              (widen)
              (setq min (point-min))
              (setq max (point-max))))
          (message "narrow下buffer内共有%d行, %d个字符, 非narrow下buffer内共有%d行, %d个字符"
                   (count-lines nmin nmax) (- nmax nmin) (count-lines min max) (- max min)))))))

(defun suk/switch-to-scratch ()
  "切换到*scratch*"
  (interactive)
  (let ((buffer (get-buffer-create "*scratch*")))
    (switch-to-buffer buffer)
    (unless (equal major-mode 'lisp-interaction-mode)
      (lisp-interaction-mode))))


(defun suk/point-to-register()
  "Store cursorposition _fast_ in a register.
Use ska-jump-to-register to jump back to the stored
position."
  (interactive)
  (setq zmacs-region-stays t)
  (point-to-register 8))

(defun suk/jump-to-register()
  "Switches between current cursorposition and position
that was stored with ska-point-to-register."
  (interactive)
  (setq zmacs-region-stays t)
  (let ((tmp (point-marker)))
    (jump-to-register 8)
    (set-register 8 tmp)))

(defun dos2unix2 (buffer)
  "Automate M-% C-q C-m RET C-q C-j RET"
  (interactive "*b")
  (save-excursion
    (goto-char (point-min))
    (while (search-forward (string ?\C-m) nil t)
      (replace-match (string ?\C-j) nil t))))

(defun dos2unix ()
  "dos2unix on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'unix))

(defun unix2dos ()
  "unix2dos on current buffer."
  (interactive)
  (set-buffer-file-coding-system 'dos))


(autoload 'session-initialize "session"
  "Initialize package session and read previous session file.
Setup hooks and load `session-save-file', see `session-initialize'.  At
best, this function is called at the end of the Emacs startup, i.e., add
this function to `after-init-hook'." t)

(add-hook 'after-init-hook 'session-initialize)
(defun suk/tramp-settings ()
  "Settings of `tramp'."
  (setq tramp-default-method "sudo")
  (add-to-list 'backup-directory-alist
               (cons tramp-file-name-regexp nil))
  )

(defun sudo-edit (&optional arg)
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
                         (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:"
                                 buffer-file-name))))

(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo::" (expand-file-name file-name))))
    (find-file tramp-file-name)))

(defun sudo-save ()
  (interactive)
  (if (not buffer-file-name)
      (write-file (concat "/sudo:root@localhost:" (ido-read-file-name "File:")))
    (write-file (concat "/sudo:root@localhost:" buffer-file-name))
    )
  )


;;emacs sudo编辑远端文件由 jay 发表于 on 六月 20日, 2011我在之前的一篇
;;文章里提到过在Emacs下使用sudo的方法。这个解决了我很多本地编辑的问题。
;;但是我还是抛不开vi，因为一直没有解决服务器上需要sudo才有权限的文件编
;;辑问题。现实中这是一个很普遍的现象，就是在服务器上关闭了root或者其他
;;用户的ssh登陆权限，是通过一般用户登陆以后通过sudo等方式获得权限后才能
;;进行进一步的文件编辑。而如果直接使用sudo，用比如
;;/sudo:user@host:filepath的方式来打开文件，Emacs会报错说这是一个远端文
;;件，不能使用sudo来进行操作。就因为这提示，导致我一直以来对于这样的情
;;况只能乖乖地开个shell跑到服务器上面去用vi编辑，编辑过程中的各种不爽在
;;此不表…… 不过当最终忍受不住这种只能用vi的寂寞后，终于下定决心看一下
;;tramp的手册，结果很好，发现了这么一章内容――Connecting to a remote
;;host using multiple hops，原来tramp是可以通过设置代理的方式来编辑那些
;;无法直接访问到的文件的。代理可以是各种Inline method，也可以是Gateway
;;method。所以通过ssh做跳板再sudo是完全可行的。设置的格式是(host user
;;proxy)，其中proxy可以使用%u和%h来通配输入的用户名和主机名。详细情况感
;;兴趣的童鞋可以细看手册，这儿就只贴出满足我的需求的代码了:

;;(add-to-list 'tramp-default-proxies-alist
;;             '(nil "\\`user\\'" "/ssh:%h:")
;;)
;;(add-to-list 'tramp-default-proxies-alist
;;'("machine2.abc.def.edu"
;;  nil
;;  "/ssh:myname@machine1.abc.def.edu:"))


;;经过这样的设置，就可以直接使用/sudo:user@host:filepath来编辑那些远端
;;需要sudo的文件了。所以，泡杯茶，扔掉vi吧 :)

;; inline methods

;; rsh
;; 用 rsh 和远程主机进行连接，由于安全的原因，只推荐用于本地传输。

;; ssh
;; 用 ssh 和远程主机进行连接。有两种变体 ssh1 和 ss2 可用，他们分别 对
;; 应着 'ssh -1' 和 'ssh -2'，你也可以使用 ssh1_old 或者 ssh2_old，对
;; 应 'ssh1' 和 'ssh2'。所有基于 ssh 的 inline method 都有一个特性就是：
;; 你可 以以 host#42 这种形式来指定主机，这将给 ssh 命令传递一个额外的
;; '-p 42' 参数用来指定端口。

;; telnet
;; 用 telnet 进行连接，同 rsh 一样，这也是不安全的。

;; su
;; 这种 inline method 并不连接到远程主机，他的作用是允许你以另一个用
;; 户的身份编辑一个本地文件。所以，在文件名里面指定的主机名将会被忽略。

;; sudo
;; 和 su 类似，但是使用 sudo 命令。

;; sshx
;; 这和 ssh 很类似，只有一点细微的差别：ssh 在远程机器上打开一个正 常
;; 的交互 shell ，而 sshx 使用 'ssh -t -t host -l user /bin/sh' 来打开
;; 连接。当正常登录的时候会被提一些问题的时候，这就会很有用了，这种方
;; 法会避开那些提问。需要注意的是这种方法并不能避开 ssh 自己提的问题，
;; 例如： “Are you sure you want to continue connecting?” TRAMP (目
;; 前)并不知道如何处理这些问题，所以你必须确保你可以在不被提问的情况
;; 下正常登录(前面那个问题通常是在第一次连接到某个远程主机的时候会被
;; 问到的)。

;; rlogin
;; 和 ssh 类似，但是使用 'rlogin -x' 来登录。

;; plink
;; 这是对于使用 PuTTY 的 ssh 的 Windows 用户来说最有趣的一个 inline
;; method，他使用 'plink -ssh' 来进行连接。

;; 指定默认方法
;; 通过设定 tramp-default-method 变量来指定默认方法：
;;
;; (setq tramp-default-method "scp")
;; 你也可以对特定的 用户/主机 组合设定不同的方法。例如，下面将指定对用
;; 户匹 配 john 使用 ssh，对主机匹配 lily 使用 rsycn 并对本地的 root
;; 使用 su ：

;; (add-to-lisp 'tramp-default-method-alist '("" "john" "ssh"))
;; (add-to-list 'tramp-default-method-alist '("lily" "" "rsync"))
;; (add-to-list 'tramp-default-method-alist
;;              '("\\`localhost\\'" "\\`root\\'" "su"))
;; param1: 主机
;; param2: 用户名
;; param3: 方法

;; 一般推荐使用 inline methods 。External transfer methods 对于大文件
;; 来说 会更快一点，但是一般大家都是编辑小文件。而且 inline methods 通
;; 常也是足 够快的。

;; 指定默认用户
;; 通常在省略用户名的时候，TRAMP 会使用当前的登录用户名，但这通常不是
;; 你想 要的。你可以指定 TRAMP 说使用的默认用户名，例如：

;; (setq tramp-default-user "root")

;; 你也可以对于不同的 方法/主机 组合使用不同的用户名。例如，如果你总是
;; 想在 域 somewhere.else 上使用用户名 john ，你可以用如下方法指定：

;; (add-to-list 'tramp-default-user-alist
;;              '("ssh" ".*\\.somewhere\\.else\\'" "john"))

;; 值得注意的是，如果你在 ssh 的配置文件里面指定了不同的用户，TRAMP 并
;; 不知 道这一点，这将导致登录失败。这个时候你必须让 TRAMP 不要使用默
;; 认的用户名：

;; (add-to-list 'tramp-default-user-alist
;;              '("ssh" "\\`here\\.somewhere\\.else\\'" nil))
;; 指定默认主机
;; 你可以通过 tramp-default-host 变量来设定默认主机。例如，如果你指定了：
;;
;; (setq tramp-default-user "john"
;;       tramp-default-host "target")

;; 那么 `/ssh::' 将连接到 target 上 john 的主目录。注意 `/::' 并不能达
;; 到同 样的目的，因为 `/:' 是 "the prefix for quoted file names" 。

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.

(defun extend-selection (arg &optional incremental)
  "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     (or (and transient-mark-mode mark-active)
                         (eq last-command this-command))))
  (if incremental
      (progn
        (semnav-up (- arg))
        (forward-sexp)
        (mark-sexp -1))
    (if (> arg 1)
        (extend-selection (1- arg) t)
      (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
          (goto-char (match-end 0))
        (unless (memq (char-before) '(?\) ?\"))
          (forward-sexp)))
      (mark-sexp -1))))

;; M-u 往后一个单词大写
;; M-c 往后单词首字母转为大写
;; M-l 往后单词转为小写
;; M--M-u 往前一个单词大写
;; M--M-c 往前单词首字母转为大写
;; M--M-l 往前单词转为小写
;; C-x C-l 选中小写
;; C-x C-u 选中大写
;; f8 自动变化
(defun suk/toggle-letter-case ()
  "Toggle the letter case of current word or text selection.
Toggles from 3 cases: UPPER CASE, lower case, Title Case,
in that cyclic order."
  (interactive)

  (let (pos1 pos2 (deactivate-mark nil) (case-fold-search nil))
    (if (and transient-mark-mode mark-active)
        (setq pos1 (region-beginning)
              pos2 (region-end))
      (setq pos1 (car (bounds-of-thing-at-point 'word))
            pos2 (cdr (bounds-of-thing-at-point 'word))))

    (when (not (eq last-command this-command))
      (save-excursion
        (goto-char pos1)
        (cond
         ((looking-at "[[:lower:]][[:lower:]]") (put this-command 'state "all lower"))
         ((looking-at "[[:upper:]][[:upper:]]") (put this-command 'state "all caps") )
         ((looking-at "[[:upper:]][[:lower:]]") (put this-command 'state "init caps") )
         (t (put this-command 'state "all lower") )
         )
        )
      )

    (cond
     ((string= "all lower" (get this-command 'state))
      (upcase-initials-region pos1 pos2) (put this-command 'state "init caps"))
     ((string= "init caps" (get this-command 'state))
      (upcase-region pos1 pos2) (put this-command 'state "all caps"))
     ((string= "all caps" (get this-command 'state))
      (downcase-region pos1 pos2) (put this-command 'state "all lower"))
     )
    )
  )


(defun suk/popup-term ()
  (interactive)
  (apply 'start-process "terminal" nil popup-terminal-command)
  )

(defun suk/open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList)
        )
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList) ) ) ) ) )


(defun suk/open-in-desktop ()
  "Show current file in desktop (OS's file manager)."
  (interactive)
  (cond
   ((string-equal system-type "windows-nt")
    (w32-shell-execute "explore" (replace-regexp-in-string "/" "\\" default-directory t t)))
   ((string-equal system-type "darwin") (shell-command "open ."))
   ((string-equal system-type "gnu/linux")
    (let ((process-connection-type nil)) (start-process "" nil "xdg-open" "."))
    ) ))



(fset 'suk/showOrHide
      "\C-c@c")

;; C-M-\ 格式化代码。如果要格式化整个文件，你需要先选定整个文件(C-x-h)，
;; 然后调用indent-region（或者 C-M-\ )。 比较麻烦，写个函数处理
(defun suk/indent-buffer ()
  "Indent the whole buffer."
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defvar suk-fullscreen-p t "Check if fullscreen is on or off")

(defun suk/non-fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND restore #xf120
	  (w32-send-sys-command 61728)
	(progn (set-frame-parameter nil 'width 82)
		   (set-frame-parameter nil 'fullscreen 'fullheight))))

(defun suk/fullscreen ()
  (interactive)
  (if (fboundp 'w32-send-sys-command)
	  ;; WM_SYSCOMMAND maximaze #xf030
	  (w32-send-sys-command 61488)
	(set-frame-parameter nil 'fullscreen 'fullboth)))

(defun suk/toggle-fullscreen ()
  (interactive)
  (setq suk-fullscreen-p (not suk-fullscreen-p))
  (if suk-fullscreen-p
	  (suk/non-fullscreen)
	(suk/fullscreen)))


;; M-x align-regexp 可以方便的对齐一些文字
(suk/set-key-bindings 'global-set-key
    (list
       (list (kbd "C-x l")   'suk/count-brf-lines)
       (list (kbd "C-x L")   '(lambda () (interactive) (suk/count-brf-lines t)))
       (list (kbd "C-c u")   'outline-up-heading)
       (list (kbd "C-x a")   'align)
       (list (kbd "C-x M-a") 'align-regexp)
       (list (kbd "C-x x")   'suk/switch-major-mode)
       (list (kbd "C-x X")   'suk/get-mode-name)
       (list (kbd "C-x U")   'suk/revert-buffer-with-utf8)
       (list (kbd "C-x G")   'suk/revert-buffer-with-gbk)
       (list (kbd "C-c s")   'suk/switch-to-scratch)
       '([f1]            speedbar)
       '([S-f1]          suk/toggle-fullscreen)
       '([f2]            calendar)
       '([S-f2]          suk/popup-term)
       ;; f3 start define macro
       ;; f4 finish define macro or execute a macro just define
       '([f5]            toggle-truncate-lines)
       '([f6]            name-last-kbd-macro)
       '([S-f6]          insert-kbd-macro)
       '([f7]            suk/indent-buffer)
       '([f8]            suk/toggle-letter-case)
       '([f10]           suk/point-to-register)
       '([S-f10]         suk/jump-to-register)
       '([f11]           gnus)
       '([f12]           suk/open-in-desktop)
       '([s-f12]         suk/open-in-external-app)
       '([c-t]           transpose-chars)
       '([c-m-h]         outline-mark-subtree)
       '([apps]          suk/showOrHide)
       )
      )


;; f3 kmacro-start-macro-or-insert-counter
;; f4 kmacro-end-or-call-macro

;; C-x n n hide, C-x n w show
;; (global-set-key (kbd "C-x n n") 'narrow-to-region)

;; C-x C-q set/unset readonly
;; c-/ c-_  undo | c-x u undo-tree | c-s-/ s-? M-_ redo
;;(define-key global-map (kbd "C-x M-D") 'dos2unix)
;; 默认： C-M-% (c-m-s-5)
;;(define-key global-map (kbd "ESC M-%") 'query-replace-regexp)
;;(load "~/.emacs.d/site-lisp/suk/color-theme-molokai.el")
;;(color-theme-molokai)

(eval-after-load "eshell"
  `(suk/eshell-settings))
(eval-after-load "tramp"
  `(suk/tramp-settings))



;; grep
(require 'load-undo-tree)
(require 'load-set-font)
(require 'load-calendar)
(require 'load-org)
(require 'load-python-setting)
(require 'load-tabbar)
(require 'load-epa)
(require 'load-abbrev)
;;(require 'sdcv-mode)
;;(require 'load-w3m)
;;(require 'load-t2t)
;;(require 'load-sdcv)
(require 'wangyi-music-mode)
;;(require 'cn-weather)
;;(setq cn-weather-city "深圳")


(provide 'init-suk)
