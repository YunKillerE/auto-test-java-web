DECLARE c1 cursor for
    select 'alter table ['+ object_name(parent_obj) + '] drop constraint ['+name+']; '
    from sysobjects
    where xtype = 'F'
open c1
declare @c1 varchar(8000)
fetch next from c1 into @c1
while(@@fetch_status=0)
    begin
        exec(@c1)
        fetch next from c1 into @c1
    end
close c1
deallocate c1
--删除数据库所有表
declare @name varchar(8000)
set @name=''
select @name=@name + Name + ',' from sysobjects where xtype='U'
select @name='drop table ' + left(@name,len(@name)-1)
exec(@name)
