const nameDatabaseFile = 'wallpapers_database.db';
const sqlTableWallpapers = 'Wallpapers';
const sqlQueryCreateTable =
    'CREATE TABLE $sqlTableWallpapers (id TEXT PRIMARY KEY, json TEXT)';
