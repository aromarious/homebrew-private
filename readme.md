# homebrew-private

個人的な homebrew のパッケージを管理するためのリポジトリ

## 使い方

0. このリポジトリをtapとして登録する。`brew tap aromarious/private`
1. プロダクトリポジトリに`v*`のタグを付けるとこのリポジトリに`repository_dispatch`イベントを通知するワークフローを仕込む
2. このリポジトリの`update-brew`ワークフローが動作し、Formulaを更新するプルリクエストが作成される
3. プルリクエストを承認し、プルリク用のブランチをデリートする
4. `brew install {{formula}}` または `brew upgrade {{formula}}` を実行する

プロダクトリポジトリではコミットを済ませてからタグを打ち、それ以降の作業はtapリポジトリで行われるため、特別な作業はなし。
