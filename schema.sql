-- 应用时间看板 · Cloudflare D1 建表脚本
-- 用法：在 Cloudflare 控制台打开 D1 数据库 → Console → 粘贴整段执行
-- 全部语句都是 IF NOT EXISTS，可反复执行，不会丢已有数据。

CREATE TABLE IF NOT EXISTS sessions (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  device       TEXT    NOT NULL,
  app_key      TEXT    NOT NULL,
  app_label    TEXT    NOT NULL,
  start_ms     INTEGER NOT NULL,
  end_ms       INTEGER,
  duration_ms  INTEGER,
  source       TEXT    NOT NULL,
  estimated    INTEGER NOT NULL DEFAULT 0,
  created_at   INTEGER NOT NULL
);

-- 去重：同设备、同应用、同开始时间、同来源只保留一条
CREATE UNIQUE INDEX IF NOT EXISTS idx_unique ON sessions(device, app_key, start_ms, source);
CREATE INDEX IF NOT EXISTS idx_start ON sessions(start_ms);
CREATE INDEX IF NOT EXISTS idx_device_open ON sessions(device, end_ms);

-- 同步时间戳：记录 vivo / iPad 最近一次成功上报的时间（仅用于看板显示"数据有多新"）
CREATE TABLE IF NOT EXISTS meta (
  k TEXT PRIMARY KEY,
  v TEXT NOT NULL
);
