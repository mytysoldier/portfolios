-- store_master テーブル
INSERT INTO conv_food_record_app.store_master (id, store_name, created_at, updated_at) VALUES
  (1, 'セブンイレブン', NOW(), NOW()),
  (2, 'ファミリーマート', NOW(), NOW()),
  (3, 'ローソン', NOW(), NOW()),
  (4, 'セイコーマート', NOW(), NOW()),
  (5, 'ミニストップ', NOW(), NOW()),
  (6, 'デイリーヤマザキ', NOW(), NOW()),
  (7, 'ポプラ', NOW(), NOW()),
  (8, 'その他', NOW(), NOW());


-- category_master テーブル
INSERT INTO conv_food_record_app.category_master (id, category_name, created_at, updated_at) VALUES
  (1, 'おにぎり', NOW(), NOW()),
  (2, 'パン', NOW(), NOW()),
  (3, 'ソフトドリンク', NOW(), NOW()),
  (4, '弁当', NOW(), NOW()),
  (5, 'デザート', NOW(), NOW()),
  (6, '麺類', NOW(), NOW()),
  (7, 'サラダ', NOW(), NOW()),
  (8, 'おかず・惣菜', NOW(), NOW()),
  (9, 'スナック', NOW(), NOW()),
  (10, 'アイスクリーム', NOW(), NOW()),
  (11, 'ホットスナック', NOW(), NOW()),
  (12, 'アルコール', NOW(), NOW()),
  (13, 'その他', NOW(), NOW());