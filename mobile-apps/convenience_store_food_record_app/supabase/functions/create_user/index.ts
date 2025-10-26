import { serve } from 'https://deno.land/std@0.168.0/http/server.ts';
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.38.0';
import { encode as hexEncode } from 'https://deno.land/std@0.168.0/encoding/hex.ts';

// SHA-256ハッシュ関数
async function sha256(text: string): Promise<string> {
	const encoder = new TextEncoder();
	const data = encoder.encode(text);
	const hashBuffer = await crypto.subtle.digest('SHA-256', data);
	const hashArray = new Uint8Array(hashBuffer);
	return new TextDecoder().decode(hexEncode(hashArray));
}

serve(async (req) => {
	try {
		if (req.method !== 'POST') {
			return new Response(JSON.stringify({ error: 'Method not allowed' }), { status: 405 });
		}

		const { userName, password, deviceId } = await req.json();
		if (!userName || !password || !deviceId) {
			return new Response(JSON.stringify({ error: 'userName, password, deviceIdは必須です' }), { status: 400 });
		}

		// 環境変数からSupabaseのURLとKeyを取得
		const supabaseUrl = Deno.env.get('PROJ_SUPABASE_URL')!;
		const supabaseKey = Deno.env.get('PROJ_SUPABASE_SERVICE_ROLE_KEY')!;

		const supabase = createClient(supabaseUrl, supabaseKey, {
			db: {
				schema: 'conv_food_record_app',
			},
		});

		// user_name重複チェック
		const { data: exists, error: existsError } = await supabase
			.from('user')
			.select('*')
			.eq('user_name', userName)
			.maybeSingle();
		if (existsError) {
			return new Response(JSON.stringify({ error: '重複チェック失敗', detail: existsError.message }), { status: 500 });
		}
		if (exists) {
			return new Response(JSON.stringify({ error: 'このユーザー名は既に使われています' }), { status: 409 });
		}

		// device_idで既存レコードを検索
		const { data: deviceRecord, error: deviceError } = await supabase
			.from('user')
			.select('*')
			.eq('device_id', deviceId)
			.maybeSingle();
		if (deviceError) {
			return new Response(JSON.stringify({ error: 'device_id検索失敗', detail: deviceError.message }), { status: 500 });
		}

		// パスワードをハッシュ化
		const hashedPassword = await sha256(password);
		const now = new Date().toISOString();

		if (deviceRecord) {
			// 既存レコードがあればupdate
			const { error: updateError } = await supabase
				.from('user')
				.update({
					user_name: userName,
					password: hashedPassword,
					updated_at: now,
				})
				.eq('device_id', deviceId);
			if (updateError) {
				return new Response(JSON.stringify({ error: 'ユーザー情報更新に失敗', detail: updateError.message }), { status: 500 });
			}
			return new Response(JSON.stringify({ success: true, updated: true }), { status: 200 });
		} else {
			// なければinsert
			const { error: insertError } = await supabase
				.from('user')
				.insert({
					user_name: userName,
					password: hashedPassword,
					device_id: deviceId,
					created_at: now,
				});
			if (insertError) {
				return new Response(JSON.stringify({ error: 'ユーザー登録に失敗', detail: insertError.message }), { status: 500 });
			}
			return new Response(JSON.stringify({ success: true, inserted: true }), { status: 201 });
		}
	} catch (e) {
		return new Response(JSON.stringify({ error: 'サーバーエラー', detail: e.message }), { status: 500 });
	}
});
