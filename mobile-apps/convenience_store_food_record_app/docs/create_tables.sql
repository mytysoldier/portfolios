CREATE SCHEMA IF NOT EXISTS conv_food_record_app;

DROP TABLE IF EXISTS conv_food_record_app.user CASCADE;

CREATE TABLE conv_food_record_app.user (
    id SERIAL PRIMARY KEY, -- 主キー
    user_name TEXT,                       -- ユーザー名
    password TEXT,                        -- パスワード
    device_id TEXT,                       -- デバイスID（未登録ユーザー用）
    created_at TIMESTAMP,                  -- 作成日時
    updated_at TIMESTAMP,                  -- 更新日時
    deleted_at TIMESTAMP                   -- 削除日時
);


CREATE TABLE IF NOT EXISTS conv_food_record_app.store_master (
    id INTEGER PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);


CREATE TABLE IF NOT EXISTS conv_food_record_app.category_master (
    id INTEGER PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS conv_food_record_app.purchase_history (
    id SERIAL PRIMARY KEY,
    item_name VARCHAR(255) NOT NULL,
    price INTEGER NOT NULL,
    item_img VARCHAR(1024) NULL,
    memo TEXT NULL,
    purchase_date TIMESTAMP NOT NULL,
    store_id INTEGER REFERENCES conv_food_record_app.store_master(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES conv_food_record_app.category_master(id) ON DELETE CASCADE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id INTEGER REFERENCES conv_food_record_app.user(id) ON DELETE CASCADE
);

DROP TABLE IF EXISTS conv_food_record_app.upload_daily_usage CASCADE;

CREATE TABLE IF NOT EXISTS conv_food_record_app.upload_daily_usage (
    user_id INTEGER NOT NULL REFERENCES conv_food_record_app.user(id) ON DELETE CASCADE,
    quota_date DATE NOT NULL,
    current_count INTEGER NOT NULL DEFAULT 0,
    daily_limit INTEGER NOT NULL,
    last_uploaded_at TIMESTAMP NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, quota_date),
    CHECK (daily_limit > 0),
    CHECK (current_count >= 0)
);
