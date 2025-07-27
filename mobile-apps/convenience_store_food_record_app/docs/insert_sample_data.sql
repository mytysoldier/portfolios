-- user テーブル（Supabase Authを使わない場合の例）
INSERT INTO conv_food_record_app.user (user_name, password, created_at, updated_at)
VALUES ('testuser', 'hashed_password', NOW(), NOW());

-- store_master テーブル
INSERT INTO conv_food_record_app.store_master (store_name, created_at, updated_at)
VALUES ('セブンイレブン', NOW(), NOW()),
       ('ローソン', NOW(), NOW()),
       ('ファミリーマート', NOW(), NOW());

-- category_master テーブル
INSERT INTO conv_food_record_app.category_master (category_name, created_at, updated_at)
VALUES ('おにぎり', NOW(), NOW()),
       ('パン', NOW(), NOW()),
       ('弁当', NOW(), NOW()),
       ('デザート', NOW(), NOW()),
       ('飲み物', NOW(), NOW());

-- purchase_history テーブル
INSERT INTO conv_food_record_app.purchase_history (
    item_name, price, item_img, memo, purchase_date, store_id, category_id, created_at, updated_at, user_id
) VALUES (
    'ツナマヨおにぎり', 130, 'https://example.com/onigiri.jpg', '美味しかった', '2025-07-27 12:00:00', 1, 1, NOW(), NOW(), 1
), (
    'カレーパン', 150, NULL, NULL, '2025-07-26 08:30:00', 2, 2, NOW(), NOW(), 1
);
