# 匙(さじ)

日本語環境で使用するアプリやフォントを寄せ集めた[Scoop](https://github.com/lukesampson/scoop)の非公式Bucketになります。

## 収録Manifest

### アプリ
- NTEmacs: `emacs-nt`
- Nyagos: `nyagos`
- KaoriYa版Vim: `vim-kaoriya`

### フォント
- Cica: `cica`
- Myrica: `myrica`
- MyricaM: `myrica-m`

## 予定

- SKK各種(要管理者権限)
- SKK辞書
- WinMerge日本語版
- フォント各種

## 使い方

Bucket有効化
```
scoop bucket add jp https://github.com/rkbk60/saji
```

アプリの追加
```
scoop install emacs-nt vim-kaoriya
```

フォントの追加(全自動)
```
scoop install main/sudo
sudo scoop install cica -g
```

フォントの追加(半自動)
```
scoop install cica
explorer /select %JP_FONTS_DIR%
```

## 追加・修正・削除など

すべて当リポジトリのIssuesにて受け付けています。
[CONTRIBUTING](https:github.com/rkbk60/saji/blob/master/CONTRIBUTING.md)も作りましたので、ぜひご覧ください。