# Scoop for jp [![test on AppVeyor](https://ci.appveyor.com/api/projects/status/d8wbibud44gg8toi?svg=true&failingText=Test%3Afailing&passingText=Test%3Apassing)](https://ci.appveyor.com/project/rkbk60/scoop-for-jp)

日本語環境で使用するポータブルアプリやフォントなどを寄せ集めた[Scoop](https://github.com/lukesampson/scoop)の非公式Bucketです。
非技術者含む幅広い日本人を対象した、`main`や`extras`など基本的なBucketの拡張にすることを目的としています。

## 収録Manifest

### アプリ
- NTEmacs: `emacs-nt`
- Nyagos: `nyagos`
- KaoriYa版Vim: `vim-kaoriya`

### フォント
- Cica: `cica`
- Myrica: `myrica`
- MyricaM: `myrica-m`
- Ricty Diminished: `ricty-diminished`

### 予定

- 秀丸エディタ
- TeraX(TeraTerm, TeraPad...)
- SKKツール各種
- SKK辞書
- WinMerge日本語版
- フォント各種(OpenTypeやプロポーショナル版含む)

## 使い方

Bucket有効化
```
scoop bucket add jp https://github.com/rkbk60/scoop-for-jp
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

フォントの追加(半自動、展開先は環境変数`JP_FONT_DIR`で指定可能)
```
scoop install cica
explorer %USERPROFILE%\JpFonts
```

## 追加・修正・削除など

すべて当リポジトリのIssuesにて受け付けています。
[CONTRIBUTING](https://github.com/rkbk60/scoop-for-jp/blob/master/CONTRIBUTING.md)も作りましたので、ぜひご覧ください。
