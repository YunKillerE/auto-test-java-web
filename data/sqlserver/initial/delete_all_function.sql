declare mycur cursor local for select [name] from dbo.sysobjects where xtype='FN'  --声明游标
declare @name varchar(100)
OPEN mycur    --打开游标
FETCH NEXT from mycur into @name
WHILE @@FETCH_STATUS = 0 
BEGIN
exec('drop function ' + @name)
FETCH NEXT from mycur into @name   --逐条读取
END
CLOSE mycur   --关闭游标
