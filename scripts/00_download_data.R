# download necessary files from dropbox into a folder called 'data'

# create data directory
dir.create(paste(getwd(), '/data', sep = ''), showWarnings = F)

# download each file
download.file('https://www.dropbox.com/s/gys8gf2ov729aeu/lexicon.txt?dl=1', 'data/lexicon.txt', mode = 'wb')
download.file('https://www.dropbox.com/s/5jyow1rv7zixojh/db_full.txt?dl=1', 'data/db_full.txt', mode = 'wb')
download.file('https://www.dropbox.com/s/6tnzkc4dr3tkxxl/sources.txt?dl=1', 'data/sources.txt', mode = 'wb')