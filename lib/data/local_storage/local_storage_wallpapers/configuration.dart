const nameDatabaseFile = 'wallpapers_database.db';
const sqlTableWallpapers = 'Wallpapers';
const sqlQueryCreateTable ='''
CREATE TABLE $sqlTableWallpapers 
(id TEXT PRIMARY KEY, 
favorites INTEGER,
category TEXT,
resolution TEXT,
fileSizeBytes INTEGER,
createdAt TEXT,
isSetWallpaper INTEGER,
path TEXT)
''';
