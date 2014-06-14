Backup::Model.new(:sample_backup, 'A sample backup configuration') do

  database MySQL do |database|
    database.name               = 'cda_new'
    database.username           = 'cdaadmin1'
    database.password           = 'padi6Rj1'
    database.host               = "184.106.231.215"
    database.port               = 3306    
    database.additional_options = ['--single-transaction', '--quick']
  end

  compress_with Gzip do |compression|
    compression.best = true
  end

  store_with RSync do |server|
    server.username = '4661'
    server.password = 'ctSq7bu3'
    server.ip       = 'usw-s004.rsync.net'
    server.port     = 22
    server.path     = '~/backups/'
  end
end