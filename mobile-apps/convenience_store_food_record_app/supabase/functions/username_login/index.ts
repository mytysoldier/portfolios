// supabase/functions/username_login/index.ts
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

    const { userName, password } = await req.json();

    // 環境変数からSupabaseのURLとKeyを取得
    const supabaseUrl = Deno.env.get('PROJ_SUPABASE_URL')!;
    const supabaseKey = Deno.env.get('PROJ_SUPABASE_SERVICE_ROLE_KEY')!;

    const supabase = createClient(supabaseUrl, supabaseKey, {
      db: {
        schema: 'conv_food_record_app'
      }
    });

    // userNameでユーザーを検索
    const { data, error } = await supabase
      .from('user')
      .select('*')
      .eq('user_name', userName)
      .single();
    console.log('Supabase user select result:', { data, error });

    if (error || !data) {
      return new Response(JSON.stringify({ error: 'ユーザー名またはパスワードが間違っています' }), { status: 401 });
    }

    // パスワード検証（SHA-256）
    const hashedPassword = await sha256(password);
    if (hashedPassword !== data.password) {
      return new Response(JSON.stringify({ error: 'ユーザー名またはパスワードが間違っています' }), { status: 401 });
    }

    // 認証成功
    delete data.password;
    return new Response(JSON.stringify({ success: true, user: data }), { status: 200 });
    } catch (e) {
        return new Response(JSON.stringify({ error: 'サーバーエラー', detail: e.message }), { status: 500 });
    }
});
