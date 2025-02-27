create schema if not exists securecapita;
set names 'uf8m4';
set time_zone = 'US/Eastern';
set time_zone = '-4:00';


use securecapita;

drop table if exists User;

create table User (
    id bigint not null auto_increment PRIMARY KEY,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    email varchar(100) not null,
    password varchar(255) default not null,
    address varchar(255) default not null,
    phone varchar(30) default null,
    title varchar(50) default null,
    bio varchar(255) default null,
    enabled boolean default false,
    non_locked boolean default true,
    using_mfa boolean default false,
    created_at timestamp default current_timestamp,
    image_url varchar(255) default 'https://t3.ftcdn.net/jpg/05/00/54/28/360_F_500542898_LpYSy4RGAi95aDim3TLtSgCNUxNlOlcM.jpg', 
    constraint uq_users_email unique (email)
);

drop table if exists Roles;

create table Roles (
    id bigint not null auto_increment PRIMARY KEY,
    name varchar(50) not null,
    permission varchar(255) not null,
    constraint uq_roles_name unique (name)
);

drop table if exists UserRoles;

create table UserRoles(
    id bigint not null auto_increment PRIMARY KEY,
    user_id bigint unsigned not null,
    role_id bigint unsigned not null,
    foreign key(user_id) references User(id) on delete cascade on update cascade,
    foreign key(role_id) references Roles(id) on delete restrict on update cascade,
    constraint uq_userroles_user_id unique (user_id), 
);

drop table if exists Events;

create table Events(
    id bigint unsigned not null auto_increment PRIMARY KEY,
    type varchar(50) not null check(type in ('LOGIN_ATTEMPT', 'LOGIN_ATTEMPT_FAILURE', 'LOGIN_ATTEMPT_SUCCESS', 'PROFILE_UPDATE', 'PROFILE_PICTURE_UPDATE','ROLE_UPDATE',
    'ACCOUNT_SETTINGS_UPDATE','PASSWORD_UPDATE','MFA_UPDATE')),
    description varchar(255) not null,
    constraint uq_events_type unique (type)

);

drop table if exists UserEvents;

create table UserEvents(
    id bigint unsigned not null auto_increment PRIMARY KEY,
    user_id bigint unsigned not null,
    event_id bigint unsigned not null,
    device varchar(100) default null,
    ip_address varchar(100) default null,
    created_at datetime default current_timestamp,
    foreign key(user_id) references User(id) on delete cascade on update cascade,
    foreign key(event_id) references Events(id) on delete restrict on update cascade,
    constraint uq_userevents_user_id unique (user_id)
)

drop table if exists AccountVerifications;

create table AccountVerifications(
    id bigint unsigned not null auto_increment PRIMARY KEY,
    user_id bigint unsigned not null,
    url varchar(255) not null,
    -- date datetime not null, 
    foreign key(user_id) references User(id) on delete cascade on update cascade,
    constraint uq_account_verification_user_id unique (user_id)
    constraint uq_account_verification_url unique (url)
)

drop table if exists ResetPasswordVerification;

create table ResetPasswordVerification(
    id bigint unsigned not null auto_increment PRIMARY KEY,
    user_id bigint unsigned not null,
    url varchar(255) not null,
    expiration_date datetime not null, 
    foreign key(user_id) references User(id) on delete cascade on update cascade,
    constraint uq_reset_password_verification_user_id unique (user_id)
    constraint uq_reset_password_verification_url unique (url)
)

drop table if exists TwoFactorVerification;

create table TwoFactorVerification(
    id bigint unsigned not null auto_increment PRIMARY KEY,
    user_id bigint unsigned not null,
    code varchar(10) not null,
    expiration_date datetime not null, 
    foreign key(user_id) references User(id) on delete cascade on update cascade,
    constraint uq_two_factor_verification_user_id unique (user_id)
    constraint uq_two_factor_verification_code unique (code)
)
