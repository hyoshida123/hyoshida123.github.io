---
title: データエンジニアが明日から使える関数型プログラミングの設計原則
date: 2026-01-25
lang: ja
description: Functional Programming in Scala から得た知見を、データエンジニアが明日から設計やコードレビューで使える形にまとめました。
---
This is a memo for myself using Claude.


「関数型プログラミング（FP）」と聞くと、Haskellやモナドといった難解なイメージを持つかもしれません。
しかし、FPの本質は関数型言語での書き方のような文法ではなく**設計の判断軸**です。

この記事では、*Functional Programming in Scala* から得た知見を、データエンジニアが明日から設計やコードレビューで使える形にまとめました。

---

### なぜ、"Functional Programming in Scala" なんて古い本を読もうと思ったのか？

Claude Code の作者のBoris Chernyがあるポッドキャストで、
今まで読んできた本の中で一番エンジニアとして働く上で影響を受けた本として紹介していたので読んでみたくなったからです。

[Boris Cherny (Creator of Claude Code) On What Grew His Career And Building at Anthropic](https://youtu.be/AmdLVWMdjOk?si=uZ3xl5XUhE-BKUtq&t=959)

---

読み終わって、「これの考え方は明日から使えるな」と思ったものを５つまとめました。

1. 純粋関数と手続きを分ける
2. 「ロジックは値で返して、世界は最後に一回だけ触る」
3. MonoidとMonad：集約と依存の違い 
4. Property-based Testingでパイプラインをテストする
5. APIの代数（The Algebra of an API） 

---

### 1. 純粋関数と手続き を分ける

FPで最も重要な原則がこれです。

ある関数のコードを1行変えたら、関係ないところで壊れたというケースでは、
関数の実装が純粋関数と手続きの違いを意識せずに実装されていることが原因であることが多いです。

#### 純粋関数とは

- 入力 → 出力のみ
- 副作用なし
- 同じ入力なら常に同じ出力

#### 手続き（副作用を起こす処理）とは

- 副作用を含む一連の処理
- 副作用とは、I/O、DB更新、API呼び出し、ログ出力など

#### 改善前の例

```python
def process_data(df, s3_path):
    result = df.transform(...)  # 純粋な変換
    upload_to_s3(result, s3_path)  # 副作用
    return result
```

変換ロジックとS3アップロードが同居しているので、純粋関数としてはテストしにくくなります。

#### 良い例

```python
def transform_data(df):
    """純粋関数：変換ロジックのみ"""
    return df.transform(...)

def upload_to_s3(df, s3_path):
    """手続き：副作用のみ"""
    # S3にアップロード
    s3_client.upload_file(..., s3_path)

# 呼び出し側で組み合わせる
result = transform_data(df)
upload_to_s3(result, s3_path)
```

**レビューで確認すべきこと：**

- この関数は「計算」と「実行」のどちらか？
- 両方混ざっていないか？

---

### 2. 「ロジックは値で返して、世界は最後に一回だけ触る」

副作用があること自体が問題ではありません。

クレジットカードの決済など、外の世界に影響を与えないとシステムは価値を出しません。

**純粋な計算と副作用を一つの関数に混ぜること**が問題です。

```
[ Pure Core ] → [ Effect Boundary ] → [ Real World ]
```

- **中心**：純粋・テスト可能・推論しやすい
- **外側**：I/O・DB・ネットワーク

ETLパイプラインで例えると：

```
ダウンロード → 解凍 → パース → 変換 → 出力
   ↑                              ↑
  手続き                       手続き
        ↑------- 純粋関数 -----↑
```

ダウンロードと出力は副作用だが、解凍・パース・変換は純粋に書けます。

---

### 3. MonoidとMonad：集約と依存の違い

#### Monoid = 集約の数学

```
順序を変えても結果は同じか？ → YES
```

- sum, count, min, max
- merge, union, concat
- 並列化できる、分散できる

**Spark/Flinkの集約処理はMonoidの一例。**

#### Monad = 依存関係の数学

```
順序を変えても結果は同じか？ → NO
```

- 前のステップの結果で次の処理が決まる
- 失敗したら止まる、分岐する

**Step Functions/Airflow的なワークフローはMonadの一例。**

#### 設計判断の基準

**「順序を変えても結果は同じか？」**

- YES → 並列化できる（Monoid）
- NO → 逐次実行が必要（Monad）

---

### 4. Property-based Testingでパイプラインをテストする

#### 従来のテスト

```python
assert reverse([1, 2, 3]) == [3, 2, 1]
```

これだと境界条件や空リスト、ランダムケースなどを見落としがちです。

#### Property-based Testing

```python
# 任意のリストで常に成り立つ性質
assert reverse(reverse(xs)) == xs
```

#### データエンジニア向けの性質例

```python
# joinの性質
assert len(left_join(left, right)) >= len(left)

# aggregationの性質
assert sum(xs) == sum(shuffle(xs))

# 分散処理の性質
assert merge(partition(xs)) == xs
```

**使うべき場所：**

- パーサ、正規化、変換
- join、group
- 分割・結合ロジック
- 集計

---

### 5. APIの代数（The Algebra of an API）

APIは「関数の一覧」ではありません。**操作 + 法則 = API**。

#### 操作（Operations）

```
put(key, value)
get(key)
delete(key)
```

#### 法則（Laws）

```
get(put(k, v)) == v
get(delete(k)) == None
```

**法則が書けないAPIは、設計を見直す余地があるかもしれません。**

#### レビューで確認すべきこと

- このAPIの「操作」は何か？
- 「常に成り立つべき法則」は何か？
- 呼び出し順に依存する暗黙ルールがないか？

---

### 明日からのアクションリスト

この本を読んだ後に明日から以下の行動を変えようと思いました。

#### 設計時

- 関数を書く前に「これは計算か実行か」を決める
- 副作用は関数の外に追い出せないか検討する
- 「順序を変えても同じか？」で並列化可否を判断する
- パーサーの設計は、処理の代数式を書くところから始める

#### コードレビュー時

- 純粋な変換と副作用が混ざっていないか
- DataFrameの操作と`collect()`が適切に分離されているか
- テストは「例」ではなく「性質」を検証しているか
- APIに暗黙の呼び出し順序依存がないか

#### テスト時

- 集約処理には`sum(xs) == sum(shuffle(xs))`的な性質を書く
- 変換処理には可逆性`decode(encode(x)) == x`を確認する
- joinには件数の不変量をチェックする

---

### まとめ

FPの**設計技法**まとめると、

- 純粋関数と手続きを分ける
- ロジックは値で返し、副作用は最後に一回処理する
- 順序依存の有無で並列化を判断する
- 法則（性質）でテストする

これらは言語を問わず、Python、Scala、SQLのどこでも使えます。

**「これは混ぜてはいけない」という嗅覚**を身につければ、コードが大きくなっても壊れにくいデータパイプラインを維持できるようになると思います。

なお、原著ではMonoidやMonadといった概念がもっと厳密な言葉で説明されています。
この記事では自分の理解を整理するために、できるだけ柔らかい表現でまとめました。

データパイプラインの設計に使える考え方が詰まった一冊なので、興味があればぜひ手に取ってみてください。

---

*参考: Functional Programming in Scala (Paul Chiusano, Rúnar Bjarnason)*
