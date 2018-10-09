- 导出数据库为dbname的表结构  
`mysqldump -uroot -pdbpasswd -d dbname > db.sql`

- 导出数据库为dbname某张表（test）结构  
`mysqldump -uroot -pdbpasswd -d dbname test > db.sql`

- 导出数据库为dbname所有表结构及表数据  
`mysqldump -uroot -pdbpasswd dbname > db.sql`

- 导出数据库为dbname某张表（test）结构及表数据  
`mysqldump -uroot -pdbpasswd dbname test > db.sql`