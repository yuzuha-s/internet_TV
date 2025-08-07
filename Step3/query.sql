--1. よく見られているエピソードを知りたいです。
--エピソード視聴数トップ3のエピソードタイトルと視聴数を取得してください

-- 順位 | 番組名 | エピソードタイトル | 視聴数 |

select
    row_number() over (order by v.view_count desc) as 順位,
    p.pro_name      as 番組名,
    e.epi_name      as エピソードタイトル,
    v.view_count    as 視聴数
from views v
inner join onairdays o on v.onair_id = o.onair_id
inner join episodes e on o.epi_id = e.epi_id
inner join seasons s on e.se_id = s.se_id
inner join programs p on s.pro_id = p.pro_id
order by v.view_count desc
limit 3;

--2. よく見られているエピソードの番組情報やシーズン情報も合わせて知りたいです。
--エピソード視聴数トップ3の番組タイトル、シーズン数、エピソード数、エピソードタイトル、視聴数を取得してください

-- 順位 | 番組名 | シーズン名 | エピソードタイトル | 視聴数 | 番組シーズン数 | 番組エピソード数 |

select
    row_number() over (order by v.view_count desc) as 順位,
    p.pro_name      as 番組名,
    s.se_name       as シーズン名,
    e.epi_name      as エピソードタイトル,
    v.view_count    as 視聴数,
    -- 番組のシーズン数（サブクエリで重複ないようにカウント）
    (select count(distinct se_id) from seasons where pro_id = p.pro_id) as 番組シーズン数,
    -- シーズンのエピソード数（サブクエリで重複ないようにカウント）
    (select count(*) from episodes where se_id = s.se_id) as 番組エピソード数
from views v
inner join onairdays o on v.onair_id = o.onair_id
inner join episodes e on o.epi_id = e.epi_id
inner join seasons s on e.se_id = s.se_id
inner join programs p on s.pro_id = p.pro_id
order by v.view_count desc
limit 3;


--3. 本日の番組表を表示するために、本日、どのチャンネルの、何時から、何の番組が放送されるのかを知りたいです。
--本日放送される全ての番組に対して、チャンネル名、放送開始時刻(日付+時間)、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を取得してください。
--なお、番組の開始時刻が本日のものを本日方法される番組とみなすものとします=8/1とする

--| 放送開始時刻 | 放送終了時刻 | チャンネル名 | 番組名 | 番組シーズン数 | 番組エピソード数 | エピソード詳細 |  
select 
    o.start_time    as 放送開始時刻,    
    o.end_time      as 放送終了時刻,
    o.chan_id        as チャンネル名,
    p.pro_name      as 番組名,
    (select count(distinct se_id) from seasons where pro_id = p.pro_id) as 番組シーズン数,
    (select count(*) from episodes where se_id = s.se_id) as 番組エピソード数,
    p.details        as エピソード詳細
from onairdays o
inner join episodes e on o.epi_id = e.epi_id
inner join seasons s on e.se_id = s.se_id
inner join programs p on s.pro_id = p.pro_id
inner join views v on o.onair_id = v.onair_id
where o.onair_day = '2025-08-01'
order by o.start_time asc, o.chan_id asc;

--4. ドラマというチャンネルがあったとして、ドラマのチャンネルの番組表を表示するために、本日から一週間分、何日の何時から何の番組が放送されるのかを知りたいです。
--ドラマのチャンネルに対して、放送開始時刻、放送終了時刻、シーズン数、エピソード数、エピソードタイトル、エピソード詳細を本日から一週間分取得してください

--| 放送日 | 放送開始時刻 | 放送終了時刻 | 番組名 | 番組シーズン数 | 番組エピソード数 | エピソード詳細  |     

select 
    o.onair_day     as 放送日,
    o.start_time    as 放送開始時刻,    
    o.end_time      as 放送終了時刻,
    p.pro_name      as 番組名,
    (select count(distinct se_id) from seasons where pro_id = p.pro_id) as 番組シーズン数,
    (select count(*) from episodes where se_id = s.se_id) as 番組エピソード数,
    p.details        as エピソード詳細
from onairdays o
inner join episodes e on o.epi_id = e.epi_id
inner join seasons s on e.se_id = s.se_id
inner join programs p on s.pro_id = p.pro_id
inner join views v on o.onair_id = v.onair_id
inner join genres g on p.gen_id = g.gen_id
where o.onair_day between '2025-08-01' and '2025-08-07' 
    and g.gen_id = 1
order by o.onair_day asc, o.start_time asc;

--5. (advanced) 直近一週間で最も見られた番組が知りたいです。
--直近一週間に放送された番組の中で、エピソード視聴数合計トップ2の番組に対して、番組タイトル、視聴数を取得してください

-- | 順位 | 番組名 | 合計視聴数 |

with 合計視聴数 as  (
    select 
        p.pro_name as 番組名,
        sum(v.view_count) as 合計視聴数
    from onairdays o
    inner join episodes e on o.epi_id = e.epi_id
    inner join seasons s on e.se_id = s.se_id
    inner join programs p on s.pro_id = p.pro_id
    inner join views v on o.onair_id = v.onair_id
    where o.onair_day between '2025-08-01' and '2025-08-07' 
    group by p.pro_name
)
select 
    row_number() over (order by 合計視聴数 desc) as 順位,
    番組名,
    合計視聴数
from 合計視聴数
order by 合計視聴数 desc
limit 2;


--6. (advanced) ジャンルごとの番組の視聴数ランキングを知りたいです
--番組の視聴数ランキングはエピソードの平均視聴数ランキングとします
--ジャンルごとに視聴数トップの番組に対して、ジャンル名、番組タイトル、エピソード平均視聴数を取得してください。

-- | ジャンル名 | 番組名 | エピソード平均視聴数 |

with エピソード平均視聴数 as (
    select 
        g.gen_name as ジャンル名,
        p.pro_name as 番組名,
        round(avg(v.view_count)) as エピソード平均視聴数
    from onairdays o
    inner join episodes e on o.epi_id = e.epi_id
    inner join seasons s on e.se_id = s.se_id
    inner join programs p on s.pro_id = p.pro_id
    inner join genres g on p.gen_id = g.gen_id 
    inner join views v on o.onair_id = v.onair_id
    where o.onair_day between '2025-08-01' and '2025-08-07' 
    group by g.gen_name,p.pro_name
),
順位 as (
    select 
        ジャンル名,
        番組名,
        エピソード平均視聴数,
        row_number() over (partition by ジャンル名 order by エピソード平均視聴数) as 最大平均視聴数
    from エピソード平均視聴数
)
select 
    ジャンル名,
    番組名,
    エピソード平均視聴数
from 順位
where 最大平均視聴数 = 1
order by エピソード平均視聴数 desc;

