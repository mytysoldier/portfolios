// Supabase Edge Function - 音声テキスト変換
// @ts-ignore - DenoランタイムではURLインポートがサポートされています
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
// @ts-ignore - DenoランタイムではURLインポートがサポートされています
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

// Deno環境の型宣言
declare const Deno: {
  env: {
    get(key: string): string | undefined
  }
}

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type, x-app-key',
}

// 型定義
interface WhisperResponse {
  text: string
}

// アプリキーの検証
function validateAppKey(req: Request): { valid: boolean; error?: string } {
  const expectedAppKey = Deno.env.get('ONE_MIN_VOICE_JOURNAL_APP_KEY')
  
  if (!expectedAppKey || expectedAppKey === '') {
    return { valid: false, error: 'アプリキーが設定されていません' }
  }
  
  const providedAppKey = req.headers.get('X-App-Key') || req.headers.get('x-app-key')
  
  if (!providedAppKey) {
    return { valid: false, error: 'X-App-Keyヘッダーが提供されていません' }
  }
  
  if (providedAppKey !== expectedAppKey) {
    return { valid: false, error: '無効なアプリキーです' }
  }
  
  return { valid: true }
}

// OpenAI APIキーの取得
function getOpenAIApiKey(): string {
  const apiKey = Deno.env.get('OPENAI_API_KEY')
  if (!apiKey || apiKey === '') {
    console.error('OPENAI_API_KEY is not set or empty')
    throw new Error('OPENAI_API_KEYが設定されていません')
  }
  
  return apiKey
}

// Whisper APIで音声をテキストに変換
async function transcribeAudio(
  audioFile: File,
  model: string = 'whisper-1',
  temperature: number = 0
): Promise<string> {
  let apiKey: string
  try {
    apiKey = getOpenAIApiKey()
  } catch (error) {
    console.error('Failed to get OpenAI API key:', error)
    throw error
  }

  const formData = new FormData()
  formData.append('file', audioFile)
  formData.append('model', model)
  formData.append('temperature', temperature.toString())

  const headers: HeadersInit = {
    'Authorization': `Bearer ${apiKey}`,
  }

  const response = await fetch('https://api.openai.com/v1/audio/transcriptions', {
    method: 'POST',
    headers: headers,
    body: formData,
  })

  if (!response.ok) {
    const errorText = await response.text()
    console.error(`Whisper API error (${response.status}):`, errorText)
    
    if (response.status === 401) {
      throw new Error('OpenAI APIの認証に失敗しました。APIキーを確認してください。')
    }
    
    throw new Error(`音声変換に失敗しました (status: ${response.status})`)
  }

  const data: WhisperResponse = await response.json()
  return data.text
}

serve(async (req) => {
  // CORS preflight リクエストの処理
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Supabaseクライアントの作成
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: req.headers.get('Authorization')! },
        },
      }
    )

    // POSTリクエストの処理
    if (req.method === 'POST') {
      // アプリキーの検証
      const appKeyValidation = validateAppKey(req)
      if (!appKeyValidation.valid) {
        return new Response(
          JSON.stringify({ error: appKeyValidation.error }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 401,
          }
        )
      }

      const contentType = req.headers.get('content-type') || ''
      
      if (!contentType.includes('multipart/form-data')) {
        return new Response(
          JSON.stringify({ 
            error: 'multipart/form-data形式で音声ファイルを送信してください。' 
          }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
          }
        )
      }

      const formData = await req.formData()
      const audioFile = formData.get('file') as File
      
      if (!audioFile) {
        return new Response(
          JSON.stringify({ error: '音声ファイルが提供されていません' }),
          {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
            status: 400,
          }
        )
      }

      // 音声をテキストに変換
      const transcript = await transcribeAudio(audioFile)

      return new Response(
        JSON.stringify({
          transcript,
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        }
      )
    }

    // POST以外のメソッド
    return new Response(
      JSON.stringify({ 
        error: `メソッド ${req.method} はサポートされていません。POSTメソッドを使用してください。` 
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 405,
      }
    )
  } catch (error) {
    console.error('Error:', error instanceof Error ? error.message : String(error))
    return new Response(
      JSON.stringify({ 
        error: error instanceof Error ? error.message : '予期しないエラーが発生しました'
      }),
      {
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
