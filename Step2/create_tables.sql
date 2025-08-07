/*テーブル名    table name     
    ジャンル    genres   
    番組        programs  
    シーズン    seasons   
    エピソード  episodes   
    チャンネル  channels   
    放送日      onairdays 
    視聴数      views   
*/

create table genres (
    gen_id   int         not null auto_increment,
    gen_name varchar(10) not null,
    primary key (gen_id)
);

create table programs (
    pro_id      int         not null auto_increment,
    pro_name    varchar(30) not null,               
    gen_id      int         not null,    
    details     varchar(30),   
    primary key (pro_id),
    foreign key (gen_id) references genres (gen_id)
    on delete cascade    
);

create index gen_index on programs (gen_id);

create table seasons (
    se_id       int             not null auto_increment,
    se_name     varchar(10),     
    pro_id     int             not null,   
    primary key (se_id),
    foreign key (pro_id) references programs (pro_id) on delete cascade    
);
create index prog_index on seasons (prog_id);

create table episodes (
    epi_id      int         not null auto_increment,       
    epi_name    varchar(30),           
    se_id       int         not null,    
    runtime     time        not null,
    primary key (epi_id),
    foreign key (se_id) references seasons (se_id) on delete cascade
);

create table channels (
    chan_id     int         not null auto_increment,
    chan_name   varchar(10) not null,
    primary key (chan_id)  
);

create table onairdays (
    onair_id    int     not null auto_increment,     
    onair_day   date    not null,              
    chan_id     int     not null,    
    epi_id      int     not null,          
    start_time  time    not null,           
    end_time    time    not null,
    primary key (onair_id),            
    foreign key (chan_id) references channels (chan_id),
    foreign key (epi_id) references episodes (epi_id) on delete cascade    
);
create index chan_index on onairdays (chan_id);

create table views (
    view_id     int  not null auto_increment, 
    onair_id    int  not null,             
    view_count  int  not null default 0, 
    primary key (view_id),
    foreign key (onair_id) references onairdays (onair_id) on delete cascade    
);
