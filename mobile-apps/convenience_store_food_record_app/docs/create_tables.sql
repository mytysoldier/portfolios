CREATE SCHEMA IF NOT EXISTS conv_food_record_app;

CREATE TABLE IF NOT EXISTS conv_food_record_app.user (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    deleted_at TIMESTAMP
);

CREATE TABLE IF NOT EXISTS conv_food_record_app.store_master (
    id SERIAL PRIMARY KEY,
    store_name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS conv_food_record_app.category_master (
    id SERIAL PRIMARY KEY,
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
    store_id INTEGER REFERENCES conv_food_record_app.store_master(id),
    category_id INTEGER REFERENCES conv_food_record_app.category_master(id),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id INTEGER REFERENCES conv_food_record_app.user(id)
);
