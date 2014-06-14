rake db:drop db:create
mysqldump -P3306 -ucdaadmin1 -ppadi6Rj1 --host=184.106.231.215 -d cda_new > tmp/schema_dump.sql
mysqldump -P3306 -ucdaadmin1 -ppadi6Rj1 --host=184.106.231.215 -n -t --lock-tables=false  --ignore-table=cda_new.oem_user_role --ignore-table=cda_new.oem_user --ignore-table=cda_new.users  cda_new > tmp/data_dump_no_users.sql
mysql -uroot aai_home_dev < tmp/schema_dump.sql
mysql -uroot aai_home_dev < tmp/data_dump_no_users.sql

