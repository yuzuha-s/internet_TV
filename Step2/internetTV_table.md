# データベースの構築

## 1.コマンド処理
### 1. MySQLにログインする
```
mysql -u root -p
```

### 2. データベースを作成する
```
create database internet_tv;

※データベース一覧を表示する
show datebases;

※使用するデータベースを指定する
use internet_tv
```

### 3. テーブルを作成する  
※SQL文はcreate_tables.sqlに記載しています。  

|テーブル|tables|  
| ---- | ---- |  
|ジャンル|genres|   
|番組 | programs  |
|シーズン |   seasons |
|エピソード|  episodes |
|チャンネル | channels|
|放送日 |onairdays|
|視聴数 |views|

```
create table テーブル名 (   
    id      int             not null,
    name    varchar(10)     not null,
    primary key (id),   
);
````

```
※テーブル一覧を表示する
show tables;

※テーブルの設定を見る
show columns from テーブル名;

※テーブル内のデータを見る
select * from genres;
```

### 4. テーブルへのデータ登録(レコード入力)
※SQL文はcreate_tables.sqlに記載しています。

```
insert into テーブル名 (カラム名1,カラム名2,カラム名3) values
('カラム名1のデータ','カラム名2のデータ','カラム名3のデータ'),
...............

('カラム名1のデータ','カラム名2のデータ','カラム名3のデータ');
```

```
※登録データを変更する
update テーブル名
set カラム名 = case カラム名
    where 1 then 73218;
```

### 5. インデックスを作成する
※今回のデータはそれほど膨大ではないため不要だか、データ量を増やした場合は下記で設定する。
```
create index prog_index on seasons (prog_id);
create index chan_index on onairdays (chan_id);
```

### 6.トランザクション、ロックの設定

```
- トランザクションを実行する
start transaction;

- ロールバックのを実行する
rollback;

- コミットを実行する
commit;
```

