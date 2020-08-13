BEGIN TRANSACTION;

CREATE TABLE `t_notifier`
(
    `name`    TEXT PRIMARY KEY,
    `url`     TEXT,
    `enabled` INTEGER
);
CREATE TABLE `t_languages`
(
    `code3`   TEXT PRIMARY KEY,
    `code2`   TEXT NOT NULL,
    `name`    TEXT NOT NULL,
    `enabled` INTEGER,
    `code3b`  TEXT
);

CREATE TABLE t_rootdir
(
    `id`   INTEGER PRIMARY KEY,
    `path` TEXT
);
CREATE TABLE `t_series`
(
    `id`               INTEGER PRIMARY KEY,
    `rootdirId`        INTEGER NOT NULL,
    `tmdbId`           INTEGER NOT NULL UNIQUE,
    `tvdbId`           INTEGER UNIQUE,
    `imdbId`           TEXT UNIQUE,
    `sonarrSeriesId`   INTEGER UNIQUE,
    `title`            TEXT    NOT NULL,
    `path`             TEXT    NOT NULL UNIQUE,
    `language_profile` INTEGER,
    `overview`         TEXT,
    `posterSource`     TEXT,
    `poster`           TEXT,
    `fanartSource`     TEXT,
    `fanart`           TEXT,
    `sortTitle`        TEXT    NOT NULL,
    `year`             INTEGER,
    `alternateTitles`  TEXT,
    `monitored`        INTEGER,
    FOREIGN KEY (`rootdirId`) REFERENCES `t_rootdir` (`id`) ON DELETE CASCADE
);
CREATE TABLE `t_episodes`
(
    `id`               INTEGER PRIMARY KEY,
    `seriesId`         INTEGER,
    `sonarrEpisodeId`  INTEGER UNIQUE,
    `title`            TEXT    NOT NULL,
    `path`             TEXT    NOT NULL,
    `season`           INTEGER NOT NULL,
    `episode`          INTEGER NOT NULL,
    `indexedSubtitles` TEXT,
    `missingSubtitles` TEXT,
    `sceneName`        TEXT,
    `monitored`        INTEGER,
    `failedAttempts`   TEXT,
    `format`           TEXT,
    `resolution`       TEXT,
    `video_codec`      TEXT,
    `audio_codec`      TEXT,
    FOREIGN KEY (`seriesId`) REFERENCES `t_series` (`id`) ON DELETE CASCADE
);
CREATE TABLE `t_history_series`
(
    `id`             INTEGER PRIMARY KEY,
    `seriesId`       INTEGER NOT NULL,
    `episodeId`      INTEGER NOT NULL,
    `timestamp`      INTEGER NOT NULL,
    `action`         INTEGER NOT NULL,
    `description`    TEXT    NOT NULL,
    `video_path`     TEXT,
    `language`       TEXT,
    `provider`       TEXT,
    `score`          TEXT,
    `subs_id`        TEXT,
    `subtitles_path` TEXT,
    FOREIGN KEY (`seriesId`) REFERENCES `t_series` (`id`) ON DELETE CASCADE
        FOREIGN KEY (`episodeId`) REFERENCES `t_episodes`(`id`) ON DELETE CASCADE
);
CREATE TABLE t_blacklist_series
(
    `id`        INTEGER PRIMARY KEY,
    `seriesId`  INTEGER NOT NULL,
    `episodeId` INTEGER NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `provider`  TEXT    NOT NULL,
    `subs_id`   TEXT    NOT NULL,
    `language`  TEXT    NOT NULL,
    FOREIGN KEY (`seriesId`) REFERENCES `t_series` (`id`) ON DELETE CASCADE
        FOREIGN KEY (`episodeId`) REFERENCES `t_episodes`(`id`) ON DELETE CASCADE
);

CREATE TABLE t_rootdir_movies
(
    `id`   INTEGER PRIMARY KEY,
    `path` TEXT
);
CREATE TABLE `t_movies`
(
    `id`                INTEGER PRIMARY KEY,
    `rootdirId`         INTEGER NOT NULL,
    `tmdbId`            INTEGER NOT NULL UNIQUE,
    `imdbId`            TEXT UNIQUE,
    `title`             TEXT    NOT NULL,
    `path`              TEXT    NOT NULL UNIQUE,
    `languages`         TEXT,
    `subtitles`         TEXT,
    `missing_subtitles` TEXT,
    `hearing_impaired`  TEXT,
    `radarrId`          INTEGER UNIQUE,
    `overview`          TEXT,
    `posterSource`      TEXT,
    `poster`            TEXT,
    `fanartSource`      TEXT,
    `fanart`            TEXT,
    `sceneName`         TEXT,
    `monitored`         TEXT,
    `failedAttempts`    TEXT,
    `sortTitle`         TEXT    NOT NULL,
    `year`              TEXT,
    `alternateTitles`   TEXT,
    `format`            TEXT,
    `resolution`        TEXT,
    `video_codec`       TEXT,
    `audio_codec`       TEXT,
    FOREIGN KEY (`rootdirId`) REFERENCES `t_rootdir_movie` (`id`) ON DELETE CASCADE
);
CREATE TABLE `t_history_movies`
(
    `id`             INTEGER PRIMARY KEY,
    `movieId`        INTEGER NOT NULL,
    `timestamp`      INTEGER NOT NULL,
    `action`         INTEGER NOT NULL,
    `description`    TEXT    NOT NULL,
    `video_path`     TEXT,
    `language`       TEXT,
    `provider`       TEXT,
    `score`          TEXT,
    `subs_id`        TEXT,
    `subtitles_path` TEXT,
    FOREIGN KEY (`movieId`) REFERENCES `t_movies` (`id`) ON DELETE CASCADE
);
CREATE TABLE t_blacklist_movies
(
    `id`        INTEGER PRIMARY KEY,
    `movieId`   INTEGER NOT NULL,
    `timestamp` INTEGER NOT NULL,
    `provider`  TEXT    NOT NULL,
    `subs_id`   TEXT    NOT NULL,
    `language`  TEXT    NOT NULL,
    FOREIGN KEY (`movieId`) REFERENCES `t_movies` (`id`) ON DELETE CASCADE
);


--rootdir test data------------------------------------------------------------
INSERT INTO `t_rootdir` (id, path)
VALUES (1, 'Z:\Series TV');
INSERT INTO `t_rootdir` (id, path)
VALUES (2, 'Z:\series_caro');
INSERT INTO `t_rootdir` (id, path)
VALUES (3, 'Z:\series_rosalie');
--end--------------------------------------------------------------------------

--rootdir_movie test data------------------------------------------------------
INSERT INTO `t_rootdir_movies` (id, path)
VALUES (1, 'Z:\Films HD');
INSERT INTO `t_rootdir_movies` (id, path)
VALUES (2, 'Z:\films_rosalie');
--end--------------------------------------------------------------------------

COMMIT;