# スキーマ
CREATE SCHEMA conv_food_record_app;

-- スキーマのUSAGE権限をpublicロールに付与
GRANT USAGE ON SCHEMA conv_food_record_app TO public;

-- テーブルのSELECT権限をpublicロールに付与
GRANT SELECT ON ALL TABLES IN SCHEMA conv_food_record_app TO public;

-- テーブルのINSERT権限をpublicロールに付与
GRANT INSERT ON ALL TABLES IN SCHEMA conv_food_record_app TO public;

-- テーブルのDELETE権限をpublicロールに付与
GRANT DELETE ON ALL TABLES IN SCHEMA conv_food_record_app TO public;

-- スキーマ内のすべてのシーケンスの使用権限をpublicロールに付与
GRANT USAGE ON ALL SEQUENCES IN SCHEMA conv_food_record_app TO public;

# テーブル
GRANT ALL ON TABLE conv_food_record_app.user TO public;